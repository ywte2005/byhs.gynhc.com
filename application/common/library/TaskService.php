<?php
namespace app\common\library;

use app\common\model\task\MutualTask;
use app\common\model\task\SubTask;
use app\common\model\promo\Level;
use app\common\model\promo\Relation;
use app\common\model\wallet\Wallet;
use think\Db;

class TaskService
{
    public static function createTask($userId, $data)
    {
        Db::startTrans();
        try {
            $totalAmount = $data['total_amount'];
            $serviceFeeRate = $data['service_fee_rate'] ?? 0.01;
            
            // 处理时间格式
            $startTime = is_numeric($data['start_time']) ? $data['start_time'] : strtotime($data['start_time']);
            $endTime = is_numeric($data['end_time']) ? $data['end_time'] : strtotime($data['end_time']);
            
            // 处理收款类型
            $receiptType = ($data['collection_type'] ?? 'merchant') === 'merchant' ? 'entry' : 'collection';
            
            $task = MutualTask::create([
                'user_id' => $userId,
                'task_no' => MutualTask::generateTaskNo(),
                'title' => $data['title'] ?? '',
                'category' => $data['type_code'] ?? '',
                'total_amount' => $totalAmount,
                'completed_amount' => 0,
                'pending_amount' => 0,
                'deposit_amount' => 0,
                'frozen_amount' => 0,
                'service_fee_rate' => $serviceFeeRate,
                'sub_task_min' => $data['sub_task_min'] ?? 2000,
                'sub_task_max' => $data['sub_task_max'] ?? 5000,
                'channel_id' => $data['channel_id'] ?? 0,
                'receipt_type' => $receiptType,
                'collection_qrcode' => $data['qr_code'] ?? '',
                'start_time' => $startTime,
                'end_time' => $endTime,
                'status' => 'pending',
                'remark' => $data['remark'] ?? ''
            ]);
            
            Db::commit();
            return $task;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function approveTask($taskIds, $adminId = 0)
    {
        $ids = is_array($taskIds) ? $taskIds : explode(',', $taskIds);
        $count = 0;
        Db::startTrans();
        try {
            foreach ($ids as $taskId) {
                $task = MutualTask::lock(true)->find($taskId);
                if ($task && $task->status === 'pending') {
                    $task->status = 'approved';
                    $task->save();
                    
                    self::splitTask($task);
                    
                    $task->status = 'running';
                    $task->save();
                    $count++;
                }
            }
            Db::commit();
            return $count;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function rejectTask($taskIds, $reason, $adminId = 0)
    {
        $ids = is_array($taskIds) ? $taskIds : explode(',', $taskIds);
        $count = 0;
        Db::startTrans();
        try {
            foreach ($ids as $taskId) {
                $task = MutualTask::lock(true)->find($taskId);
                if ($task && $task->status === 'pending') {
                    WalletService::changeDeposit($task->user_id, '-' . $task->deposit_amount, 'task_reject', $taskId, '任务拒绝退回');
                    WalletService::changeBalance($task->user_id, $task->deposit_amount, 'task_reject', $taskId, '任务拒绝退回保证金');
                    
                    $task->status = 'rejected';
                    $task->reject_reason = $reason;
                    $task->save();
                    $count++;
                }
            }
            Db::commit();
            return $count;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    protected static function splitTask($task)
    {
        $remaining = $task->total_amount;
        $min = $task->sub_task_min;
        $max = $task->sub_task_max;
        
        while (bccomp($remaining, '0', 2) > 0) {
            if (bccomp($remaining, $min, 2) < 0) {
                $amount = $remaining;
            } elseif (bccomp($remaining, $max, 2) <= 0) {
                $amount = $remaining;
            } else {
                $amount = mt_rand($min * 100, $max * 100) / 100;
                $amount = min($amount, $remaining);
            }
            
            $commission = bcmul($amount, '0.002', 2);
            $serviceFee = bcmul($amount, $task->service_fee_rate, 2);
            
            SubTask::create([
                'task_id' => $task->id,
                'task_no' => SubTask::generateTaskNo(),
                'from_user_id' => $task->user_id,
                'to_user_id' => 0,
                'amount' => $amount,
                'commission' => $commission,
                'service_fee' => $serviceFee,
                'status' => 'pending'
            ]);
            
            $remaining = bcsub($remaining, $amount, 2);
        }
    }

    public static function dispatchSubTasks($taskIds)
    {
        $ids = is_array($taskIds) ? $taskIds : explode(',', $taskIds);
        foreach ($ids as $taskId) {
            $task = MutualTask::find($taskId);
            if (!$task || $task->status !== 'running') {
                continue;
            }
            
            $pendingSubTasks = SubTask::where('task_id', $taskId)
                ->where('status', 'pending')
                ->select();
            
            foreach ($pendingSubTasks as $subTask) {
                try {
                    self::assignSubTask($subTask);
                } catch (\Exception $e) {
                    continue;
                }
            }
        }
        return true;
    }

    protected static function assignSubTask($subTask)
    {
        Db::startTrans();
        try {
            $task = MutualTask::lock(true)->find($subTask->task_id);
            $wallet = Wallet::where('user_id', $task->user_id)->lock(true)->find();
            
            $availableDeposit = bcsub($wallet->deposit, $wallet->frozen, 2);
            if (bccomp($availableDeposit, $subTask->amount, 2) < 0) {
                throw new \Exception('保证金不足');
            }
            
            $toUser = self::findAvailableExecutor($task->user_id, $subTask->amount);
            if (!$toUser) {
                throw new \Exception('暂无可用执行方');
            }
            
            WalletService::freezeDeposit($task->user_id, $subTask->amount, 'subtask_assign', $subTask->id, '子任务派发冻结');
            
            $task->frozen_amount = bcadd($task->frozen_amount, $subTask->amount, 2);
            $task->save();
            
            $subTask->status = 'assigned';
            $subTask->assigned_time = time();
            $subTask->save();
            
            Db::commit();
            return true;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    protected static function findAvailableExecutor($excludeUserId, $amount)
    {
        $minMutualBalance = -20000;
        
        $wallets = Wallet::where('user_id', '<>', $excludeUserId)
            ->where('mutual_balance', '>=', $minMutualBalance)
            ->order('mutual_balance', 'desc')
            ->limit(10)
            ->select();
        
        foreach ($wallets as $wallet) {
            $relation = Relation::getByUserId($wallet->user_id);
            if ($relation && $relation->level_id > 0) {
                return $wallet->user_id;
            }
        }
        
        return null;
    }

    public static function canReceiveTask($userId)
    {
        $wallet = Wallet::getByUserId($userId);
        $pauseThreshold = -50000;
        $resumeThreshold = -20000;
        
        if (bccomp($wallet->mutual_balance, $pauseThreshold, 2) < 0) {
            return ['can' => false, 'reason' => '互助余额过低，暂停接单'];
        }
        
        if (bccomp($wallet->mutual_balance, $resumeThreshold, 2) < 0) {
            return ['can' => false, 'reason' => '互助余额不足，请先帮助他人刷单'];
        }
        
        return ['can' => true, 'reason' => ''];
    }

    public static function acceptSubTask($subTaskId, $userId)
    {
        Db::startTrans();
        try {
            $subTask = SubTask::lock(true)->find($subTaskId);
            if (!$subTask) {
                throw new \Exception('子任务不存在');
            }
            if ($subTask->status !== 'assigned') {
                throw new \Exception('当前状态不允许接单');
            }
            if ($subTask->from_user_id === $userId) {
                throw new \Exception('不能接自己的任务');
            }
            if ($subTask->to_user_id > 0) {
                throw new \Exception('该任务已被接单');
            }
            
            $subTask->accept($userId);
            
            Db::commit();
            return $subTask;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function uploadProof($subTaskId, $userId, $proofImage, $thirdOrderNo = '')
    {
        $subTask = SubTask::find($subTaskId);
        if (!$subTask) {
            throw new \Exception('子任务不存在');
        }
        if ($subTask->to_user_id !== $userId) {
            throw new \Exception('无权操作');
        }
        
        $subTask->uploadProof($proofImage, $thirdOrderNo);
        return $subTask;
    }

    public static function completeSubTask($subTaskIds)
    {
        $ids = is_array($subTaskIds) ? $subTaskIds : explode(',', $subTaskIds);
        $count = 0;
        Db::startTrans();
        try {
            foreach ($ids as $subTaskId) {
                $subTask = SubTask::lock(true)->find($subTaskId);
                if ($subTask && in_array($subTask->status, ['paid', 'verified'])) {
                    $subTask->complete();
                    SettlementService::settleSubTask($subTask);
                    
                    $task = MutualTask::find($subTask->task_id);
                    $task->updateProgress();
                    $count++;
                }
            }
            Db::commit();
            return $count;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function failSubTask($subTaskIds, $reason)
    {
        $ids = is_array($subTaskIds) ? $subTaskIds : explode(',', $subTaskIds);
        $count = 0;
        Db::startTrans();
        try {
            foreach ($ids as $subTaskId) {
                $subTask = SubTask::lock(true)->find($subTaskId);
                if ($subTask && !in_array($subTask->status, ['completed', 'cancelled', 'failed'])) {
                    $task = MutualTask::find($subTask->task_id);
                    
                    WalletService::unfreezeDeposit($task->user_id, $subTask->amount, 'subtask_fail', $subTask->id, '子任务失败解冻');
                    
                    $task->frozen_amount = bcsub($task->frozen_amount, $subTask->amount, 2);
                    $task->save();
                    
                    $subTask->fail($reason);
                    
                    $subTask->status = 'pending';
                    $subTask->to_user_id = 0;
                    $subTask->proof_image = null;
                    $subTask->third_order_no = null;
                    $subTask->save();
                    $count++;
                }
            }
            Db::commit();
            return $count;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function getAvailableSubTasks($userId, $category = null, $page = 1, $limit = 20)
    {
        return SubTask::getAvailableForUser($userId, $category, $page, $limit);
    }

    public static function getUserAcceptedSubTasks($userId, $page = 1, $limit = 20)
    {
        return SubTask::getUserAccepted($userId, $page, $limit);
    }

    public static function getUserTasks($userId, $status = null, $page = 1, $limit = 20)
    {
        $query = MutualTask::where('user_id', $userId);
        if ($status !== null) {
            $query->where('status', $status);
        }
        return $query->order('id', 'desc')->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function getTaskDetail($taskId)
    {
        return MutualTask::with(['subTasks'])->find($taskId);
    }

    public static function getSubTaskDetail($subTaskId)
    {
        return SubTask::find($subTaskId);
    }

    public static function cancelSubTask($subTaskId, $userId)
    {
        Db::startTrans();
        try {
            $subTask = SubTask::lock(true)->find($subTaskId);
            if (!$subTask) {
                throw new \Exception('子任务不存在');
            }
            if ($subTask->to_user_id !== $userId) {
                throw new \Exception('无权操作');
            }
            if (!in_array($subTask->status, ['assigned', 'accepted'])) {
                throw new \Exception('当前状态不允许取消');
            }
            
            $task = MutualTask::lock(true)->find($subTask->task_id);
            
            WalletService::unfreezeDeposit($task->user_id, $subTask->amount, 'subtask_cancel', $subTask->id, '子任务取消解冻');
            
            $task->frozen_amount = bcsub($task->frozen_amount, $subTask->amount, 2);
            $task->save();
            
            $subTask->status = 'pending';
            $subTask->to_user_id = 0;
            $subTask->accepted_time = null;
            $subTask->assigned_time = null;
            $subTask->save();
            
            Db::commit();
            return $subTask;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function cancelTask($taskId, $userId, $reason = '')
    {
        Db::startTrans();
        try {
            $task = MutualTask::lock(true)->find($taskId);
            if (!$task) {
                throw new \Exception('任务不存在');
            }
            if ($task->user_id !== $userId) {
                throw new \Exception('无权操作');
            }
            
            $allowedStatus = ['pending', 'approved', 'running', 'paused'];
            if (!in_array($task->status, $allowedStatus)) {
                throw new \Exception('当前状态不允许取消');
            }
            
            $hasActiveSubTasks = SubTask::where('task_id', $taskId)
                ->whereIn('status', ['accepted', 'paid', 'verified'])
                ->count();
            
            if ($hasActiveSubTasks > 0) {
                throw new \Exception('存在进行中的子任务，无法取消');
            }
            
            $pendingSubTasks = SubTask::where('task_id', $taskId)
                ->whereIn('status', ['pending', 'assigned'])
                ->select();
            
            foreach ($pendingSubTasks as $subTask) {
                if ($subTask->status === 'assigned' && bccomp($task->frozen_amount, $subTask->amount, 2) >= 0) {
                    WalletService::unfreezeDeposit($task->user_id, $subTask->amount, 'task_cancel', $subTask->id, '任务取消解冻');
                    $task->frozen_amount = bcsub($task->frozen_amount, $subTask->amount, 2);
                }
                $subTask->status = 'cancelled';
                $subTask->save();
            }
            
            $refundDeposit = bcsub($task->deposit_amount, $task->frozen_amount, 2);
            if (bccomp($refundDeposit, '0', 2) > 0) {
                WalletService::changeDeposit($task->user_id, '-' . $refundDeposit, 'task_cancel', $taskId, '任务取消退回保证金');
                WalletService::changeBalance($task->user_id, $refundDeposit, 'task_cancel', $taskId, '任务取消退回保证金');
            }
            
            $task->status = 'cancelled';
            $task->remark = $reason ?: '用户主动取消';
            $task->save();
            
            Db::commit();
            return $task;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }
}
