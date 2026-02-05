<?php
namespace app\common\model\wallet;

use think\Model;
use think\Db;

class Wallet extends Model
{
    protected $name = 'wallet';
    protected $autoWriteTimestamp = true;
    protected $createTime = false;
    protected $updateTime = 'updatetime';

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public static function getByUserId($userId)
    {
        $wallet = self::where('user_id', $userId)->find();
        if (!$wallet) {
            $wallet = self::create([
                'user_id' => $userId,
                'balance' => 0,
                'deposit' => 0,
                'frozen' => 0,
                'mutual_balance' => 0,
                'total_income' => 0,
                'total_withdraw' => 0
            ]);
        }
        return $wallet;
    }

    public function changeBalance($amount, $bizType, $bizId, $remark = '')
    {
        $before = $this->balance;
        $after = bcadd($before, $amount, 2);
        
        if (bccomp($after, '0', 2) < 0) {
            throw new \Exception('余额不足');
        }
        
        $changeType = bccomp($amount, '0', 2) >= 0 ? 'income' : 'expense';
        
        $this->balance = $after;
        if (bccomp($amount, '0', 2) > 0) {
            $this->total_income = bcadd($this->total_income, $amount, 2);
        }
        $this->save();
        
        WalletLog::create([
            'user_id' => $this->user_id,
            'wallet_type' => 'balance',
            'change_type' => $changeType,
            'amount' => abs($amount),
            'before_amount' => $before,
            'after_amount' => $after,
            'biz_type' => $bizType,
            'biz_id' => $bizId,
            'remark' => $remark
        ]);
        
        return $this;
    }

    public function changeDeposit($amount, $bizType, $bizId, $remark = '')
    {
        $before = $this->deposit;
        $after = bcadd($before, $amount, 2);
        
        if (bccomp($after, '0', 2) < 0) {
            throw new \Exception('保证金不足');
        }
        
        $changeType = bccomp($amount, '0', 2) >= 0 ? 'income' : 'expense';
        
        $this->deposit = $after;
        $this->save();
        
        WalletLog::create([
            'user_id' => $this->user_id,
            'wallet_type' => 'deposit',
            'change_type' => $changeType,
            'amount' => abs($amount),
            'before_amount' => $before,
            'after_amount' => $after,
            'biz_type' => $bizType,
            'biz_id' => $bizId,
            'remark' => $remark
        ]);
        
        return $this;
    }

    public function freezeDeposit($amount, $bizType, $bizId, $remark = '')
    {
        if (bccomp($amount, '0', 2) <= 0) {
            throw new \Exception('冻结金额必须大于0');
        }
        
        $available = bcsub($this->deposit, $this->frozen, 2);
        if (bccomp($available, $amount, 2) < 0) {
            throw new \Exception('可用保证金不足');
        }
        
        $before = $this->frozen;
        $after = bcadd($before, $amount, 2);
        
        $this->frozen = $after;
        $this->save();
        
        WalletLog::create([
            'user_id' => $this->user_id,
            'wallet_type' => 'frozen',
            'change_type' => 'freeze',
            'amount' => $amount,
            'before_amount' => $before,
            'after_amount' => $after,
            'biz_type' => $bizType,
            'biz_id' => $bizId,
            'remark' => $remark
        ]);
        
        return $this;
    }

    public function unfreezeDeposit($amount, $bizType, $bizId, $remark = '')
    {
        if (bccomp($amount, '0', 2) <= 0) {
            throw new \Exception('解冻金额必须大于0');
        }
        
        if (bccomp($this->frozen, $amount, 2) < 0) {
            throw new \Exception('冻结金额不足');
        }
        
        $before = $this->frozen;
        $after = bcsub($before, $amount, 2);
        
        $this->frozen = $after;
        $this->save();
        
        WalletLog::create([
            'user_id' => $this->user_id,
            'wallet_type' => 'frozen',
            'change_type' => 'unfreeze',
            'amount' => $amount,
            'before_amount' => $before,
            'after_amount' => $after,
            'biz_type' => $bizType,
            'biz_id' => $bizId,
            'remark' => $remark
        ]);
        
        return $this;
    }

    public function changeMutualBalance($amount, $bizType, $bizId, $remark = '')
    {
        $before = $this->mutual_balance;
        $after = bcadd($before, $amount, 2);
        
        $changeType = bccomp($amount, '0', 2) >= 0 ? 'income' : 'expense';
        
        $this->mutual_balance = $after;
        $this->save();
        
        WalletLog::create([
            'user_id' => $this->user_id,
            'wallet_type' => 'mutual',
            'change_type' => $changeType,
            'amount' => abs($amount),
            'before_amount' => $before,
            'after_amount' => $after,
            'biz_type' => $bizType,
            'biz_id' => $bizId,
            'remark' => $remark
        ]);
        
        return $this;
    }

    public function getAvailableDeposit()
    {
        return bcsub($this->deposit, $this->frozen, 2);
    }
}
