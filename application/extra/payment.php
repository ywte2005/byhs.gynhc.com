<?php
/**
 * 支付配置
 * 请在后台系统配置中设置，或直接修改此文件
 */
return [
    // 微信支付配置
    'wechat' => [
        'app_id' => '',           // 微信公众号/小程序AppID
        'mch_id' => '',           // 微信商户号
        'api_key' => '',          // 微信支付API密钥
        'cert_path' => '',        // 证书路径（退款等需要）
        'key_path' => '',         // 证书密钥路径
    ],
    
    // 支付宝配置
    'alipay' => [
        'app_id' => '',           // 支付宝应用ID
        'private_key' => '',      // 应用私钥
        'alipay_public_key' => '', // 支付宝公钥
    ],
    
    // 银行卡转账配置（线下转账）
    'bank' => [
        'bank_name' => '中国工商银行',
        'account_name' => '互助刷科技有限公司',
        'account_no' => '6222000000000000000',
    ],
    
    // 回调地址配置
    'notify_url' => [
        'recharge' => '/api/payment/rechargeNotify',
    ],
];
