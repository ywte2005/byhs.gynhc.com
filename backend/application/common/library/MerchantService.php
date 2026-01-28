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
            if (bccomp($entryFee, '0', 2) > 0) {
                WalletService::changeBalance($userId, '-' . $entryFee, 'entry_fee', $merchant->id, '商户入驻费');
            }
            
            $merchant->entry_fee_paid = 1;
            $merchant->save();
            
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
        
        $statusMap = [
            'pending' => '审核中',
            'approved' => $merchant->entry_fee_paid ? '已入驻' : '待支付入驻费',
            'rejected' => '已拒绝',
            'disabled' => '已禁用'
        ];
        
        return [
            'status' => $merchant->status,
            'message' => $statusMap[$merchant->status] ?? '',
            'reject_reason' => $merchant->reject_reason,
            'entry_fee' => $merchant->entry_fee,
            'entry_fee_paid' => $merchant->entry_fee_paid
        ];
    }
}
