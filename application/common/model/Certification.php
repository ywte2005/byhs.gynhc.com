<?php
namespace app\common\model;

use think\Model;

/**
 * 实名认证模型
 */
class Certification extends Model
{
    protected $name = 'certification';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text', 'type_text'];

    // 认证类型
    public static $types = [
        'personal' => '个人认证',
        'enterprise' => '企业认证'
    ];

    // 认证状态
    public static $statuses = [
        'pending' => '待审核',
        'approved' => '已通过',
        'rejected' => '已拒绝'
    ];

    public function getStatusTextAttr($value, $data)
    {
        return self::$statuses[$data['status']] ?? '';
    }

    public function getTypeTextAttr($value, $data)
    {
        return self::$types[$data['type']] ?? '';
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    /**
     * 获取用户的认证信息
     */
    public static function getByUserId($userId)
    {
        return self::where('user_id', $userId)->order('id', 'desc')->find();
    }

    /**
     * 提交认证申请
     */
    public static function submit($userId, $data)
    {
        // 检查是否有待审核的申请
        $existing = self::where('user_id', $userId)->where('status', 'pending')->find();
        if ($existing) {
            throw new \Exception('您有待审核的认证申请，请等待审核结果');
        }

        // 检查是否已通过认证
        $approved = self::where('user_id', $userId)->where('status', 'approved')->find();
        if ($approved) {
            throw new \Exception('您已通过实名认证');
        }

        return self::create([
            'user_id' => $userId,
            'type' => $data['type'] ?? 'personal',
            'name' => $data['name'] ?? '',
            'id_card' => $data['id_card'] ?? '',
            'id_card_front' => $data['id_card_front'] ?? '',
            'id_card_back' => $data['id_card_back'] ?? '',
            'contact_phone' => $data['contact_phone'] ?? '',
            'enterprise_name' => $data['enterprise_name'] ?? '',
            'credit_code' => $data['credit_code'] ?? '',
            'business_license' => $data['business_license'] ?? '',
            'status' => 'pending'
        ]);
    }

    /**
     * 审核通过
     */
    public function approve($adminId = 0)
    {
        $this->status = 'approved';
        $this->admin_id = $adminId;
        $this->audit_time = time();
        $this->save();

        // 更新用户的认证状态
        $user = \app\common\model\User::get($this->user_id);
        if ($user) {
            $verification = $user->verification;
            $verification->realname = 1;
            $user->verification = $verification;
            $user->save();
        }

        return true;
    }

    /**
     * 审核拒绝
     */
    public function reject($reason, $adminId = 0)
    {
        $this->status = 'rejected';
        $this->reject_reason = $reason;
        $this->admin_id = $adminId;
        $this->audit_time = time();
        $this->save();

        return true;
    }
}
