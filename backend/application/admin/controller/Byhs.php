<?php
namespace app\admin\controller;

use app\common\controller\Backend;
use think\Db;

/**
 * 商户互助平台 - 数据统计仪表盘
 */
class Byhs extends Backend
{
    protected $noNeedRight = ['dashboard'];

    public function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 数据统计仪表盘
     */
    public function dashboard()
    {
        if ($this->request->isAjax()) {
            $data = $this->getDashboardData();
            $this->success('获取成功', null, $data);
        }
        
        $data = $this->getDashboardData();
        $this->view->assign($data);
        return $this->view->fetch();
    }

    protected function getDashboardData()
    {
        // 今日数据
        $today = strtotime('today');
        $tomorrow = strtotime('tomorrow');
        
        // 用户统计
        $totalUsers = Db::name('user')->count();
        $todayUsers = Db::name('user')->where('createtime', '>=', $today)->count();
        
        // 商户统计
        $totalMerchants = Db::name('merchant')->count();
        $pendingMerchants = Db::name('merchant')->where('status', 'pending')->count();
        $approvedMerchants = Db::name('merchant')->where('status', 'approved')->count();
        $todayMerchants = Db::name('merchant')->where('createtime', '>=', $today)->count();
        
        // 任务统计
        $totalTasks = Db::name('mutual_task')->count();
        $runningTasks = Db::name('mutual_task')->where('status', 'running')->count();
        $pendingTasks = Db::name('mutual_task')->where('status', 'pending')->count();
        $completedTasks = Db::name('mutual_task')->where('status', 'completed')->count();
        $todayTasks = Db::name('mutual_task')->where('createtime', '>=', $today)->count();
        
        // 子任务统计
        $totalSubTasks = Db::name('sub_task')->count();
        $pendingSubTasks = Db::name('sub_task')->where('status', 'pending')->count();
        $assignedSubTasks = Db::name('sub_task')->where('status', 'assigned')->count();
        $completedSubTasks = Db::name('sub_task')->where('status', 'completed')->count();
        $todayCompletedSubTasks = Db::name('sub_task')
            ->where('status', 'completed')
            ->where('completed_time', '>=', $today)
            ->count();
        
        // 金额统计
        $totalTaskAmount = Db::name('mutual_task')->sum('total_amount') ?: 0;
        $completedTaskAmount = Db::name('sub_task')->where('status', 'completed')->sum('amount') ?: 0;
        $todayCompletedAmount = Db::name('sub_task')
            ->where('status', 'completed')
            ->where('completed_time', '>=', $today)
            ->sum('amount') ?: 0;
        
        // 提现统计
        $pendingWithdraws = Db::name('withdraw')->where('status', 'pending')->count();
        $pendingWithdrawAmount = Db::name('withdraw')->where('status', 'pending')->sum('amount') ?: 0;
        $todayWithdrawAmount = Db::name('withdraw')
            ->where('createtime', '>=', $today)
            ->sum('amount') ?: 0;
        
        // 佣金统计
        $totalCommission = Db::name('promo_commission')->where('status', 'settled')->sum('amount') ?: 0;
        $todayCommission = Db::name('promo_commission')
            ->where('status', 'settled')
            ->where('createtime', '>=', $today)
            ->sum('amount') ?: 0;
        
        // 最近7天趋势数据
        $trends = $this->getTrendData(7);
        
        // 待处理事项
        $todoItems = [
            ['type' => 'merchant', 'title' => '待审核商户', 'count' => $pendingMerchants, 'url' => 'merchant/merchant/index?status=pending'],
            ['type' => 'task', 'title' => '待审核任务', 'count' => $pendingTasks, 'url' => 'task/mutualtask/index?status=pending'],
            ['type' => 'withdraw', 'title' => '待审核提现', 'count' => $pendingWithdraws, 'url' => 'wallet/withdraw/index?status=pending'],
            ['type' => 'subtask', 'title' => '待派发子任务', 'count' => $pendingSubTasks, 'url' => 'task/subtask/index?status=pending'],
        ];
        
        return [
            'stats' => [
                'users' => [
                    'total' => $totalUsers,
                    'today' => $todayUsers
                ],
                'merchants' => [
                    'total' => $totalMerchants,
                    'pending' => $pendingMerchants,
                    'approved' => $approvedMerchants,
                    'today' => $todayMerchants
                ],
                'tasks' => [
                    'total' => $totalTasks,
                    'running' => $runningTasks,
                    'pending' => $pendingTasks,
                    'completed' => $completedTasks,
                    'today' => $todayTasks
                ],
                'subtasks' => [
                    'total' => $totalSubTasks,
                    'pending' => $pendingSubTasks,
                    'assigned' => $assignedSubTasks,
                    'completed' => $completedSubTasks,
                    'today_completed' => $todayCompletedSubTasks
                ],
                'amounts' => [
                    'total_task' => number_format($totalTaskAmount, 2),
                    'completed' => number_format($completedTaskAmount, 2),
                    'today_completed' => number_format($todayCompletedAmount, 2)
                ],
                'withdraws' => [
                    'pending_count' => $pendingWithdraws,
                    'pending_amount' => number_format($pendingWithdrawAmount, 2),
                    'today_amount' => number_format($todayWithdrawAmount, 2)
                ],
                'commission' => [
                    'total' => number_format($totalCommission, 2),
                    'today' => number_format($todayCommission, 2)
                ]
            ],
            'trends' => $trends,
            'todoItems' => $todoItems
        ];
    }

    protected function getTrendData($days = 7)
    {
        $data = [
            'dates' => [],
            'tasks' => [],
            'subtasks' => [],
            'amounts' => [],
            'users' => []
        ];
        
        for ($i = $days - 1; $i >= 0; $i--) {
            $date = date('Y-m-d', strtotime("-{$i} days"));
            $startTime = strtotime($date);
            $endTime = strtotime($date . ' 23:59:59');
            
            $data['dates'][] = date('m-d', $startTime);
            
            $data['tasks'][] = Db::name('mutual_task')
                ->where('createtime', '>=', $startTime)
                ->where('createtime', '<=', $endTime)
                ->count();
            
            $data['subtasks'][] = Db::name('sub_task')
                ->where('status', 'completed')
                ->where('completed_time', '>=', $startTime)
                ->where('completed_time', '<=', $endTime)
                ->count();
            
            $data['amounts'][] = Db::name('sub_task')
                ->where('status', 'completed')
                ->where('completed_time', '>=', $startTime)
                ->where('completed_time', '<=', $endTime)
                ->sum('amount') ?: 0;
            
            $data['users'][] = Db::name('user')
                ->where('createtime', '>=', $startTime)
                ->where('createtime', '<=', $endTime)
                ->count();
        }
        
        return $data;
    }

    /**
     * 快速审核商户
     */
    public function quickApproveMerchant($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        if (!$id) {
            $this->error('参数缺失');
        }
        
        try {
            \app\common\library\MerchantService::approve($id, $this->auth->id);
            $this->success('审核通过');
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    /**
     * 快速审核任务
     */
    public function quickApproveTask($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        if (!$id) {
            $this->error('参数缺失');
        }
        
        try {
            \app\common\library\TaskService::approveTask($id, $this->auth->id);
            $this->success('审核通过');
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    /**
     * 快速审核提现
     */
    public function quickApproveWithdraw($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        if (!$id) {
            $this->error('参数缺失');
        }
        
        $withdraw = Db::name('withdraw')->where('id', $id)->find();
        if (!$withdraw || $withdraw['status'] !== 'pending') {
            $this->error('记录不存在或已处理');
        }
        
        Db::name('withdraw')->where('id', $id)->update([
            'status' => 'approved',
            'admin_id' => $this->auth->id,
            'audit_time' => time()
        ]);
        
        $this->success('审核通过');
    }
}
