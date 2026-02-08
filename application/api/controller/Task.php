<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\TaskService;
use app\common\model\TaskType;

class Task extends Api
{
    protected $noNeedLogin = ['types'];
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
            'hasMore' => $list->currentPage() < $list->lastPage()
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
        
        // 判断当前用户是否为任务发布者
        $isOwner = ($task->user_id === $this->auth->id);
        
        // 非发布者只能查看运行中的任务
        if (!$isOwner && $task->status !== 'running') {
            $this->error('任务不可查看');
        }
        
        $this->success('获取成功', ['task' => $task, 'isOwner' => $isOwner]);
    }

    public function create()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        $rule = [
            'total_amount' => 'require|float|gt:0',
            'start_time' => 'require',
            'end_time' => 'require'
        ];
        
        $msg = [
            'total_amount.require' => '请输入目标金额',
            'total_amount.float' => '目标金额格式不正确',
            'total_amount.gt' => '目标金额必须大于0',
            'start_time.require' => '请选择开始时间',
            'end_time.require' => '请选择结束时间'
        ];
        
        $validate = $this->validate($data, $rule, $msg);
        if ($validate !== true) {
            $this->error($validate);
        }
        
        // 验证时间逻辑
        $startTime = strtotime($data['start_time']);
        $endTime = strtotime($data['end_time']);
        if ($endTime <= $startTime) {
            $this->error('结束时间必须大于开始时间');
        }
        
        $task = TaskService::createTask($userId, $data);
        $this->success('创建成功，等待审核', ['task' => $task]);
    }

    public function cancel()
    {
        $taskId = $this->request->post('task_id');
        $reason = $this->request->post('reason', '');
        
        if (!$taskId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        $task = TaskService::cancelTask($taskId, $userId, $reason);
        $this->success('取消成功', ['task' => $task]);
    }

    /**
     * 缴纳/补缴保证金
     */
    public function payDeposit()
    {
        $taskId = $this->request->post('task_id');
        $amount = $this->request->post('amount');  // 可选，不传则缴纳全部剩余
        
        if (!$taskId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        try {
            $task = TaskService::payDeposit($taskId, $userId, $amount);
        } catch (\think\exception\HttpResponseException $e) {
            throw $e;
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
        
        $isFirstPayment = $task->status === 'deposit_paid';
        $msg = $isFirstPayment ? '保证金缴纳成功，等待后台审核' : '保证金补缴成功';
        $this->success($msg, ['task' => $task]);
    }

    /**
     * 获取任务保证金信息
     */
    public function getDepositInfo()
    {
        $taskId = $this->request->get('task_id');
        
        if (!$taskId) {
            $this->error('参数缺失');
        }
        
        $task = TaskService::getTaskDetail($taskId);
        if (!$task) {
            $this->error('任务不存在');
        }
        
        // 计算已缴纳和待缴纳金额
        $paidAmount = $task->deposit_amount ?: '0.00';
        $remainingAmount = bcsub($task->total_amount, $paidAmount, 2);
        $progress = bccomp($task->total_amount, '0', 2) > 0 
            ? round(($paidAmount / $task->total_amount) * 100, 2) 
            : 0;
        
        // 获取缴纳记录
        $logs = \app\common\model\task\TaskDepositLog::getByTaskId($taskId);
        
        $this->success('获取成功', [
            'task_id' => $task->id,
            'total_amount' => $task->total_amount,
            'paid_amount' => $paidAmount,
            'remaining_amount' => $remainingAmount,
            'progress' => $progress,
            'status' => $task->status,
            'status_text' => $task->status_text,
            'logs' => $logs
        ]);
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
        $status = $this->request->get('status', '');
        
        $userId = $this->auth->id;
        $list = TaskService::getUserAcceptedSubTasks($userId, $status, $page, $limit);
        
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
        
        $subTask = TaskService::acceptSubTask($subTaskId, $userId);
        $this->success('接单成功', ['subtask' => $subTask]);
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
        
        $subTask = TaskService::uploadProof($subTaskId, $userId, $proofImage, $thirdOrderNo);
        $this->success('上传成功', ['subtask' => $subTask]);
    }

    public function subtaskCancel()
    {
        $subTaskId = $this->request->post('subtask_id');
        if (!$subTaskId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        $subTask = TaskService::cancelSubTask($subTaskId, $userId);
        $this->success('取消成功', ['subtask' => $subTask]);
    }

    /**
     * 发布者确认子任务完成
     */
    public function subtaskConfirm()
    {
        $subTaskId = $this->request->post('subtask_id');
        if (!$subTaskId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        // 验证是否为任务发布者
        $subTask = \app\common\model\task\SubTask::find($subTaskId);
        if (!$subTask) {
            $this->error('子任务不存在');
        }
        
        if ($subTask->from_user_id !== $userId) {
            $this->error('无权操作');
        }
        
        if (!in_array($subTask->status, ['paid', 'verified'])) {
            $this->error('当前状态不允许确认');
        }
        
        $count = TaskService::completeSubTask($subTaskId);
        $this->success('确认成功', ['count' => $count]);
    }

    /**
     * 发布者拒绝子任务
     */
    public function subtaskReject()
    {
        $subTaskId = $this->request->post('subtask_id');
        $reason = $this->request->post('reason', '凭证不符合要求');
        
        if (!$subTaskId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        // 验证是否为任务发布者
        $subTask = \app\common\model\task\SubTask::find($subTaskId);
        if (!$subTask) {
            $this->error('子任务不存在');
        }
        
        if ($subTask->from_user_id !== $userId) {
            $this->error('无权操作');
        }
        
        if (!in_array($subTask->status, ['paid', 'verified'])) {
            $this->error('当前状态不允许拒绝');
        }
        
        $count = TaskService::failSubTask($subTaskId, $reason);
        $this->success('已拒绝', ['count' => $count]);
    }

    public function depositInfo()
    {
        $userId = $this->auth->id;
        $wallet = \app\common\library\WalletService::getWallet($userId);
        
        $this->success('获取成功', [
            'deposit' => $wallet->deposit,
            'frozen' => $wallet->frozen,
            'available' => $wallet->getAvailableDeposit()
        ]);
    }

    public function depositRecharge()
    {
        $amount = $this->request->post('amount');
        $payMethod = $this->request->post('pay_method', 'balance');
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        
        $userId = $this->auth->id;
        
        if ($payMethod === 'balance') {
            \app\common\library\WalletService::changeBalance($userId, '-' . $amount, 'deposit_recharge', 0, '充值保证金');
            \app\common\library\WalletService::changeDeposit($userId, $amount, 'deposit_recharge', 0, '充值保证金');
            $this->success('充值成功');
        } else {
            $recharge = \app\common\library\WalletService::rechargeDeposit($userId, $amount, $payMethod);
            $this->success('创建成功', ['recharge' => $recharge]);
        }
    }

    public function depositWithdraw()
    {
        $amount = $this->request->post('amount');
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        
        $userId = $this->auth->id;
        
        $wallet = \app\common\library\WalletService::getWallet($userId);
        $available = $wallet->getAvailableDeposit();
        
        if (bccomp($available, $amount, 2) < 0) {
            $this->error('可用保证金不足');
        }
        
        \app\common\library\WalletService::changeDeposit($userId, '-' . $amount, 'deposit_withdraw', 0, '提取保证金');
        \app\common\library\WalletService::changeBalance($userId, $amount, 'deposit_withdraw', 0, '提取保证金');
        
        $this->success('提取成功');
    }

    /**
     * 获取任务类型列表
     */
    public function types()
    {
        $list = TaskType::getAvailableTypes();
        $this->success('获取成功', ['list' => $list]);
    }
}
