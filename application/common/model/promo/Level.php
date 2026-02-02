<?php
namespace app\common\model\promo;

use think\Model;

class Level extends Model
{
    protected $name = 'promo_level';
    protected $autoWriteTimestamp = true;
    
    protected $append = [
        'status_text',
        'upgrade_type_text'
    ];

    public function getStatusTextAttr($value, $data)
    {
        $list = ['normal' => '正常', 'hidden' => '隐藏'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function getUpgradeTypeTextAttr($value, $data)
    {
        $list = ['purchase' => '购买升级', 'performance' => '业绩升级', 'both' => '两者皆可'];
        return isset($list[$data['upgrade_type']]) ? $list[$data['upgrade_type']] : '';
    }

    public static function getAll($status = 'normal')
    {
        return self::where('status', $status)->order('sort', 'asc')->select();
    }

    public static function getById($id)
    {
        return self::where('id', $id)->find();
    }

    public static function getNextLevel($currentSort)
    {
        return self::where('sort', '>', $currentSort)->where('status', 'normal')->order('sort', 'asc')->find();
    }

    public static function getPrevLevel($currentSort)
    {
        return self::where('sort', '<', $currentSort)->where('status', 'normal')->order('sort', 'desc')->find();
    }
}
