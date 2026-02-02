<?php
namespace app\common\model\wallet;

use think\Model;

class Recharge extends Model
{
    protected $name = 'recharge';
    protected $autoWriteTimestamp = true;

    protected $append = ['status_text', 'target_text'];

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['order_no'])) {
                $row['order_no'] = self::generateOrderNo();
            }
        });
    }

    public function getStatusTextAttr($value, $data)
    {
        $list = ['pending' => '待支付', 'paid' => '已支付', 'failed' => '失败'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function getTargetTextAttr($value, $data)
    {
        $list = ['balance' => '余额', 'deposit' => '保证金'];
        return isset($list[$data['target']]) ? $list[$data['target']] : '';
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public static function generateOrderNo()
    {
        return 'R' . date('YmdHis') . str_pad(mt_rand(1, 9999), 4, '0', STR_PAD_LEFT);
    }

    public static function createRecharge($userId, $amount, $target = 'balance', $payMethod = '')
    {
        return self::create([
            'user_id' => $userId,
            'order_no' => self::generateOrderNo(),
            'amount' => $amount,
            'target' => $target,
            'pay_method' => $payMethod,
            'status' => 'pending'
        ]);
    }
}
