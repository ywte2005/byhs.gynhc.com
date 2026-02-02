<?php
namespace app\admin\controller\task;

use app\common\controller\Backend;
use app\common\library\TaskService;

class Subtask extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,task_no,from_user_id,to_user_id';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\task\SubTask;
        $this->view->assign("statusList", [
            'pending' => '待分配',
            'assigned' => '已分配',
            'accepted' => '已接单',
            'paid' => '已支付',
            'verified' => '已验证',
            'completed' => '已完成',
            'failed' => '失败',
            'cancelled' => '已取消'
        ]);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['task', 'fromUser', 'toUser'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }

    public function complete($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            try {
                TaskService::completeSubTask($ids);
                $this->success('已完成');
            } catch (\Exception $e) {
                $this->error($e->getMessage());
            }
        }
    }

    public function fail($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $reason = $this->request->post('reason', '验证失败');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            try {
                TaskService::failSubTask($ids, $reason);
                $this->success('已标记失败');
            } catch (\Exception $e) {
                $this->error($e->getMessage());
            }
        }
        return $this->view->fetch();
    }

    /**
     * 子任务详情
     */
    public function detail($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->with(['task', 'fromUser', 'toUser'])->find($id);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        if ($this->request->isAjax()) {
            return json(['code' => 1, 'data' => ['row' => $row]]);
        }
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }
}
