<?php
namespace app\common\model\wallet;

use think\Model;

class Withdraw extends Model
{
    protected $name = 'withdraw';
    protected $autoWriteTimestamp = true;

    protected $append = ['status_text'];

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['withdraw_no'])) {
                $row['withdraw_no'] = self::generateWithdrawNo();
            }
        });
    }

    public function getStatusTextAttr($value, $data)
    {
        $list = ['pending' => '待审核', 'approved' => '已审核', 'rejected' => '已拒绝', 'paid' => '已打款', 'failed' => '失败'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function admin()
    {
        return $this->belongsTo('app\admin\model\Admin', 'admin_id', 'id');
    }

    public static function generateWithdrawNo()
    {
        return 'W' . date('YmdHis') . str_pad(mt_rand(1, 9999), 4, '0', STR_PAD_LEFT);
    }

    public static function getUserWithdraws($userId, $page = 1, $limit = 20)
    {
        return self::where('user_id', $userId)->order('id', 'desc')->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function createWithdraw($userId, $amount, $bankInfo)
    {
        $fee = 0;
        $actualAmount = bcsub($amount, $fee, 2);
        
        return self::create([
            'user_id' => $userId,
            'withdraw_no' => self::generateWithdrawNo(),
            'amount' => $amount,
            'fee' => $fee,
            'actual_amount' => $actualAmount,
            'bank_name' => $bankInfo['bank_name'],
            'bank_account' => $bankInfo['bank_account'],
            'bank_branch' => $bankInfo['bank_branch'] ?? '',
            'account_name' => $bankInfo['account_name'],
            'status' => 'pending'
        ]);
    }
}
