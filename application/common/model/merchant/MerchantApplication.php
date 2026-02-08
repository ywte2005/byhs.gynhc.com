<?php
namespace app\common\model\merchant;

use think\Model;

class MerchantApplication extends Model
{
    protected $name = 'merchant_application';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text', 'type_text'];

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['application_no'])) {
                $row['application_no'] = self::generateApplicationNo();
            }
        });
    }

    public function getStatusTextAttr($value, $data)
    {
        $list = ['pending' => '待审核', 'approved' => '已通过', 'rejected' => '已驳回'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function getTypeTextAttr($value, $data)
    {
        $list = ['personal' => '个人', 'individual' => '个体', 'enterprise' => '企业'];
        return isset($list[$data['type']]) ? $list[$data['type']] : '';
    }

    public function merchant()
    {
        return $this->belongsTo('app\common\model\merchant\Merchant', 'merchant_id', 'id');
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public static function generateApplicationNo()
    {
        return 'JJ' . date('Ymd') . str_pad(mt_rand(1, 99999), 5, '0', STR_PAD_LEFT);
    }

    /**
     * 获取商户的进件列表
     */
    public static function getListByMerchant($merchantId, $status = null, $page = 1, $pageSize = 10)
    {
        $query = self::where('merchant_id', $merchantId);
        
        if ($status && $status !== 'all') {
            $query->where('status', $status);
        }
        
        $total = $query->count();
        $list = $query->order('id', 'desc')
            ->page($page, $pageSize)
            ->select();
        
        return [
            'list' => $list,
            'total' => $total
        ];
    }

    /**
     * 获取用户的进件列表
     */
    public static function getListByUser($userId, $status = null, $page = 1, $pageSize = 10)
    {
        $query = self::where('user_id', $userId);
        
        if ($status && $status !== 'all') {
            $query->where('status', $status);
        }
        
        $total = $query->count();
        $list = $query->order('id', 'desc')
            ->page($page, $pageSize)
            ->select();
        
        return [
            'list' => $list,
            'total' => $total
        ];
    }

    /**
     * 提交进件申请
     */
    public static function submit($userId, $merchantId, $data)
    {
        return self::create([
            'user_id' => $userId,
            'merchant_id' => $merchantId,
            'application_no' => self::generateApplicationNo(),
            'channel' => $data['channel'] ?? '',
            'type' => $data['type'] ?? 'individual',
            'name' => $data['name'] ?? '',
            'id_card' => $data['id_card'] ?? '',
            'contact_name' => $data['contact_name'] ?? $data['contact'] ?? '',
            'contact_phone' => $data['contact_phone'] ?? '',
            'category' => $data['category'] ?? '',
            'category_code' => $data['category_code'] ?? '',
            'address' => $data['address'] ?? '',
            'business_license' => $data['business_license'] ?? '',
            'id_card_front' => $data['id_card_front'] ?? '',
            'id_card_back' => $data['id_card_back'] ?? '',
            'shop_front' => $data['shop_front'] ?? '',
            'other_files' => $data['other_files'] ?? '',
            'status' => 'pending'
        ]);
    }

    /**
     * 审核通过
     */
    public function approve($adminId = 0)
    {
        $this->status = 'approved';
        $this->approved_time = time();
        $this->admin_id = $adminId;
        $this->save();
        return true;
    }

    /**
     * 审核驳回
     */
    public function reject($reason, $adminId = 0)
    {
        $this->status = 'rejected';
        $this->reject_reason = $reason;
        $this->admin_id = $adminId;
        $this->save();
        return true;
    }
}
