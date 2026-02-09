<?php
namespace app\common\model\promo;

use think\Model;

class Commission extends Model
{
    protected $name = 'promo_commission';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = false;

    protected $append = [
        'status_text',
        'scene_text',
        'reward_type_text'
    ];

    public function getStatusTextAttr($value, $data)
    {
        $list = ['pending' => '待结算', 'settled' => '已结算', 'cancelled' => '已取消'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function getSceneTextAttr($value, $data)
    {
        $list = [
            'merchant_entry' => '商户入驻',
            'order_complete' => '刷单完成',
            'level_upgrade' => '等级升级'
        ];
        return isset($list[$data['scene']]) ? $list[$data['scene']] : $data['scene'];
    }

    public function getRewardTypeTextAttr($value, $data)
    {
        $list = [
            'direct' => '直推奖',
            'indirect' => '间推奖',
            'level_diff' => '等级差分润',
            'peer' => '平级奖',
            'team' => '团队奖'
        ];
        return isset($list[$data['reward_type']]) ? $list[$data['reward_type']] : $data['reward_type'];
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function sourceUser()
    {
        return $this->belongsTo('app\common\model\User', 'source_user_id', 'id');
    }

    public static function createCommission($userId, $sourceUserId, $scene, $rewardType, $baseAmount, $amount, $ruleId = 0, $remark = '')
    {
        return self::create([
            'user_id' => $userId,
            'source_user_id' => $sourceUserId,
            'scene' => $scene,
            'reward_type' => $rewardType,
            'rule_id' => $ruleId,
            'base_amount' => $baseAmount,
            'amount' => $amount,
            'status' => 'pending',
            'remark' => $remark
        ]);
    }

    public static function getUserCommissions($userId, $page = 1, $limit = 20)
    {
        return self::where('user_id', $userId)
            ->order('id', 'desc')
            ->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function getUserTotalCommission($userId, $status = null)
    {
        $query = self::where('user_id', $userId);
        if ($status !== null) {
            $query->where('status', $status);
        }
        return $query->sum('amount');
    }
}
