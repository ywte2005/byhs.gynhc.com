<?php
namespace app\common\model\wallet;

use think\Model;

class WalletLog extends Model
{
    protected $name = 'wallet_log';
    protected $autoWriteTimestamp = 'createtime';
    protected $updateTime = false;

    protected $append = ['wallet_type_text', 'change_type_text'];

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function getWalletTypeTextAttr($value, $data)
    {
        $list = ['balance' => '余额', 'deposit' => '保证金', 'frozen' => '冻结', 'mutual' => '互助余额'];
        return isset($list[$data['wallet_type']]) ? $list[$data['wallet_type']] : '';
    }

    public function getChangeTypeTextAttr($value, $data)
    {
        $list = ['income' => '收入', 'expense' => '支出', 'freeze' => '冻结', 'unfreeze' => '解冻'];
        return isset($list[$data['change_type']]) ? $list[$data['change_type']] : '';
    }

    public static function getUserLogs($userId, $walletType = null, $page = 1, $limit = 20)
    {
        $query = self::where('user_id', $userId);
        if ($walletType !== null) {
            $query->where('wallet_type', $walletType);
        }
        return $query->order('id', 'desc')->paginate(['page' => $page, 'list_rows' => $limit]);
    }
}
