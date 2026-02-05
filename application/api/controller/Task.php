<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\TaskService;

class Task extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    /**
     * 任务大厅列表（可接的子任务）
     */
    public function list()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        $category = $this->request->get('category', null);
        
        // 如果category为'all'，则不筛选
        if ($category === 'all') {
            $category = null;
        }
        
        $userId = $this->auth->id;
        $list = TaskService::getAvailableSubTasks($userId, $category, $page, $limit);
        
        $this->success('获取成功', [
            'list' => $list->items(), 
            'total' => $list->total(),
            'hasMore' => $list->hasMore()
        ]);
    }

    public function detail()
    {
        $taskId = $this->request->get('task_id');
        if (!$taskId) {
            $this->error('参数缺失');
        }
        
        $task = TaskService::getTaskDetail($taskId);
        if (!$task) {
            $this->error('任务不存在');
        }
        
        if ($task->user_id !== $this->auth->id) {
            $this->error('无权查看');
        }
        
        $this->success('获取成功', ['task' => $task]);
    }

    public function create()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        $rule = [
            'total_amount' => 'require|float|gt:0',
            'deposit_amount' => 'require|float|gt:0'
        ];
        
        $validate = $this->validate($data, $rule);
        if ($validate !== true) {
            $this->error($validate);
        }
        
        try {
            $task = TaskService::createTask($userId, $data);
            $this->success('创建成功，等待审核', ['task' => $task]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function cancel()
    {
        $taskId = $this->request->post('task_id');
        if (!$taskId) {
            $this->error('参数缺失');
        }
        
        $this->error('暂不支持取消');
    }

    public function myTasks()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = TaskService::getUserTasks($userId, null, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function subtaskAvailable()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = TaskService::getAvailableSubTasks($userId, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function subtaskMy()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = TaskService::getUserAcceptedSubTasks($userId, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function subtaskDetail()
    {
        $subTaskId = $this->request->get('subtask_id');
        if (!$subTaskId) {
            $this->error('参数缺失');
        }
        
        $subTask = TaskService::getSubTaskDetail($subTaskId);
        if (!$subTask) {
            $this->error('子任务不存在');
        }
        
        $this->success('获取成功', ['subtask' => $subTask]);
    }

    public function subtaskAccept()
    {
        $subTaskId = $this->request->post('subtask_id');
        if (!$subTaskId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        // 检查互助余额是否允许接单
        $canReceive = TaskService::canReceiveTask($userId);
        if (!$canReceive['can']) {
            $this->error($canReceive['reason']);
        }
        
        try {
            $subTask = TaskService::acceptSubTask($subTaskId, $userId);
            $this->success('接单成功', ['subtask' => $subTask]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    /**
     * 检查当前用户是否可以接单
     */
    public function canReceive()
    {
        $userId = $this->auth->id;
        $result = TaskService::canReceiveTask($userId);
        $this->success('获取成功', $result);
    }

    public function subtaskUploadProof()
    {
        $subTaskId = $this->request->post('subtask_id');
        $proofImage = $this->request->post('proof_image');
        $thirdOrderNo = $this->request->post('third_order_no', '');
        
        if (!$subTaskId || !$proofImage) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        try {
            $subTask = TaskService::uploadProof($subTaskId, $userId, $proofImage, $thirdOrderNo);
            $this->success('上传成功', ['subtask' => $subTask]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function subtaskCancel()
    {
        $this->error('暂不支持取消');
    }
}
