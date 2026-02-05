<?php

namespace app\api\controller;

use app\common\controller\Api;

/**
 * 首页接口
 */
class Index extends Api
{
    protected $noNeedLogin = ['index'];
    protected $noNeedRight = ['*'];

    /**
     * 首页
     *
     */
    public function index()
    {
        $this->success('请求成功');
    }

    /**
     * 首页统计数据
     */
    public function statistics()
    {
        $userId = $this->auth->id;
        
        // 获取钱包信息
        $wallet = \app\common\model\wallet\Wallet::getByUserId($userId);
        
        // 获取待办事项统计
        $pendingMerchant = \app\common\model\merchant\Merchant::where('user_id', $userId)
            ->where('status', 'pending')
            ->count();
        
        $pendingTask = \app\common\model\task\SubTask::where('to_user_id', $userId)
            ->where('status', 'completed')
            ->count();
        
        $pendingWithdraw = \app\common\model\wallet\Withdraw::where('user_id', $userId)
            ->where('status', 'pending')
            ->count();
        
        // 获取今日数据
        $todayStart = strtotime(date('Y-m-d 00:00:00'));
        $todayEnd = strtotime(date('Y-m-d 23:59:59'));
        
        $todayAccepted = \app\common\model\task\SubTask::where('to_user_id', $userId)
            ->where('accepted_time', '>=', $todayStart)
            ->where('accepted_time', '<=', $todayEnd)
            ->count();
        
        $todayCompleted = \app\common\model\task\SubTask::where('to_user_id', $userId)
            ->where('status', 'completed')
            ->where('completed_time', '>=', $todayStart)
            ->where('completed_time', '<=', $todayEnd)
            ->count();
        
        $todayIncome = \app\common\model\wallet\WalletLog::where('user_id', $userId)
            ->where('wallet_type', 'balance')
            ->where('change_type', 'income')
            ->where('createtime', '>=', $todayStart)
            ->where('createtime', '<=', $todayEnd)
            ->where('amount', '>', 0)
            ->sum('amount');
        
        // 平台动态（暂时返回模拟数据）
        $news = [
            [
                'id' => 1,
                'title' => '新春任务大礼包上线啦！',
                'createtime' => strtotime('2024-01-20'),
                'type' => 'primary'
            ],
            [
                'id' => 2,
                'title' => '系统升级维护公告',
                'createtime' => strtotime('2024-01-18'),
                'type' => 'success'
            ],
            [
                'id' => 3,
                'title' => '新增商户认证功能',
                'createtime' => strtotime('2024-01-15'),
                'type' => 'warning'
            ]
        ];
        
        $data = [
            'wallet' => [
                'balance' => $wallet->balance,
                'frozen' => $wallet->frozen,
                'pending' => 0 // 待结算金额，暂时返回0
            ],
            'todo' => [
                'pending_merchant' => $pendingMerchant,
                'pending_task' => $pendingTask,
                'pending_withdraw' => $pendingWithdraw
            ],
            'today' => [
                'accepted' => $todayAccepted,
                'completed' => $todayCompleted,
                'income' => $todayIncome ?: 0
            ],
            'news' => $news
        ];
        
        $this->success('获取成功', $data);
    }
}
