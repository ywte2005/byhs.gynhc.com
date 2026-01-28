<?php
namespace app\common\model\promo;

use think\Model;

class Bonus extends Model
{
    protected $name = 'promo_bonus';
    protected $autoWriteTimestamp = 'createtime';
    protected $updateTime = false;

    protected $append = ['status_text'];

    public function getStatusTextAttr($value, $data)
    {
        $list = ['pending' => '待发放', 'settled' => '已发放', 'cancelled' => '已取消'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function config()
    {
        return $this->belongsTo('app\common\model\promo\BonusConfig', 'config_id', 'id');
    }

    public static function getUserBonuses($userId, $page = 1, $limit = 20)
    {
        return self::where('user_id', $userId)->order('id', 'desc')->paginate(['page' => $page, 'list_rows' => $limit]);
    }
}
