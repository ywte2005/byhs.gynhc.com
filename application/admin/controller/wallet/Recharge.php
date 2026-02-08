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
        if (!$this->request->isPost()) {
            $this->error('请求方式错误');
        }
        
        $ids = $ids ?: $this->request->post('ids');
        if (!$ids) {
            $this->error('参数缺失');
        }
        
        $recharge = $this->model->find($ids);
        if (!$recharge) {
            $this->error('订单不存在');
        }
        if ($recharge->status !== 'pending') {
            $this->error('订单状态不正确，当前状态：' . $recharge->status);
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
        } catch (\think\exception\HttpResponseException $e) {
            \think\Db::commit();
            throw $e;
        } catch (\Exception $e) {
            \think\Db::rollback();
            $this->error($e->getMessage());
        }
        $this->success('确认到账成功');
    }

    /**
     * 充值退款
     */
    public function refund($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $reason = $this->request->post('reason', '');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            $recharge = $this->model->find($ids);
            if (!$recharge || !in_array($recharge->status, ['pending', 'paid'])) {
                $this->error('订单不存在或状态不允许退款');
            }
            
            \think\Db::startTrans();
            try {
                // 如果已支付，需要扣除用户余额
                if ($recharge->status === 'paid') {
                    if ($recharge->target === 'balance') {
                        \app\common\library\WalletService::changeBalance($recharge->user_id, '-' . $recharge->amount, 'recharge_refund', $recharge->id, '充值退款：' . $reason);
                    } elseif ($recharge->target === 'deposit') {
                        \app\common\library\WalletService::changeDeposit($recharge->user_id, '-' . $recharge->amount, 'recharge_refund', $recharge->id, '充值退款：' . $reason);
                        \app\common\library\WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge_refund', $recharge->id, '充值退款');
                    }
                }
                
                $recharge->status = 'cancelled';
                $recharge->refund_reason = $reason;
                $recharge->refund_time = time();
                $recharge->save();
                
                \think\Db::commit();
            } catch (\think\exception\HttpResponseException $e) {
                \think\Db::commit();
                throw $e;
            } catch (\Exception $e) {
                \think\Db::rollback();
                $this->error($e->getMessage());
            }
            $this->success('退款成功');
        }
        return $this->view->fetch();
    }

    /**
     * 批量确认到账
     */
    public function batchConfirm()
    {
        if (!$this->request->isPost()) {
            $this->error('请求方式错误');
        }
        
        $ids = $this->request->post('ids');
        if (!$ids) {
            $this->error('参数缺失');
        }
        
        $idArr = explode(',', $ids);
        $count = 0;
        $errors = [];
        
        foreach ($idArr as $id) {
            \think\Db::startTrans();
            try {
                $recharge = $this->model->find($id);
                if ($recharge && $recharge->status === 'pending') {
                    $recharge->status = 'paid';
                    $recharge->paid_time = time();
                    $recharge->save();
                    
                    if ($recharge->target === 'balance') {
                        \app\common\library\WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge', $recharge->id, '充值到账(批量补单)');
                    } elseif ($recharge->target === 'deposit') {
                        \app\common\library\WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge', $recharge->id, '充值');
                        \app\common\library\WalletService::changeBalance($recharge->user_id, '-' . $recharge->amount, 'deposit_pay', $recharge->id, '保证金充值');
                        \app\common\library\WalletService::changeDeposit($recharge->user_id, $recharge->amount, 'deposit_pay', $recharge->id, '保证金充值');
                    }
                    
                    $count++;
                }
                \think\Db::commit();
            } catch (\think\exception\HttpResponseException $e) {
                \think\Db::commit();
                throw $e;
            } catch (\Exception $e) {
                \think\Db::rollback();
                $errors[] = "订单{$id}处理失败：" . $e->getMessage();
            }
        }
        
        if ($count > 0) {
            $msg = "成功确认 {$count} 笔订单";
            if (!empty($errors)) {
                $msg .= "，失败：" . implode('；', $errors);
            }
            $this->success($msg);
        } else {
            $this->error('没有可确认的订单');
        }
    }
}
