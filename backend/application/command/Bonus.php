<?php
namespace app\command;

use think\console\Command;
use think\console\Input;
use think\console\Output;
use app\common\library\SettlementService;

/**
 * 月度分红计算命令
 * 用法: php think bonus:calculate [month]
 * 示例: php think bonus:calculate 2025-01
 * 定时任务: 0 0 1 * * php /path/to/think bonus:calculate
 */
class Bonus extends Command
{
    protected function configure()
    {
        $this->setName('bonus:calculate')
            ->setDescription('计算月度分红')
            ->addArgument('month', \think\console\input\Argument::OPTIONAL, '月份(格式:Y-m)');
    }

    protected function execute(Input $input, Output $output)
    {
        $month = $input->getArgument('month');
        if (!$month) {
            $month = date('Y-m', strtotime('last month'));
        }
        
        $output->writeln("开始计算 {$month} 月度分红...");
        
        try {
            $results = SettlementService::calculateMonthlyBonus($month);
            $output->writeln("分红计算完成，生成 " . count($results) . " 条分红记录");
            
            // 自动发放分红
            $output->writeln("开始发放分红...");
            SettlementService::settlePendingBonuses($month);
            $output->writeln("分红发放完成");
            
        } catch (\Exception $e) {
            $output->writeln("<error>分红计算失败: " . $e->getMessage() . "</error>");
            return 1;
        }
        
        return 0;
    }
}
