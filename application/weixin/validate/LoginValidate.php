<?php

namespace app\weixin\validate;
use think\Validate;

/**
 * 微信登录验证
 */
class LoginValidate extends Validate
{
    protected $rule = [
        'code' => 'require',
        'ticket' => 'require',
    ];

    protected $message = [
        'code.require' => 'code缺少',
        'ticket.require' => 'ticket缺少',
    ];

    /**
     * 验证场景
     */
    protected $scene = [
        'oa' => ['code'],
        'scanLogin' => ['ticket'],
    ];
}