<?php
namespace app\common\model\config;

use think\Model;

class ProfitRule extends Model
{
    protected $name = 'profit_rule';
    protected $autoWriteTimestamp = true;

    public static function getByLevelDiff($levelDiff)
    {
        return self::where('level_diff', $levelDiff)->where('status', 'normal')->find();
    }

    public static function getAll($status = 'normal')
    {
        return self::where('status', $status)->order('level_diff', 'asc')->select();
    }
}
