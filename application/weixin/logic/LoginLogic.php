<?php

namespace app\weixin\logic;
use addons\weixin\library\WechatService;
use app\weixin\service\WechatUserService;
use think\Db;

/**
 * 登录逻辑
 */
class LoginLogic
{

    /**
     * @notes 获取微信请求code的链接
     * @author Xing <464401240@qq.com>
     */
    public static function codeUrl(string $url)
    {
        $result = (new WechatService())->application()->oauth
            ->scopes(['snsapi_userinfo'])->redirect($url)->send();
        if (isset($result['errcode']) && $result['errcode'] != 0) {
            return json_encode($result);
        }
        return true;
    }

    /**
     * @notes 公众号登录
     * @author Xing <464401240@qq.com>
     */
    public static function oaLogin(array $params, \app\common\library\Auth $auth)
    {
        Db::startTrans();
        try {
            //通过code获取微信 openid
            $response = (new WechatService())->application()->oauth
                ->scopes(['snsapi_userinfo'])->user()->getOriginal();
            if (!isset($response['openid']) || empty($response['openid'])) {
                return '获取openID失败';
            }
            $userServer = new WechatUserService($response, 'wechat');
            $userInfo   = $userServer->getResopnseByUserInfo()->authUserLogin($auth)->getUserInfo();
            if (empty($userInfo)) {
                return $auth->getError() ?? '发生未知错误';
            }
            Db::commit();
            return $userInfo;
        } catch (\Exception $e) {
            Db::rollback();
            return $e->getMessage();
        }
    }


    /**
     * @notes 获取公众号登录二维码
     * @author Xing <464401240@qq.com>
     */
    public static function getOaScanCode()
    {
        $response = (new WechatService())->application()->qrcode->temporary('scan_login', 120);
        if (isset($result['errcode']) && $result['errcode'] != 0) {
            return json_encode($result);
        }
        $url  = 'https://mp.weixin.qq.com/cgi-bin/showqrcode';
        $url .= '?ticket=' . $response['ticket'];
        $response['image'] = $url;
        return $response;
    }

    /**
     * @notes 检查是否通过公众号扫码已登录
     * @author Xing <464401240@qq.com>
     */
    public static function oaScanLogin($ticket, \app\common\library\Auth $auth)
    {
        $user_id = \think\Cache::get('scan_login' . $ticket);//得到缓存标记
        if ($user_id) {
            $ret = $auth->direct($user_id);
            \think\Cache::rm('scan_login' . $ticket);
            return $ret ? $auth->getUserinfo() : $auth->getError();
        }
        return false;
    }
}