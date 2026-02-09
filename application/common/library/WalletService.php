<?php
namespace app\common\library;

use app\common\model\wallet\Wallet;
use app\common\model\wallet\WalletLog;
use app\common\model\wallet\Withdraw;
use app\common\model\wallet\Recharge;
use think\Db;

class WalletService
{
    public static function getWallet($userId)
    {
        return Wallet::getByUserId($userId);
    }

    public static function changeBalance($userId, $amount, $bizType, $bizId, $remark = '')
    {
        $wallet = self::getWallet($userId);
        return $wallet->changeBalance($amount, $bizType, $bizId, $remark);
    }

    public static function changeDeposit($userId, $amount, $bizType, $bizId, $remark = '')
    {
        $wallet = self::getWallet($userId);
        return $wallet->changeDeposit($amount, $bizType, $bizId, $remark);
    }

    public static function freezeDeposit($userId, $amount, $bizType, $bizId, $remark = '')
    {
        $wallet = self::getWallet($userId);
        return $wallet->freezeDeposit($amount, $bizType, $bizId, $remark);
    }

    public static function unfreezeDeposit($userId, $amount, $bizType, $bizId, $remark = '')
    {
        $wallet = self::getWallet($userId);
        return $wallet->unfreezeDeposit($amount, $bizType, $bizId, $remark);
    }

    /**
     * 解冻并扣除保证金（用于子任务完成结算）
     * 将冻结的保证金直接扣除，不经过可用余额
     */
    public static function unfreezeAndDeduct($userId, $amount, $bizType, $bizId, $remark = '')
    {
        $wallet = self::getWallet($userId);
        return $wallet->unfreezeAndDeduct($amount, $bizType, $bizId, $remark);
    }

    public static function changeMutualBalance($userId, $amount, $bizType, $bizId, $remark = '')
    {
        $wallet = self::getWallet($userId);
        return $wallet->changeMutualBalance($amount, $bizType, $bizId, $remark);
    }

    public static function createWithdraw($userId, $amount, $bankInfo)
    {
        Db::startTrans();
        try {
            $wallet = self::getWallet($userId);
            if (bccomp($wallet->balance, $amount, 2) < 0) {
                throw new \Exception('余额不足');
            }
            
            $wallet->changeBalance('-' . $amount, 'withdraw_freeze', 0, '提现冻结');
            $withdraw = Withdraw::createWithdraw($userId, $amount, $bankInfo);
            
            Db::commit();
            return $withdraw;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function rechargeBalance($userId, $amount, $payMethod = '')
    {
        return Recharge::createRecharge($userId, $amount, 'balance', $payMethod);
    }

    public static function rechargeDeposit($userId, $amount, $payMethod = '')
    {
        return Recharge::createRecharge($userId, $amount, 'deposit', $payMethod);
    }

    public static function confirmRecharge($orderNo)
    {
        Db::startTrans();
        try {
            $recharge = Recharge::where('order_no', $orderNo)->lock(true)->find();
            if (!$recharge || $recharge->status !== 'pending') {
                throw new \Exception('订单不存在或已处理');
            }
            
            $wallet = self::getWallet($recharge->user_id);
            if ($recharge->target === 'balance') {
                $wallet->changeBalance($recharge->amount, 'recharge', $recharge->id, '充值');
            } else {
                $wallet->changeDeposit($recharge->amount, 'recharge', $recharge->id, '充值保证金');
            }
            
            $recharge->status = 'paid';
            $recharge->paid_time = time();
            $recharge->save();
            
            Db::commit();
            return $recharge;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function getLogs($userId, $walletType = null, $page = 1, $limit = 20)
    {
        return WalletLog::getUserLogs($userId, $walletType, $page, $limit);
    }

    public static function getWithdrawRecords($userId, $page = 1, $limit = 20)
    {
        return Withdraw::getUserWithdraws($userId, $page, $limit);
    }
}
