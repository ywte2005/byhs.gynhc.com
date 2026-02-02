<?php
namespace app\common\model\merchant;

use think\Model;

class Merchant extends Model
{
    protected $name = 'merchant';
    protected $autoWriteTimestamp = true;

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
        if ($merchant) {
            throw new \Exception('您已提交过商户申请');
        }

        return self::create([
            'user_id' => $userId,
            'merchant_no' => self::generateMerchantNo(),
            'name' => $data['name'] ?? '',
            'legal_name' => $data['legal_name'] ?? '',
            'id_card' => $data['id_card'] ?? '',
            'id_card_front' => $data['id_card_front'] ?? '',
            'id_card_back' => $data['id_card_back'] ?? '',
            'business_license' => $data['business_license'] ?? '',
            'bank_name' => $data['bank_name'] ?? '',
            'bank_account' => $data['bank_account'] ?? '',
            'bank_branch' => $data['bank_branch'] ?? '',
            'contact_phone' => $data['contact_phone'] ?? '',
            'entry_fee' => $data['entry_fee'] ?? 0,
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
