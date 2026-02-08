<?php
namespace app\common\model;

use think\Model;

class TaskType extends Model
{
    protected $name = 'task_type';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text'];

    public function getStatusTextAttr($value, $data)
    {
        $list = ['normal' => '正常', 'hidden' => '隐藏'];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    /**
     * 获取所有可用任务类型
     */
    public static function getAvailableTypes()
    {
        return self::where('status', 'normal')
            ->order('sort', 'asc')
            ->select();
    }

    /**
     * 获取所有任务类型（包括隐藏的）
     */
    public static function getAllTypes()
    {
        return self::order('sort', 'asc')->select();
    }

    /**
     * 根据编码获取类型
     */
    public static function getByCode($code)
    {
        return self::where('code', $code)->find();
    }
}
