<?php
namespace app\common\model\promo;

use think\Model;

class Performance extends Model
{
    protected $name = 'promo_performance';
    protected $autoWriteTimestamp = 'updatetime';
    protected $createTime = false;

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public static function getByUserMonth($userId, $period)
    {
        return self::where('user_id', $userId)->where('period', $period)->find();
    }

    public static function updatePerformance($userId, $period, $personalAmount = 0, $teamAmount = 0)
    {
        $record = self::getByUserMonth($userId, $period);
        if (!$record) {
            return self::create([
                'user_id' => $userId,
                'period' => $period,
                'personal_performance' => $personalAmount,
                'team_performance' => $teamAmount,
                'growth' => 0,
                'direct_invite_count' => 0,
                'team_member_count' => 0
            ]);
        }
        $record->personal_performance = bcadd($record->personal_performance, $personalAmount, 2);
        $record->team_performance = bcadd($record->team_performance, $teamAmount, 2);
        $record->save();
        return $record;
    }

    public static function calculateGrowth($userId, $period)
    {
        $current = self::getByUserMonth($userId, $period);
        $prevPeriod = date('Y-m', strtotime($period . '-01 -1 month'));
        $prev = self::getByUserMonth($userId, $prevPeriod);
        
        $currentTotal = $current ? bcadd($current->personal_performance, $current->team_performance, 2) : '0.00';
        $prevTotal = $prev ? bcadd($prev->personal_performance, $prev->team_performance, 2) : '0.00';
        
        return bcsub($currentTotal, $prevTotal, 2);
    }
}
