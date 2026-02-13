<?php
namespace app\common\library;

use app\common\model\merchant\Merchant;
use app\common\model\merchant\MerchantAudit;
use think\Db;

class MerchantService
{
    public static function getMerchant($userId)
    {
        return Merchant::getByUserId($userId);
    }

    public static function register($userId, $data)
    {
        // 从配置表获取入驻费
        $merchantType = $data['type'] ?? 'personal';
        $entryFee = \app\common\model\merchant\EntryFeeConfig::getEntryFee($merchantType);
        
        // 确保入驻费被正确设置
        if (!isset($data['entry_fee']) || $data['entry_fee'] === null) {
            $data['entry_fee'] = $entryFee;
        }
        
        return Merchant::register($userId, $data);
    }

    public static function approve($merchantIds, $adminId = 0)
    {
        $ids = is_array($merchantIds) ? $merchantIds : explode(',', $merchantIds);
        $count = 0;
        Db::startTrans();
        try {
            foreach ($ids as $merchantId) {
                $merchant = Merchant::lock(true)->find($merchantId);
                if ($merchant && $merchant->status === 'pending') {
                    $merchant->approve($adminId);
                    $count++;
                }
            }
            Db::commit();
            return $count;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function reject($merchantIds, $reason, $adminId = 0)
    {
        $ids = is_array($merchantIds) ? $merchantIds : explode(',', $merchantIds);
        $count = 0;
        Db::startTrans();
        try {
            foreach ($ids as $merchantId) {
                $merchant = Merchant::lock(true)->find($merchantId);
                if ($merchant && $merchant->status === 'pending') {
                    $merchant->reject($reason, $adminId);
                    $count++;
                }
            }
            Db::commit();
            return $count;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function payEntryFee($userId, $payMethod = 'balance')
    {
        Db::startTrans();
        try {
            $merchant = Merchant::where('user_id', $userId)->lock(true)->find();
            if (!$merchant) {
                throw new \Exception('商户不存在');
            }
            if ($merchant->status !== 'approved') {
                throw new \Exception('商户未通过审核');
            }
            if ($merchant->entry_fee_paid) {
                throw new \Exception('入驻费已支付');
            }
            
            $entryFee = $merchant->entry_fee;
            
            // 如果入驻费为0，直接标记为已支付
            if (bccomp($entryFee, '0', 2) == 0) {
                $merchant->entry_fee_paid = 1;
                $merchant->save();
                Db::commit();
                return $merchant;
            }
            
            // 入驻费大于0，从钱包扣款
            if (bccomp($entryFee, '0', 2) > 0) {
                WalletService::changeBalance($userId, '-' . $entryFee, 'entry_fee', $merchant->id, '商户入驻费');
            }
            
            $merchant->entry_fee_paid = 1;
            $merchant->save();
            
            // 触发推广奖励
            if (bccomp($entryFee, '0', 2) > 0) {
                RewardService::triggerReward('merchant_entry', $userId, $entryFee, $merchant->id);
            }
            
            Db::commit();
            return $merchant;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function getAuditStatus($userId)
    {
        $merchant = self::getMerchant($userId);
        if (!$merchant) {
            return ['status' => 'none', 'message' => '未提交申请'];
        }
        
        // 如果商户记录中的 entry_fee 为 0，尝试从配置表重新获取
        if ($merchant->entry_fee == 0 || $merchant->entry_fee === '0.00') {
            $entryFee = \app\common\model\merchant\EntryFeeConfig::getEntryFee($merchant->type);
            // 更新商户记录中的入驻费
            if ($entryFee && $entryFee != '0.00') {
                $merchant->entry_fee = $entryFee;
                $merchant->save();
            }
        }
        
        $statusMap = [
            'pending' => '审核中',
            'approved' => $merchant->entry_fee_paid ? '已入驻' : '待支付入驻费',
            'rejected' => '已拒绝',
            'disabled' => '已禁用'
        ];
        
        // 获取用户钱包余额
        $wallet = \app\common\model\wallet\Wallet::getByUserId($userId);
        
        return [
            'status' => $merchant->status,
            'message' => $statusMap[$merchant->status] ?? '',
            'reject_reason' => $merchant->reject_reason,
            'entry_fee' => $merchant->entry_fee,
            'entry_fee_paid' => $merchant->entry_fee_paid,
            'wallet_balance' => $wallet ? $wallet->balance : '0.00'
        ];
    }

    public static function updateMerchant($userId, $data)
    {
        $merchant = Merchant::where('user_id', $userId)->find();
        if (!$merchant) {
            throw new \Exception('商户不存在');
        }
        
        $allowFields = ['name', 'legal_name', 'contact_phone', 'contact_address', 'category', 
                        'bank_name', 'bank_account', 'bank_branch'];
        
        foreach ($allowFields as $field) {
            if (isset($data[$field])) {
                $merchant->$field = $data[$field];
            }
        }
        
        $merchant->save();
        return $merchant;
    }
}
