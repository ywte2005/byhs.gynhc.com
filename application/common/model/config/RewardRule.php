<?php
namespace app\common\model\config;

use think\Model;

class RewardRule extends Model
{
    protected $name = 'reward_rule';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['scene_text', 'reward_type_text', 'amount_type_text'];

    public function getSceneTextAttr($value, $data)
    {
        $list = ['merchant_entry' => '商户入驻', 'order_complete' => '刷单完成', 'level_upgrade' => '等级升级'];
        return isset($list[$data['scene']]) ? $list[$data['scene']] : '';
    }

    public function getRewardTypeTextAttr($value, $data)
    {
        $list = ['direct' => '直推奖', 'indirect' => '间推奖', 'level_diff' => '等级差分润', 'peer' => '平级奖', 'team' => '团队奖'];
        return isset($list[$data['reward_type']]) ? $list[$data['reward_type']] : '';
    }

    public function getAmountTypeTextAttr($value, $data)
    {
        $list = ['fixed' => '固定金额', 'percent' => '比例'];
        return isset($list[$data['amount_type']]) ? $list[$data['amount_type']] : '';
    }

    public static function getRulesByScene($scene)
    {
        return self::where('scene', $scene)->where('status', 'normal')->select();
    }

    public static function getRulesBySceneAndType($scene, $rewardType)
    {
        return self::where('scene', $scene)->where('reward_type', $rewardType)->where('status', 'normal')->find();
    }
}
