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

    public static function getByUserMonth($userId, $month)
    {
        return self::where('user_id', $userId)->where('month', $month)->find();
    }

    public static function updatePerformance($userId, $month, $personalAmount = 0, $teamAmount = 0)
    {
        $record = self::getByUserMonth($userId, $month);
        if (!$record) {
            return self::create([
                'user_id' => $userId,
                'month' => $month,
                'personal_amount' => $personalAmount,
                'team_amount' => $teamAmount,
                'growth_amount' => 0,
                'direct_count' => 0
            ]);
        }
        $record->personal_amount = bcadd($record->personal_amount, $personalAmount, 2);
        $record->team_amount = bcadd($record->team_amount, $teamAmount, 2);
        $record->save();
        return $record;
    }

    public static function calculateGrowth($userId, $month)
    {
        $current = self::getByUserMonth($userId, $month);
        $prevMonth = date('Y-m', strtotime($month . '-01 -1 month'));
        $prev = self::getByUserMonth($userId, $prevMonth);
        
        $currentTotal = $current ? bcadd($current->personal_amount, $current->team_amount, 2) : '0.00';
        $prevTotal = $prev ? bcadd($prev->personal_amount, $prev->team_amount, 2) : '0.00';
        
        return bcsub($currentTotal, $prevTotal, 2);
    }
}
