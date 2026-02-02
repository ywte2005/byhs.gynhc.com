<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\TaskService;
use app\common\model\task\SubTask;
use app\common\model\wallet\Recharge;
use app\common\library\WalletService;
use think\Db;

/**
 * 第三方支付回调接口
 */
class Notify extends Api
{
    protected $noNeedLogin = ['*'];
    protected $noNeedRight = ['*'];

    /**
     * 支付回调通知 - 充值订单
     */
    public function recharge()
    {
        $data = $this->request->post();
        
        // 验证签名（根据实际支付通道调整）
        if (!$this->verifySign($data)) {
            return $this->error('签名验证失败');
        }
        
        $orderNo = $data['out_trade_no'] ?? '';
        $tradeNo = $data['trade_no'] ?? '';
        $amount = $data['amount'] ?? 0;
        $status = $data['status'] ?? '';
        
        if (empty($orderNo)) {
            return $this->error('订单号不能为空');
        }
        
        Db::startTrans();
        try {
            $recharge = Recharge::where('order_no', $orderNo)->lock(true)->find();
            if (!$recharge) {
                throw new \Exception('订单不存在');
            }
            
            if ($recharge->status !== 'pending') {
                Db::commit();
                return $this->success('订单已处理');
            }
            
            if ($status === 'success' || $status === 'paid') {
                // 充值成功
                $recharge->status = 'paid';
                $recharge->trade_no = $tradeNo;
                $recharge->paid_time = time();
                $recharge->save();
                
                // 根据充值目标处理
                if ($recharge->target === 'balance') {
                    WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge', $recharge->id, '充值到账');
                } elseif ($recharge->target === 'deposit') {
                    WalletService::changeBalance($recharge->user_id, $recharge->amount, 'recharge', $recharge->id, '充值');
                    WalletService::changeBalance($recharge->user_id, '-' . $recharge->amount, 'deposit_pay', $recharge->id, '保证金充值');
                    WalletService::changeDeposit($recharge->user_id, $recharge->amount, 'deposit_pay', $recharge->id, '保证金充值');
                }
            } else {
                $recharge->status = 'failed';
                $recharge->save();
            }
            
            Db::commit();
            return $this->success('处理成功');
        } catch (\Exception $e) {
            Db::rollback();
            return $this->error($e->getMessage());
        }
    }

    /**
     * 支付回调通知 - 刷单验证（第三方交易数据推送）
     */
    public function subtask()
    {
        $data = $this->request->post();
        
        // 验证签名
        if (!$this->verifySign($data)) {
            return $this->error('签名验证失败');
        }
        
        $thirdOrderNo = $data['order_no'] ?? '';
        $amount = $data['amount'] ?? 0;
        $status = $data['status'] ?? '';
        
        if (empty($thirdOrderNo)) {
            return $this->error('订单号不能为空');
        }
        
        Db::startTrans();
        try {
            $subTask = SubTask::where('third_order_no', $thirdOrderNo)->lock(true)->find();
            if (!$subTask) {
                throw new \Exception('子任务不存在');
            }
            
            if ($subTask->status === 'completed') {
                Db::commit();
                return $this->success('任务已完成');
            }
            
            if ($subTask->status !== 'paid' && $subTask->status !== 'verified') {
                throw new \Exception('任务状态不正确');
            }
            
            // 金额校验
            if (bccomp($amount, $subTask->amount, 2) < 0) {
                throw new \Exception('支付金额不足');
            }
            
            if ($status === 'success' || $status === 'paid') {
                // 验证通过，完成子任务
                $subTask->status = 'verified';
                $subTask->save();
                
                TaskService::completeSubTask($subTask->id);
            } else {
                TaskService::failSubTask($subTask->id, '第三方支付验证失败');
            }
            
            Db::commit();
            return $this->success('处理成功');
        } catch (\Exception $e) {
            Db::rollback();
            return $this->error($e->getMessage());
        }
    }

    /**
     * 手动触发验证子任务（管理员或定时任务调用）
     */
    public function verifySubTask()
    {
        $subTaskId = $this->request->post('subtask_id');
        $thirdOrderNo = $this->request->post('third_order_no');
        
        if (!$subTaskId) {
            return $this->error('参数缺失');
        }
        
        try {
            $subTask = SubTask::find($subTaskId);
            if (!$subTask) {
                throw new \Exception('子任务不存在');
            }
            
            // 调用第三方接口查询订单状态
            $result = $this->queryThirdPartyOrder($subTask->third_order_no ?: $thirdOrderNo);
            
            if ($result['success']) {
                TaskService::completeSubTask($subTaskId);
                return $this->success('验证通过，任务已完成');
            } else {
                return $this->error('第三方订单验证失败：' . ($result['message'] ?? '未知错误'));
            }
        } catch (\Exception $e) {
            return $this->error($e->getMessage());
        }
    }

    /**
     * 验证签名（根据实际支付通道实现）
     */
    protected function verifySign($data)
    {
        // TODO: 根据实际接入的支付通道实现签名验证
        // 示例：
        // $sign = $data['sign'] ?? '';
        // unset($data['sign']);
        // ksort($data);
        // $str = http_build_query($data) . '&key=' . config('payment.secret_key');
        // return $sign === md5($str);
        
        return true; // 暂时返回true，实际使用时需要实现
    }

    /**
     * 查询第三方订单状态
     */
    protected function queryThirdPartyOrder($orderNo)
    {
        // TODO: 根据实际接入的支付通道实现订单查询
        // 示例：调用第三方API查询订单状态
        
        return ['success' => true, 'message' => ''];
    }
}
