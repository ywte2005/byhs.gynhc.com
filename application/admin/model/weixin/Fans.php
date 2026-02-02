<?php

namespace app\admin\model\weixin;
use think\Model;

class Fans extends Model
{
    // 表名
    protected $name = 'weixin_fans';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = 'int';

    // 定义时间戳字段名
    protected $createTime = false;
    protected $updateTime = false;
    protected $deleteTime = false;

    // 追加属性
    protected $append = [

    ];
}
