<?php

namespace app\admin\validate\task;

use think\Validate;

class MutualTask extends Validate
{
    /**
     * 验证规则
     */
    protected $rule = [
        'user_id'      => 'require|number',
        'total_amount' => 'require|number|gt:0',
        'deposit_amount' => 'require|number|egt:0',
        'receipt_type' => 'require|in:entry,collection',
        'entry_qrcode' => 'requireIf:receipt_type,entry',
        'collection_qrcode' => 'requireIf:receipt_type,collection',
    ];

    /**
     * 提示消息
     */
    protected $message = [
        'user_id.require'      => '请选择发起用户',
        'total_amount.require' => '请输入目标总金额',
        'receipt_type.require' => '请选择收款类型',
        'entry_qrcode.requireIf' => '请上传进件二维码',
        'collection_qrcode.requireIf' => '请上传收款码',
    ];

    /**
     * 验证场景
     */
    protected $scene = [
        'add'  => ['user_id', 'total_amount', 'receipt_type', 'entry_qrcode', 'collection_qrcode'],
        'edit' => ['user_id', 'total_amount', 'receipt_type', 'entry_qrcode', 'collection_qrcode'],
    ];
}
