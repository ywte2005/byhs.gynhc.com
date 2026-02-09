<?php
namespace app\command;

use think\console\Command;
use think\console\Input;
use think\console\Output;
use app\common\library\SettlementService;

/**
 * 月度分红计算命令
 * 
 * 手动执行:
 *   php think bonus:calculate [month]
 *   示例: php think bonus:calculate 2025-01
 * 
 * 自动执行（根据后台配置的统计日和发放日）:
 *   php think bonus:auto
 *   定时任务: 0 0 * * * php /path/to/think bonus:auto
 */
class Bonus extends Command
{
    protected function configure()
    {
        $this->setName('bonus')
            ->setDescription('月度分红管理')
            ->addArgument('action', \think\console\input\Argument::OPTIONAL, '操作: calculate/settle/auto', 'auto')
            ->addArgument('month', \think\console\input\Argument::OPTIONAL, '月份(格式:Y-m)');
    }

    protected function execute(Input $input, Output $output)
    {
        $action = $input->getArgument('action');
        $month = $input->getArgument('month');
        
        switch ($action) {
            case 'calculate':
                return $this->calculate($output, $month);
            case 'settle':
                return $this->settle($output, $month);
            case 'auto':
            default:
                return $this->auto($output);
        }
    }

    /**
     * 手动计算分红
     */
    protected function calculate(Output $output, $month = null)
    {
        if (!$month) {
            $month = date('Y-m', strtotime('last month'));
        }
        
        $output->writeln("开始计算 {$month} 月度分红...");
        
        try {
            $results = SettlementService::calculateMonthlyBonus($month);
            $output->writeln("分红计算完成，生成 " . count($results) . " 条分红记录");
        } catch (\Exception $e) {
            $output->writeln("<error>分红计算失败: " . $e->getMessage() . "</error>");
            return 1;
        }
        
        return 0;
    }

    /**
     * 手动发放分红
     */
    protected function settle(Output $output, $month = null)
    {
        if (!$month) {
            $month = date('Y-m', strtotime('last month'));
        }
        
        $output->writeln("开始发放 {$month} 月度分红...");
        
        try {
            SettlementService::settlePendingBonuses($month);
            $output->writeln("分红发放完成");
        } catch (\Exception $e) {
            $output->writeln("<error>分红发放失败: " . $e->getMessage() . "</error>");
            return 1;
        }
        
        return 0;
    }

    /**
     * 自动执行（根据后台配置的日期）
     */
    protected function auto(Output $output)
    {
        $calculateDay = SettlementService::getBonusCalculateDay();
        $settleDay = SettlementService::getBonusSettleDay();
        $today = date('j');
        $prevMonth = date('Y-m', strtotime('-1 month'));
        
        $output->writeln("分红配置: 统计日={$calculateDay}号, 发放日={$settleDay}号, 今天={$today}号");
        
        try {
            if ($today == $calculateDay) {
                $output->writeln("今天是统计日，开始计算 {$prevMonth} 月度分红...");
                $results = SettlementService::calculateMonthlyBonus($prevMonth);
                $output->writeln("分红计算完成，生成 " . count($results) . " 条分红记录");
            }
            
            if ($today == $settleDay) {
                $output->writeln("今天是发放日，开始发放 {$prevMonth} 月度分红...");
                SettlementService::settlePendingBonuses($prevMonth);
                $output->writeln("分红发放完成");
            }
            
            if ($today != $calculateDay && $today != $settleDay) {
                $output->writeln("今天不是统计日或发放日，无需执行");
            }
        } catch (\Exception $e) {
            $output->writeln("<error>分红任务失败: " . $e->getMessage() . "</error>");
            return 1;
        }
        
        return 0;
    }
}
