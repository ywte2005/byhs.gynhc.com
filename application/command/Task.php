<?php
namespace app\command;

use think\console\Command;
use think\console\Input;
use think\console\Output;
use app\common\model\task\SubTask;
use app\common\library\TaskService;

/**
 * 任务相关定时命令
 * 用法: 
 *   php think task:timeout - 检查超时任务
 *   php think task:dispatch - 派发待分配任务
 * 定时任务(crontab): 
 *   每5分钟: php /path/to/think task timeout
 *   每10分钟: php /path/to/think task dispatch
 */
class Task extends Command
{
    protected function configure()
    {
        $this->setName('task')
            ->setDescription('任务管理命令')
            ->addArgument('action', \think\console\input\Argument::REQUIRED, '操作类型(timeout/dispatch)');
    }

    protected function execute(Input $input, Output $output)
    {
        $action = $input->getArgument('action');
        
        switch ($action) {
            case 'timeout':
                return $this->checkTimeout($output);
            case 'dispatch':
                return $this->dispatchTasks($output);
            default:
                $output->writeln("<error>未知操作: {$action}</error>");
                return 1;
        }
    }

    /**
     * 检查超时任务
     */
    protected function checkTimeout(Output $output)
    {
        $output->writeln("开始检查超时任务...");
        
        // 接单后24小时未上传凭证的任务标记为超时
        $timeout = 24 * 3600;
        $subTasks = SubTask::where('status', 'accepted')
            ->where('accepted_time', '<', time() - $timeout)
            ->select();
        
        $count = 0;
        foreach ($subTasks as $subTask) {
            try {
                TaskService::failSubTask($subTask->id, '接单超时未支付');
                $count++;
            } catch (\Exception $e) {
                $output->writeln("<error>处理子任务 {$subTask->id} 失败: " . $e->getMessage() . "</error>");
            }
        }
        
        $output->writeln("超时检查完成，处理了 {$count} 个超时任务");
        return 0;
    }

    /**
     * 派发待分配任务
     */
    protected function dispatchTasks(Output $output)
    {
        $output->writeln("开始派发待分配任务...");
        
        $tasks = \app\common\model\task\MutualTask::where('status', 'running')->select();
        $count = 0;
        
        foreach ($tasks as $task) {
            try {
                TaskService::dispatchSubTasks($task->id);
                $count++;
            } catch (\Exception $e) {
                continue;
            }
        }
        
        $output->writeln("任务派发完成，处理了 {$count} 个任务");
        return 0;
    }
}
