<?php
namespace app\admin\controller\task;

use app\common\controller\Backend;
use app\common\library\TaskService;

class Mutualtask extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,task_no,user_id';
    protected $modelValidate = true;
    protected $modelSceneValidate = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\task\MutualTask;
        $this->view->assign("statusList", [
            'pending' => '待审核',
            'approved' => '已审核',
            'rejected' => '已拒绝',
            'running' => '进行中',
            'paused' => '已暂停',
            'completed' => '已完成',
            'cancelled' => '已取消'
        ]);
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
            
            TaskService::approveTask($ids, $this->auth->id);
            $this->success('审核通过，任务已开始');
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
            
            TaskService::rejectTask($ids, $reason, $this->auth->id);
            $this->success('已拒绝');
        }
        return $this->view->fetch();
    }

    public function dispatch($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            TaskService::dispatchSubTasks($ids);
            $this->success('派发成功');
        }
    }

    /**
     * 暂停任务
     */
    public function pause($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row || $row->status !== 'running') {
                $this->error('任务不存在或当前状态无法暂停');
            }
            $row->status = 'paused';
            $row->save();
            $this->success('任务已暂停');
        }
    }

    /**
     * 恢复任务
     */
    public function resume($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row || $row->status !== 'paused') {
                $this->error('任务不存在或当前状态无法恢复');
            }
            $row->status = 'running';
            $row->save();
            $this->success('任务已恢复运行');
        }
    }

    /**
     * 取消任务
     */
    public function cancel($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row || in_array($row->status, ['completed', 'cancelled', 'rejected'])) {
                $this->error('任务不存在或当前状态无法取消');
            }
            
            \think\Db::startTrans();
            try {
                $row->status = 'cancelled';
                $row->save();
                
                // 退回未完成部分的金额和保证金逻辑（此处视业务逻辑而定，暂仅修改状态）
                
                \think\Db::commit();
                $this->success('任务已取消');
            } catch (\Exception $e) {
                \think\Db::rollback();
                $this->error($e->getMessage());
            }
        }
    }

    /**
     * 任务详情
     */
    public function detail($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->with(['user'])->find($id);
        if (!$row) {
            $this->error(__('No Results were found'));
        }

        // 获取该用户的商户信息 ID，用于详情页跳转
        $merchant = \app\common\model\merchant\Merchant::where('user_id', $row->user_id)->find();
        $merchant_id = $merchant ? $merchant->id : 0;

        $subtasks = \app\common\model\task\SubTask::where('task_id', $id)
            ->order('id', 'asc')
            ->select();
            
        // 统计子任务进度
        $stats = [
            'total' => count($subtasks),
            'pending' => 0,
            'assigned' => 0,
            'accepted' => 0,
            'paid' => 0,
            'completed' => 0,
            'failed' => 0,
            'total_commission' => 0,
        ];
        
        foreach ($subtasks as $sub) {
            if (isset($stats[$sub['status']])) {
                $stats[$sub['status']]++;
            }
            if ($sub['status'] == 'completed') {
                $stats['total_commission'] += $sub['commission'];
            }
        }
        
        // 计算完成进度
        $stats['progress'] = $stats['total'] > 0 ? round(($stats['completed'] / $stats['total']) * 100, 2) : 0;
        
        if ($this->request->isAjax()) {
            $this->success('获取成功', null, [
                'task' => $row,
                'subtasks' => $subtasks,
                'stats' => $stats
            ]);
        }
        $this->view->assign('row', $row);
        $this->view->assign('subtasks', $subtasks);
        $this->view->assign('stats', $stats);
        $this->view->assign('merchant_id', $merchant_id);
        return $this->view->fetch();
    }

    /**
     * 一键派发所有进行中任务
     */
    public function dispatchAll()
    {
        $tasks = $this->model->where('status', 'running')->select();
        $count = 0;
        foreach ($tasks as $task) {
            try {
                TaskService::dispatchSubTasks($task->id);
                $count++;
            } catch (\Exception $e) {
                continue;
            }
        }
        $this->success('派发完成，处理了 ' . $count . ' 个任务');
    }
}
