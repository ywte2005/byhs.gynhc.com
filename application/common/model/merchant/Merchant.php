<?php
namespace app\common\model\merchant;

use think\Model;

class Merchant extends Model
{
    protected $name = 'merchant';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text'];

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['merchant_no'])) {
                $row['merchant_no'] = self::generateMerchantNo();
            }
        });
    }

    public function getStatusTextAttr($value, $data)
    {
        $list = ['pending' => '待审核', 'approved' => '已通过', 'rejected' => '已拒绝', 'disabled' => '已禁用'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public static function getByUserId($userId)
    {
        return self::where('user_id', $userId)->find();
    }

    public static function generateMerchantNo()
    {
        return 'M' . date('Ymd') . str_pad(mt_rand(1, 99999), 5, '0', STR_PAD_LEFT);
    }

    public static function register($userId, $data)
    {
        $merchant = self::getByUserId($userId);
        
        // 如果已存在商户记录
        if ($merchant) {
            // 只有在被拒绝的情况下才允许重新提交
            if ($merchant->status === 'rejected') {
                // 更新现有记录
                $merchant->type = $data['type'] ?? 'individual';
                $merchant->name = $data['name'] ?? '';
                $merchant->legal_name = $data['contact'] ?? '';
                $merchant->id_card = $data['id_card'] ?? '';
                $merchant->id_card_front = $data['id_card_front'] ?? '';
                $merchant->id_card_back = $data['id_card_back'] ?? '';
                $merchant->business_license = $data['business_license'] ?? '';
                $merchant->contact_phone = $data['contact_phone'] ?? '';
                $merchant->bank_name = $data['bank_name'] ?? '';
                $merchant->bank_account = $data['bank_account'] ?? '';
                $merchant->bank_branch = $data['bank_branch'] ?? '';
                $merchant->status = 'pending';
                $merchant->reject_reason = '';
                $merchant->save();
                return $merchant;
            } else {
                // 其他状态不允许重新提交
                $statusText = [
                    'pending' => '您的申请正在审核中，请耐心等待',
                    'approved' => '您已通过审核',
                    'disabled' => '您的商户已被禁用，请联系客服'
                ];
                throw new \Exception($statusText[$merchant->status] ?? '您已提交过商户申请');
            }
        }

        // 创建新记录
        return self::create([
            'user_id' => $userId,
            'merchant_no' => self::generateMerchantNo(),
            'type' => $data['type'] ?? 'individual',
            'name' => $data['name'] ?? '',
            'legal_name' => $data['contact'] ?? '',
            'id_card' => $data['id_card'] ?? '',
            'id_card_front' => $data['id_card_front'] ?? '',
            'id_card_back' => $data['id_card_back'] ?? '',
            'business_license' => $data['business_license'] ?? '',
            'contact_phone' => $data['contact_phone'] ?? '',
            'bank_name' => $data['bank_name'] ?? '',
            'bank_account' => $data['bank_account'] ?? '',
            'bank_branch' => $data['bank_branch'] ?? '',
            'entry_fee' => $data['entry_fee'] ?? 0,
            'entry_fee_paid' => 0,
            'status' => 'pending'
        ]);
    }

    public function approve($adminId = 0)
    {
        $this->status = 'approved';
        $this->approved_time = time();
        $this->save();

        MerchantAudit::create([
            'merchant_id' => $this->id,
            'admin_id' => $adminId,
            'action' => 'approve',
            'remark' => '审核通过'
        ]);

        return true;
    }

    public function reject($reason, $adminId = 0)
    {
        $this->status = 'rejected';
        $this->reject_reason = $reason;
        $this->save();

        MerchantAudit::create([
            'merchant_id' => $this->id,
            'admin_id' => $adminId,
            'action' => 'reject',
            'remark' => $reason
        ]);

        return true;
    }
}
