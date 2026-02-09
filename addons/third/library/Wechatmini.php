<?php

namespace addons\third\library;

use fast\Http;
use think\Config;

/**
 * 微信小程序
 */
class Wechatmini
{
    const GET_SESSION_KEY_URL = "https://api.weixin.qq.com/sns/jscode2session";

    /**
     * 配置信息
     * @var array
     */
    private $config = [];

    public function __construct($options = [])
    {
        if ($config = Config::get('third.wechatmini')) {
            $this->config = array_merge($this->config, $config);
        }
        $this->config = array_merge($this->config, is_array($options) ? $options : []);
    }

    /**
     * 获取用户信息
     * @param array $params
     * @return array
     */
    public function getUserInfo($params = [])
    {
        $code = $params['code'] ?? '';
        
        if (!$code) {
            return [];
        }

        // 通过 code 换取 session_key 和 openid
        $sessionData = $this->getSessionKey($code);
        
        if (!$sessionData || !isset($sessionData['openid'])) {
            return [];
        }

        $openid = $sessionData['openid'];
        $sessionKey = $sessionData['session_key'] ?? '';
        $unionid = $sessionData['unionid'] ?? '';

        // 构造返回数据
        $data = [
            'openid'        => $openid,
            'unionid'       => $unionid,
            'session_key'   => $sessionKey,
            'access_token'  => $sessionKey, // 小程序使用 session_key 作为 access_token
            'expires_in'    => 7200, // 默认 2 小时
            'userinfo'      => [
                'openid'    => $openid,
                'unionid'   => $unionid,
                'nickname'  => '微信用户', // 默认昵称
                'avatar'    => '', // 默认头像为空
            ],
            'apptype'       => 'miniprogram'
        ];

        return $data;
    }

    /**
     * 通过 code 获取 session_key 和 openid
     * @param string $code
     * @return array
     */
    public function getSessionKey($code = '')
    {
        if (!$code) {
            return [];
        }

        $queryarr = [
            "appid"      => $this->config['app_id'],
            "secret"     => $this->config['app_secret'],
            "js_code"    => $code,
            "grant_type" => "authorization_code",
        ];

        $response = Http::get(self::GET_SESSION_KEY_URL, $queryarr);
        $ret = (array)json_decode($response, true);

        // 记录日志用于调试
        \think\Log::record('微信小程序登录响应: ' . json_encode($ret, JSON_UNESCAPED_UNICODE));

        if (isset($ret['errcode']) && $ret['errcode'] != 0) {
            \think\Log::record('微信小程序登录失败: ' . ($ret['errmsg'] ?? '未知错误'));
            return [];
        }

        return $ret ?: [];
    }
}
