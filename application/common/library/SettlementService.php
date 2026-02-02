<?php
namespace app\common\library;

use app\common\model\task\MutualTask;
use app\common\model\task\SubTask;
use app\common\model\promo\Performance;
use app\common\model\promo\Bonus;
use app\common\model\promo\BonusConfig;
use app\common\model\promo\Relation;
use app\common\library\PromoService;
use think\Db;

class SettlementService
{
    public static function settleSubTask($subTask)
    {
        Db::startTrans();
        try {
            $task = MutualTask::find($subTask->task_id);
            
            $toUserId = $subTask->to_user_id;
            $fromUserId = $subTask->from_user_id;
            $amount = $subTask->amount;
            $commission = $subTask->commission;
            $serviceFee = $subTask->service_fee;
            
            $totalToUser = bcadd($amount, $commission, 2);
            WalletService::changeBalance($toUserId, $totalToUser, 'subtask_complete', $subTask->id, '刷单收入+佣金');
            
            WalletService::changeMutualBalance($toUserId, $amount, 'subtask_complete', $subTask->id, '帮刷增加互助余额');
            
            WalletService::unfreezeDeposit($fromUserId, $amount, 'subtask_complete', $subTask->id, '子任务完成解冻');
            WalletService::changeDeposit($fromUserId, '-' . $amount, 'subtask_complete', $subTask->id, '子任务完成扣除');
            WalletService::changeDeposit($fromUserId, '-' . $serviceFee, 'service_fee', $subTask->id, '服务费');
            
            WalletService::changeMutualBalance($fromUserId, '-' . $amount, 'subtask_complete', $subTask->id, '被刷减少互助余额');
            
            $task->frozen_amount = bcsub($task->frozen_amount, $amount, 2);
            $task->save();
            
            RewardService::updatePerformance($toUserId, $amount);
            
            RewardService::triggerReward('order_complete', $toUserId, $amount, $subTask->id);
            
            // 检查是否满足自动升级条件
            PromoService::checkAutoUpgrade($toUserId);
            
            Db::commit();
            return true;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function calculateMonthlyBonus($month)
    {
        $totalAmount = SubTask::where('status', 'completed')
            ->whereTime('completed_time', 'between', [
                strtotime($month . '-01'),
                strtotime($month . '-01 +1 month')
            ])
            ->sum('amount');
        
        if (bccomp($totalAmount, '0', 2) <= 0) {
            return [];
        }
        
        $configs = BonusConfig::getAll();
        $results = [];
        
        foreach ($configs as $config) {
            $poolAmount = bcmul($totalAmount, $config->pool_rate, 2);
            
            $qualifiedUsers = self::getQualifiedUsers($config, $month);
            $qualifiedCount = count($qualifiedUsers);
            
            if ($qualifiedCount <= 0) {
                continue;
            }
            
            $bonusPerUser = bcdiv($poolAmount, $qualifiedCount, 2);
            
            foreach ($qualifiedUsers as $userId) {
                $bonus = Bonus::create([
                    'user_id' => $userId,
                    'config_id' => $config->id,
                    'month' => $month,
                    'pool_amount' => $poolAmount,
                    'qualified_count' => $qualifiedCount,
                    'amount' => $bonusPerUser,
                    'status' => 'pending'
                ]);
                $results[] = $bonus;
            }
        }
        
        return $results;
    }

    protected static function getQualifiedUsers($config, $month)
    {
        $performances = Performance::where('month', $month)->select();
        $qualifiedUsers = [];
        
        foreach ($performances as $perf) {
            if (bccomp($perf->team_amount, $config->team_performance_min, 2) < 0) {
                continue;
            }
            if (bccomp($perf->personal_amount, $config->personal_performance_min, 2) < 0) {
                continue;
            }
            
            $growth = Performance::calculateGrowth($perf->user_id, $month);
            if (bccomp($growth, $config->growth_min, 2) < 0) {
                continue;
            }
            
            $directCount = Relation::getDirectChildren($perf->user_id)->count();
            if ($directCount < $config->qualified_count_min) {
                continue;
            }
            
            $qualifiedUsers[] = $perf->user_id;
        }
        
        return $qualifiedUsers;
    }

    public static function settleBonus($bonusId)
    {
        Db::startTrans();
        try {
            $bonus = Bonus::lock(true)->find($bonusId);
            if (!$bonus || $bonus->status !== 'pending') {
                throw new \Exception('分红记录不存在或已处理');
            }
            
            WalletService::changeBalance($bonus->user_id, $bonus->amount, 'bonus', $bonus->id, '月度分红');
            
            $bonus->status = 'settled';
            $bonus->settle_time = time();
            $bonus->save();
            
            Db::commit();
            return $bonus;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function settlePendingBonuses($month)
    {
        $bonuses = Bonus::where('month', $month)->where('status', 'pending')->select();
        foreach ($bonuses as $bonus) {
            try {
                self::settleBonus($bonus->id);
            } catch (\Exception $e) {
                continue;
            }
        }
    }
}
