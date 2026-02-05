<?php
namespace app\command;

use think\console\Command;
use think\console\Input;
use think\console\Output;
use app\common\model\promo\Performance as PerformanceModel;
use think\Db;

/**
 * 业绩统计快照命令
 * 用法: php think performance:snapshot [date]
 * 示例: php think performance:snapshot 2025-01-31
 * 定时任务: 0 0 * * * php /path/to/think performance:snapshot
 */
class Performance extends Command
{
    protected function configure()
    {
        $this->setName('performance:snapshot')
            ->setDescription('生成业绩统计快照')
            ->addArgument('date', \think\console\input\Argument::OPTIONAL, '日期(格式:Y-m-d)');
    }

    protected function execute(Input $input, Output $output)
    {
        $date = $input->getArgument('date');
        if (!$date) {
            $date = date('Y-m-d', strtotime('yesterday'));
        }
        
        $month = substr($date, 0, 7); // Y-m
        
        $output->writeln("开始生成 {$date} 的业绩统计快照（月份：{$month}）...");
        
        try {
            $this->generateSnapshot($month, $output);
            $output->writeln("<info>业绩统计快照生成完成</info>");
            return 0;
        } catch (\Exception $e) {
            $output->writeln("<error>业绩统计快照生成失败: " . $e->getMessage() . "</error>");
            return 1;
        }
    }

    /**
     * 生成业绩统计快照
     */
    protected function generateSnapshot($month, Output $output)
    {
        $startTime = strtotime($month . '-01 00:00:00');
        $endTime = strtotime($month . '-01 +1 month -1 second');
        
        // 获取所有有业绩的用户
        $userIds = Db::name('sub_task')
            ->where('status', 'completed')
            ->whereTime('completed_time', 'between', [$startTime, $endTime])
            ->column('DISTINCT to_user_id');
        
        $output->writeln("找到 " . count($userIds) . " 个有业绩的用户");
        
        $count = 0;
        foreach ($userIds as $userId) {
            try {
                // 计算个人业绩
                $personalAmount = Db::name('sub_task')
                    ->where('to_user_id', $userId)
                    ->where('status', 'completed')
                    ->whereTime('completed_time', 'between', [$startTime, $endTime])
                    ->sum('amount') ?: 0;
                
                // 计算团队业绩
                $relation = \app\common\model\promo\Relation::getByUserId($userId);
                $teamAmount = 0;
                
                if ($relation && $relation->path) {
                    // 获取所有下级
                    $teamUserIds = Db::name('promo_relation')
                        ->where('path', 'like', "%{$userId}%")
                        ->column('user_id');
                    
                    if (!empty($teamUserIds)) {
                        $teamAmount = Db::name('sub_task')
                            ->whereIn('to_user_id', $teamUserIds)
                            ->where('status', 'completed')
                            ->whereTime('completed_time', 'between', [$startTime, $endTime])
                            ->sum('amount') ?: 0;
                    }
                }
                
                // 更新或创建业绩记录
                PerformanceModel::updatePerformance($userId, $month, $personalAmount, $teamAmount);
                $count++;
                
            } catch (\Exception $e) {
                $output->writeln("<error>处理用户 {$userId} 失败: " . $e->getMessage() . "</error>");
            }
        }
        
        $output->writeln("成功更新 {$count} 个用户的业绩统计");
        
        // 更新所有上级的团队业绩
        $this->updateParentTeamPerformance($month, $output);
    }

    /**
     * 更新所有上级的团队业绩
     */
    protected function updateParentTeamPerformance($month, Output $output)
    {
        $output->writeln("开始更新上级团队业绩...");
        
        // 获取所有有下级的用户
        $parentIds = Db::name('promo_relation')
            ->where('path', '<>', '')
            ->column('DISTINCT parent_id');
        
        $count = 0;
        foreach ($parentIds as $parentId) {
            if (!$parentId) continue;
            
            try {
                // 获取所有下级
                $teamUserIds = Db::name('promo_relation')
                    ->where('path', 'like', "%{$parentId}%")
                    ->column('user_id');
                
                if (empty($teamUserIds)) continue;
                
                // 计算团队业绩总和
                $teamAmount = PerformanceModel::where('period', $period)
                    ->whereIn('user_id', $teamUserIds)
                    ->sum('personal_performance') ?: 0;
                
                // 更新团队业绩
                $performance = PerformanceModel::getByUserMonth($parentId, $period);
                if ($performance) {
                    $performance->team_performance = $teamAmount;
                    $performance->save();
                } else {
                    PerformanceModel::updatePerformance($parentId, $month, 0, $teamAmount);
                }
                
                $count++;
                
            } catch (\Exception $e) {
                $output->writeln("<error>更新用户 {$parentId} 团队业绩失败: " . $e->getMessage() . "</error>");
            }
        }
        
        $output->writeln("成功更新 {$count} 个用户的团队业绩");
    }
}
