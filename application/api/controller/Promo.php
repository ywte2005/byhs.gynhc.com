<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\PromoService;
use app\common\library\WalletService;

class Promo extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    public function overview()
    {
        $userId = $this->auth->id;
        $data = PromoService::getOverview($userId);
        $this->success('获取成功', $data);
    }

    public function levels()
    {
        $levels = PromoService::getLevels();
        $this->success('获取成功', ['levels' => $levels]);
    }

    public function purchaseLevel()
    {
        $levelId = $this->request->post('level_id');
        $payMethod = $this->request->post('pay_method', 'balance');
        
        if (!$levelId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        try {
            $relation = PromoService::purchaseLevel($userId, $levelId, $payMethod);
            $this->success('购买成功', ['relation' => $relation]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function myInviteCode()
    {
        $userId = $this->auth->id;
        $inviteCode = PromoService::getInviteCode($userId);
        $this->success('获取成功', ['invite_code' => $inviteCode]);
    }

    public function bindRelation()
    {
        $inviteCode = $this->request->post('invite_code');
        
        if (!$inviteCode) {
            $this->error('邀请码不能为空');
        }
        
        $userId = $this->auth->id;
        
        try {
            $relation = PromoService::bindParent($userId, $inviteCode);
            $this->success('绑定成功', ['relation' => $relation]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function myTeam()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = PromoService::getTeamMembers($userId, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function commissionList()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = PromoService::getCommissionList($userId, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function walletLogs()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        $walletType = $this->request->get('wallet_type', null);
        
        $userId = $this->auth->id;
        $list = WalletService::getLogs($userId, $walletType, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function performanceSummary()
    {
        $month = $this->request->get('month', date('Y-m'));
        $userId = $this->auth->id;
        
        $performance = \app\common\model\promo\Performance::getByUserMonth($userId, $month);
        $growth = \app\common\model\promo\Performance::calculateGrowth($userId, $month);
        
        $this->success('获取成功', [
            'month' => $month,
            'personal_amount' => $performance ? $performance->personal_amount : '0.00',
            'team_amount' => $performance ? $performance->team_amount : '0.00',
            'growth' => $growth
        ]);
    }

    public function bonusSummary()
    {
        $userId = $this->auth->id;
        
        $totalBonus = \app\common\model\promo\Bonus::where('user_id', $userId)
            ->where('status', 'settled')
            ->sum('amount');
        
        $pendingBonus = \app\common\model\promo\Bonus::where('user_id', $userId)
            ->where('status', 'pending')
            ->sum('amount');
        
        $this->success('获取成功', [
            'total_bonus' => $totalBonus,
            'pending_bonus' => $pendingBonus
        ]);
    }

    public function bonusRecords()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = \app\common\model\promo\Bonus::getUserBonuses($userId, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }
}
