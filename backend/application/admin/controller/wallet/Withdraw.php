<?php
namespace app\admin\controller\wallet;

use app\common\controller\Backend;
use app\common\library\WalletService;

class Withdraw extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,withdraw_no,account_name';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\wallet\Withdraw;
        $this->view->assign("statusList", ['pending' => '待审核', 'approved' => '已审核', 'rejected' => '已拒绝', 'paid' => '已打款', 'failed' => '失败']);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user', 'admin'])
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
        $row = $this->model->with(['user', 'admin'])->find($id);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }

    public function approve($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            $idArr = explode(',', $ids);
            $count = 0;
            foreach ($idArr as $id) {
                $withdraw = $this->model->find($id);
                if ($withdraw && $withdraw->status === 'pending') {
                    $withdraw->status = 'approved';
                    $withdraw->admin_id = $this->auth->id;
                    $withdraw->audit_time = time();
                    $withdraw->save();
                    $count++;
                }
            }
            
            $this->success('审核通过 ' . $count . ' 笔');
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
            
            $idArr = explode(',', $ids);
            $count = 0;
            \think\Db::startTrans();
            try {
                foreach ($idArr as $id) {
                    $withdraw = $this->model->find($id);
                    if ($withdraw && $withdraw->status === 'pending') {
                        WalletService::changeBalance($withdraw->user_id, $withdraw->amount, 'withdraw_reject', $withdraw->id, '提现拒绝退回');
                        
                        $withdraw->status = 'rejected';
                        $withdraw->reject_reason = $reason;
                        $withdraw->admin_id = $this->auth->id;
                        $withdraw->audit_time = time();
                        $withdraw->save();
                        $count++;
                    }
                }
                \think\Db::commit();
                $this->success('已拒绝 ' . $count . ' 笔');
            } catch (\Exception $e) {
                \think\Db::rollback();
                $this->error($e->getMessage());
            }
        }
        return $this->view->fetch();
    }

    public function paid($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $remark = $this->request->post('remark', '');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            $idArr = explode(',', $ids);
            $count = 0;
            foreach ($idArr as $id) {
                $withdraw = $this->model->find($id);
                if ($withdraw && $withdraw->status === 'approved') {
                    $withdraw->status = 'paid';
                    $withdraw->paid_time = time();
                    $withdraw->paid_remark = $remark;
                    $withdraw->save();
                    $count++;
                }
            }
            
            $this->success('已标记打款 ' . $count . ' 笔');
        }
        return $this->view->fetch();
    }
}
