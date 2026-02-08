<?php
namespace app\common\model\promo;

use think\Model;

class BonusConfig extends Model
{
    protected $name = 'promo_bonus_config';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    public static function getAll($status = 'normal')
    {
        return self::where('status', $status)->order('sort', 'asc')->select();
    }

    public static function getQualifiedConfigs($teamPerformance, $personalPerformance, $qualifiedCount, $growth)
    {
        return self::where('status', 'normal')
            ->where('team_performance_min', '<=', $teamPerformance)
            ->where('personal_performance_min', '<=', $personalPerformance)
            ->where('qualified_count_min', '<=', $qualifiedCount)
            ->where('growth_min', '<=', $growth)
            ->order('sort', 'asc')
            ->select();
    }
}
