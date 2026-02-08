<?php
namespace app\admin\controller\merchant;

use app\common\controller\Backend;
use app\common\library\MerchantService;

class Merchant extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,merchant_no,name,legal_name,contact_phone';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\merchant\Merchant;
        $this->view->assign("statusList", ['pending' => '待审核', 'approved' => '已通过', 'rejected' => '已拒绝', 'disabled' => '已禁用']);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }

    public function approve($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            MerchantService::approve($ids, $this->auth->id);
            $this->success('审核通过');
        }
    }

    public function reject($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $reason = $this->request->post('reason', '');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            MerchantService::reject($ids, $reason, $this->auth->id);
            $this->success('已拒绝');
        }
        return $this->view->fetch();
    }

    /**
     * 禁用商户
     */
    public function disable($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row) {
                $this->error('商户不存在');
            }
            $row->status = 'disabled';
            $row->save();
            $this->success('已禁用');
        }
    }

    /**
     * 启用商户
     */
    public function enable($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row) {
                $this->error('商户不存在');
            }
            $row->status = 'approved';
            $row->save();
            $this->success('已启用');
        }
    }

    /**
     * 商户详情
     */
    public function detail($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->with(['user'])->find($id);
        if (!$row) {
            $this->error('商户不存在');
        }

        // 统计数据
        $stats = [
            'total_tasks' => \app\common\model\task\MutualTask::where('user_id', $row->user_id)->count(),
            'total_amount' => \app\common\model\task\MutualTask::where('user_id', $row->user_id)->sum('total_amount'),
            'total_commission' => \app\common\model\task\SubTask::where('from_user_id', $row->user_id)->where('status', 'completed')->sum('commission'),
            'completed_tasks' => \app\common\model\task\MutualTask::where('user_id', $row->user_id)->where('status', 'completed')->count(),
            'user_money' => $row->user ? $row->user->money : 0,
            'user_score' => $row->user ? $row->user->score : 0,
            'total_recharge' => \app\common\model\wallet\Recharge::where('user_id', $row->user_id)->where('status', 'paid')->sum('amount'),
            'total_withdraw' => \app\common\model\wallet\Withdraw::where('user_id', $row->user_id)->where('status', 'paid')->sum('amount'),
        ];

        // 发布任务列表
        $publishTasks = \app\common\model\task\MutualTask::where('user_id', $row->user_id)
            ->order('id', 'desc')
            ->limit(10)
            ->select();

        // 接单任务列表
        $acceptTasks = \app\common\model\task\SubTask::where('to_user_id', $row->user_id)
            ->order('id', 'desc')
            ->limit(10)
            ->select();

        // 账变记录
        $walletLogs = \app\common\model\wallet\WalletLog::where('user_id', $row->user_id)
            ->order('id', 'desc')
            ->limit(20)
            ->select();

        if ($this->request->isAjax()) {
            $this->success('获取成功', null, [
                'row' => $row, 
                'stats' => $stats,
                'publishTasks' => $publishTasks,
                'acceptTasks' => $acceptTasks,
                'walletLogs' => $walletLogs
            ]);
        }
        $this->view->assign('row', $row);
        $this->view->assign('stats', $stats);
        $this->view->assign('publishTasks', $publishTasks);
        $this->view->assign('acceptTasks', $acceptTasks);
        $this->view->assign('walletLogs', $walletLogs);
        return $this->view->fetch();
    }
}
