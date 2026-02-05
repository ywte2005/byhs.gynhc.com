<?php
namespace app\admin\controller;

use app\common\controller\Backend;
use think\Db;

/**
 * 数据统计报表
 */
class Statistics extends Backend
{
    protected $noNeedRight = ['*'];

    /**
     * 交易统计
     */
    public function transaction()
    {
        $type = $this->request->param('type', 'day'); // day/week/month
        $date = $this->request->param('date', date('Y-m-d'));
        
        if ($this->request->isAjax()) {
            $data = $this->getTransactionData($type, $date);
            $this->success('获取成功', null, $data);
        }
        
        $this->view->assign('type', $type);
        $this->view->assign('date', $date);
        return $this->view->fetch();
    }

    /**
     * 获取交易统计数据
     */
    private function getTransactionData($type, $date)
    {
        $cacheKey = "statistics:transaction:{$type}:{$date}";
        $data = cache($cacheKey);
        
        if (!$data) {
            switch ($type) {
                case 'day':
                    $data = $this->getDayTransactionData($date);
                    break;
                case 'week':
                    $data = $this->getWeekTransactionData($date);
                    break;
                case 'month':
                    $data = $this->getMonthTransactionData($date);
                    break;
            }
            cache($cacheKey, $data, 3600); // 缓存1小时
        }
        
        return $data;
    }

    /**
     * 日交易统计
     */
    private function getDayTransactionData($date)
    {
        $startTime = strtotime($date . ' 00:00:00');
        $endTime = strtotime($date . ' 23:59:59');
        
        // 任务统计
        $taskStats = [
            'total_tasks' => Db::name('mutual_task')->whereTime('createtime', 'between', [$startTime, $endTime])->count(),
            'total_amount' => Db::name('mutual_task')->whereTime('createtime', 'between', [$startTime, $endTime])->sum('total_amount') ?: 0,
            'completed_tasks' => Db::name('mutual_task')->where('status', 'completed')->whereTime('updatetime', 'between', [$startTime, $endTime])->count(),
            'completed_amount' => Db::name('mutual_task')->where('status', 'completed')->whereTime('updatetime', 'between', [$startTime, $endTime])->sum('completed_amount') ?: 0,
        ];
        
        // 子任务统计
        $subtaskStats = [
            'total_subtasks' => Db::name('sub_task')->whereTime('createtime', 'between', [$startTime, $endTime])->count(),
            'completed_subtasks' => Db::name('sub_task')->where('status', 'completed')->whereTime('completed_time', 'between', [$startTime, $endTime])->count(),
            'total_commission' => Db::name('sub_task')->where('status', 'completed')->whereTime('completed_time', 'between', [$startTime, $endTime])->sum('commission') ?: 0,
        ];
        
        // 佣金统计
        $commissionStats = [
            'total_commission' => Db::name('promo_commission')->whereTime('createtime', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
            'settled_commission' => Db::name('promo_commission')->where('status', 'settled')->whereTime('settle_time', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
        ];
        
        // 充值提现统计
        $walletStats = [
            'total_recharge' => Db::name('wallet_recharge')->where('status', 'paid')->whereTime('paid_time', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
            'total_withdraw' => Db::name('wallet_withdraw')->where('status', 'paid')->whereTime('paid_time', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
        ];
        
        return [
            'date' => $date,
            'task' => $taskStats,
            'subtask' => $subtaskStats,
            'commission' => $commissionStats,
            'wallet' => $walletStats,
        ];
    }


    /**
     * 周交易统计
     */
    private function getWeekTransactionData($date)
    {
        $startTime = strtotime($date . ' -6 days 00:00:00');
        $endTime = strtotime($date . ' 23:59:59');
        
        $days = [];
        for ($i = 6; $i >= 0; $i--) {
            $day = date('Y-m-d', strtotime($date . " -{$i} days"));
            $days[] = $day;
        }
        
        $chartData = [];
        foreach ($days as $day) {
            $dayData = $this->getDayTransactionData($day);
            $chartData[] = [
                'date' => $day,
                'task_amount' => $dayData['task']['total_amount'],
                'completed_amount' => $dayData['task']['completed_amount'],
                'commission' => $dayData['commission']['total_commission'],
            ];
        }
        
        // 汇总统计
        $summary = [
            'total_tasks' => Db::name('mutual_task')->whereTime('createtime', 'between', [$startTime, $endTime])->count(),
            'total_amount' => Db::name('mutual_task')->whereTime('createtime', 'between', [$startTime, $endTime])->sum('total_amount') ?: 0,
            'completed_tasks' => Db::name('mutual_task')->where('status', 'completed')->whereTime('updatetime', 'between', [$startTime, $endTime])->count(),
            'total_commission' => Db::name('promo_commission')->whereTime('createtime', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
        ];
        
        return [
            'date_range' => [date('Y-m-d', $startTime), $date],
            'summary' => $summary,
            'chart_data' => $chartData,
        ];
    }

    /**
     * 月交易统计
     */
    private function getMonthTransactionData($date)
    {
        $month = substr($date, 0, 7); // Y-m
        $startTime = strtotime($month . '-01 00:00:00');
        $endTime = strtotime($month . '-01 +1 month -1 second');
        
        // 按天统计
        $days = [];
        $currentDay = $startTime;
        while ($currentDay <= $endTime) {
            $days[] = date('Y-m-d', $currentDay);
            $currentDay = strtotime('+1 day', $currentDay);
        }
        
        $chartData = [];
        foreach ($days as $day) {
            $dayData = $this->getDayTransactionData($day);
            $chartData[] = [
                'date' => substr($day, 8), // 只显示日期
                'task_amount' => $dayData['task']['total_amount'],
                'completed_amount' => $dayData['task']['completed_amount'],
                'commission' => $dayData['commission']['total_commission'],
            ];
        }
        
        // 汇总统计
        $summary = [
            'total_tasks' => Db::name('mutual_task')->whereTime('createtime', 'between', [$startTime, $endTime])->count(),
            'total_amount' => Db::name('mutual_task')->whereTime('createtime', 'between', [$startTime, $endTime])->sum('total_amount') ?: 0,
            'completed_tasks' => Db::name('mutual_task')->where('status', 'completed')->whereTime('updatetime', 'between', [$startTime, $endTime])->count(),
            'total_commission' => Db::name('promo_commission')->whereTime('createtime', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
        ];
        
        return [
            'month' => $month,
            'summary' => $summary,
            'chart_data' => $chartData,
        ];
    }

    /**
     * 业绩统计
     */
    public function performance()
    {
        $month = $this->request->param('month', date('Y-m'));
        
        if ($this->request->isAjax()) {
            $data = $this->getPerformanceData($month);
            $this->success('获取成功', null, $data);
        }
        
        $this->view->assign('month', $month);
        return $this->view->fetch();
    }

    /**
     * 获取业绩统计数据
     */
    private function getPerformanceData($month)
    {
        $cacheKey = "statistics:performance:{$month}";
        $data = cache($cacheKey);
        
        if (!$data) {
            // 业绩排行榜（个人业绩前20）
            $topPerformers = Db::name('promo_performance')
                ->alias('p')
                ->join('user u', 'p.user_id = u.id')
                ->where('p.period', $period)
                ->field('u.nickname, p.personal_performance, p.team_performance, p.user_id')
                ->order('p.personal_performance', 'desc')
                ->limit(20)
                ->select();
            
            // 团队业绩排行榜（团队业绩前20）
            $topTeams = Db::name('promo_performance')
                ->alias('p')
                ->join('user u', 'p.user_id = u.id')
                ->where('p.period', $period)
                ->field('u.nickname, p.personal_performance, p.team_performance, p.user_id')
                ->order('p.team_performance', 'desc')
                ->limit(20)
                ->select();
            
            // 业绩汇总
            $summary = [
                'total_personal' => Db::name('promo_performance')->where('period', $period)->sum('personal_performance') ?: 0,
                'total_team' => Db::name('promo_performance')->where('period', $period)->sum('team_performance') ?: 0,
                'active_users' => Db::name('promo_performance')->where('period', $period)->where('personal_performance', '>', 0)->count(),
            ];
            
            // 等级分布
            $levelDistribution = Db::name('promo_relation')
                ->alias('r')
                ->join('promo_level l', 'r.level_id = l.id', 'LEFT')
                ->field('l.name as level_name, count(*) as count')
                ->group('r.level_id')
                ->select();
            
            $data = [
                'month' => $month,
                'summary' => $summary,
                'top_performers' => $topPerformers,
                'top_teams' => $topTeams,
                'level_distribution' => $levelDistribution,
            ];
            
            cache($cacheKey, $data, 3600);
        }
        
        return $data;
    }

    /**
     * 分红统计
     */
    public function bonus()
    {
        $month = $this->request->param('month', date('Y-m'));
        
        if ($this->request->isAjax()) {
            $data = $this->getBonusData($month);
            $this->success('获取成功', null, $data);
        }
        
        $this->view->assign('month', $month);
        return $this->view->fetch();
    }

    /**
     * 获取分红统计数据
     */
    private function getBonusData($month)
    {
        $cacheKey = "statistics:bonus:{$month}";
        $data = cache($cacheKey);
        
        if (!$data) {
            // 分红汇总
            $summary = [
                'total_bonus' => Db::name('promo_bonus')->where('period', $month)->sum('amount') ?: 0,
                'settled_bonus' => Db::name('promo_bonus')->where('period', $month)->where('status', 'settled')->sum('amount') ?: 0,
                'qualified_users' => Db::name('promo_bonus')->where('period', $month)->count('DISTINCT user_id'),
            ];
            
            // 按档位统计
            $configStats = Db::name('promo_bonus')
                ->alias('b')
                ->join('promo_bonus_config c', 'b.config_id = c.id')
                ->where('b.month', $month)
                ->field('c.name as config_name, count(*) as user_count, sum(b.amount) as total_amount')
                ->group('b.config_id')
                ->select();
            
            // 分红排行榜
            $topBonus = Db::name('promo_bonus')
                ->alias('b')
                ->join('user u', 'b.user_id = u.id')
                ->where('b.month', $month)
                ->field('u.nickname, b.amount, b.user_id')
                ->order('b.amount', 'desc')
                ->limit(20)
                ->select();
            
            $data = [
                'month' => $month,
                'summary' => $summary,
                'config_stats' => $configStats,
                'top_bonus' => $topBonus,
            ];
            
            cache($cacheKey, $data, 3600);
        }
        
        return $data;
    }

    /**
     * 资金流水统计
     */
    public function wallet()
    {
        $type = $this->request->param('type', 'day');
        $date = $this->request->param('date', date('Y-m-d'));
        
        if ($this->request->isAjax()) {
            $data = $this->getWalletData($type, $date);
            $this->success('获取成功', null, $data);
        }
        
        $this->view->assign('type', $type);
        $this->view->assign('date', $date);
        return $this->view->fetch();
    }

    /**
     * 获取资金流水统计数据
     */
    private function getWalletData($type, $date)
    {
        $cacheKey = "statistics:wallet:{$type}:{$date}";
        $data = cache($cacheKey);
        
        if (!$data) {
            $startTime = strtotime($date . ' 00:00:00');
            $endTime = strtotime($date . ' 23:59:59');
            
            // 充值统计
            $rechargeStats = [
                'count' => Db::name('wallet_recharge')->where('status', 'paid')->whereTime('paid_time', 'between', [$startTime, $endTime])->count(),
                'amount' => Db::name('wallet_recharge')->where('status', 'paid')->whereTime('paid_time', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
            ];
            
            // 提现统计
            $withdrawStats = [
                'count' => Db::name('wallet_withdraw')->where('status', 'paid')->whereTime('paid_time', 'between', [$startTime, $endTime])->count(),
                'amount' => Db::name('wallet_withdraw')->where('status', 'paid')->whereTime('paid_time', 'between', [$startTime, $endTime])->sum('amount') ?: 0,
            ];
            
            // 流水类型统计
            $logTypeStats = Db::name('wallet_log')
                ->whereTime('createtime', 'between', [$startTime, $endTime])
                ->field('biz_type, count(*) as count, sum(amount) as amount')
                ->group('biz_type')
                ->select();
            
            // 钱包类型统计
            $walletTypeStats = Db::name('wallet_log')
                ->whereTime('createtime', 'between', [$startTime, $endTime])
                ->field('wallet_type, change_type, count(*) as count, sum(amount) as amount')
                ->group('wallet_type, change_type')
                ->select();
            
            $data = [
                'date' => $date,
                'recharge' => $rechargeStats,
                'withdraw' => $withdrawStats,
                'log_type_stats' => $logTypeStats,
                'wallet_type_stats' => $walletTypeStats,
            ];
            
            cache($cacheKey, $data, 3600);
        }
        
        return $data;
    }

    /**
     * 用户增长统计
     */
    public function user()
    {
        $type = $this->request->param('type', 'month');
        $date = $this->request->param('date', date('Y-m'));
        
        if ($this->request->isAjax()) {
            $data = $this->getUserGrowthData($type, $date);
            $this->success('获取成功', null, $data);
        }
        
        $this->view->assign('type', $type);
        $this->view->assign('date', $date);
        return $this->view->fetch();
    }

    /**
     * 获取用户增长数据
     */
    private function getUserGrowthData($type, $date)
    {
        $month = substr($date, 0, 7);
        $startTime = strtotime($month . '-01 00:00:00');
        $endTime = strtotime($month . '-01 +1 month -1 second');
        
        // 用户增长统计
        $userStats = [
            'total_users' => Db::name('user')->count(),
            'new_users' => Db::name('user')->whereTime('jointime', 'between', [$startTime, $endTime])->count(),
            'active_users' => Db::name('user')->whereTime('logintime', 'between', [$startTime, $endTime])->count(),
        ];
        
        // 商户增长统计
        $merchantStats = [
            'total_merchants' => Db::name('merchant')->count(),
            'new_merchants' => Db::name('merchant')->whereTime('createtime', 'between', [$startTime, $endTime])->count(),
            'approved_merchants' => Db::name('merchant')->where('status', 'approved')->whereTime('approved_time', 'between', [$startTime, $endTime])->count(),
        ];
        
        // 按天统计新增用户
        $days = [];
        $currentDay = $startTime;
        while ($currentDay <= $endTime) {
            $dayStart = $currentDay;
            $dayEnd = strtotime('+1 day -1 second', $currentDay);
            $day = date('Y-m-d', $currentDay);
            
            $days[] = [
                'date' => substr($day, 8),
                'new_users' => Db::name('user')->whereTime('jointime', 'between', [$dayStart, $dayEnd])->count(),
                'new_merchants' => Db::name('merchant')->whereTime('createtime', 'between', [$dayStart, $dayEnd])->count(),
            ];
            
            $currentDay = strtotime('+1 day', $currentDay);
        }
        
        return [
            'month' => $month,
            'user_stats' => $userStats,
            'merchant_stats' => $merchantStats,
            'chart_data' => $days,
        ];
    }

    /**
     * 商户增长统计
     */
    public function merchant()
    {
        $type = $this->request->param('type', 'month');
        $date = $this->request->param('date', date('Y-m'));
        
        if ($this->request->isAjax()) {
            $data = $this->getMerchantGrowthData($type, $date);
            $this->success('获取成功', null, $data);
        }
        
        $this->view->assign('type', $type);
        $this->view->assign('date', $date);
        return $this->view->fetch();
    }

    /**
     * 获取商户增长数据
     */
    private function getMerchantGrowthData($type, $date)
    {
        $month = substr($date, 0, 7);
        $startTime = strtotime($month . '-01 00:00:00');
        $endTime = strtotime($month . '-01 +1 month -1 second');
        
        // 商户统计
        $summary = [
            'total' => Db::name('merchant')->count(),
            'pending' => Db::name('merchant')->where('status', 'pending')->count(),
            'approved' => Db::name('merchant')->where('status', 'approved')->count(),
            'rejected' => Db::name('merchant')->where('status', 'rejected')->count(),
            'disabled' => Db::name('merchant')->where('status', 'disabled')->count(),
            'new_this_month' => Db::name('merchant')->whereTime('createtime', 'between', [$startTime, $endTime])->count(),
        ];
        
        // 商户任务统计（前20名）
        $topMerchants = Db::name('merchant')
            ->alias('m')
            ->join('mutual_task t', 'm.user_id = t.user_id')
            ->field('m.name, m.user_id, count(t.id) as task_count, sum(t.total_amount) as total_amount')
            ->group('m.user_id')
            ->order('total_amount', 'desc')
            ->limit(20)
            ->select();
        
        return [
            'month' => $month,
            'summary' => $summary,
            'top_merchants' => $topMerchants,
        ];
    }
}
