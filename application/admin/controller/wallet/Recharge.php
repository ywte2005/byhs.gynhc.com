<?php
namespace app\admin\controller\wallet;

use app\common\controller\Backend;

/**
 * 充值订单管理
 */
class Recharge extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,order_no,trade_no';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\wallet\Recharge;
        $this->view->assign("statusList", ['pending' => '待支付', 'paid' => '已支付', 'failed' => '失败', 'cancelled' => '已取消']);
        $this->view->assign("targetList", ['balance' => '余额', 'deposit' => '保证金']);
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

    /**
     * 详情
     */
    public function detail($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->with(['user'])->find($id);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }

    /**
     * 手动确认到账（补单）
     */
    public function confirm($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            $recharge = $this->model->find($ids);
            if (!$recharge || $recharge->status !== 'pending') {
                $this->error('订单不存在或状态不正确');
            }
            
            \think\Db::startTrans();
            try {
                $recharge->status = 'paid';
                $recharge->paid_time = time();
                $recharge->save();
                
                if ($recharge->target === 'balance') {
                    \app\common\library\WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge', $recharge->id, '充值到账(补单)');
                } elseif ($recharge->target === 'deposit') {
                    \app\common\library\WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge', $recharge->id, '充值');
                    \app\common\library\WalletService::changeBalance($recharge->user_id, '-' . $recharge->amount, 'deposit_pay', $recharge->id, '保证金充值');
                    \app\common\library\WalletService::changeDeposit($recharge->user_id, $recharge->amount, 'deposit_pay', $recharge->id, '保证金充值');
                }
                
                \think\Db::commit();
                $this->success('确认到账成功');
            } catch (\Exception $e) {
                \think\Db::rollback();
                $this->error($e->getMessage());
            }
        }
    }
}
