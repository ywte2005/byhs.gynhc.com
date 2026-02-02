<?php

namespace app\admin\validate\weixin;
use think\Validate;

class Template extends Validate
{
    /**
     * 验证规则
     */
    protected $rule = [
        'tempkey' => 'require|max:50|unique:weixin_template',
        'name' => 'require|max:100|unique:weixin_template',
        'tempid' => 'require|max:100',
        'content' => 'require',
        'open_type' => 'require|in:0,1|checkValue',
    ];

    /**
     * 提示消息
     */
    protected $message = [
        'tempkey.require' => '请填写场景值',
        'tempkey.max' => '场景值最多50字符',
        'tempkey.unique' => '场景值已经存在了',
        'name.require' => '请填写模版名称',
        'name.max' => '模版名称长度不符',
        'name.unique' => '模版名称已经存在',
        'tempid.require' => '请填写模版id',
        'tempid.max' => '模版id长度不符',
        'content.content' => '请填写模版内容',
        'open_type.require' => '请选择跳转类型',
        'open_type.in' => '跳转类型参数错误',
    ];

    /**
     * 验证场景
     */
    protected $scene = [
        'add'  => ['tempkey', 'name', 'tempid', 'content', 'open_type'],
        'edit' => ['tempkey', 'name', 'tempid', 'content', 'open_type'],
    ];

    public function __construct(array $rules = [], $message = [], $field = [])
    {
        $this->field = [
            'tempkey' => __('Tempkey'),
            'name' => __('Name'),
            'tempid' => __('Tempid'),
            'content' => __('Content'),
        ];
        parent::__construct($rules, $message, $field);
    }

    public function checkValue($open_type, $rule, $data)
    {
        if ($open_type == 0) {
            if (!isset($data['open_url']) || empty($data['open_url'])) {
                return '请输入跳转网址';
            }
            if (!$this->checkRule($data['open_url'],'url')) {
                return '跳转网址输入有误';
            }
        } else {
            if (empty($data['appid'])) {
                return '请输入appid';
            }
            if (empty($data['pagepath'])) {
                return '请输入小程序路径';
            }
        }
        return true;
    }
}
