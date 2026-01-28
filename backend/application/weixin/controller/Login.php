<?php

namespace app\weixin\controller;
use app\common\controller\Api;
use app\weixin\{
    validate\LoginValidate,
    logic\LoginLogic
};

/**
 * 登录注册
 */
class Login extends Api
{

    // 无需登录的接口,*表示全部
    protected $noNeedLogin = '*';

    // 无需鉴权的接口,*表示全部
    protected $noNeedRight = '*';

    
    /**
     * @notes 获取微信请求code的链接
     * @author Xing <464401240@qq.com>
     */
    public function codeUrl()
    {
        $url = $this->request->get('url', '');
        $result = ['url' => LoginLogic::codeUrl($url)];
        $this->success('获取成功', $result);
    }


    /**
     * @notes 公众号登录
     * @author Xing <464401240@qq.com>
     */
    public function oaLogin()
    {
        $params = $this->request->get();
        $validate = new LoginValidate();
        if (!$validate->scene('oa')->check($params)){
            $this->error($validate->getError());
        }
        $result = LoginLogic::oaLogin($params, $this->auth);
        if (true !== $result && !is_array($result)) {
            $this->error($result);
        }
        $this->success('授权登录成功', $result);
    }


    /**
     * @notes 获取公众号扫码地址
     * @author Xing <464401240@qq.com>
     */
    public function getOaScanCode()
    {
        $result = LoginLogic::getOaScanCode();
        if (true !== $result && !is_array($result)) {
            $this->error($result);
        }
        $this->success('获取成功', $result);
    }


    /**
     * @notes 公众号扫码登录
     * @author Xing <464401240@qq.com>
     */
    public function oaScanLogin()
    {
        $params = $this->request->get();
        $validate = new LoginValidate();
        if (!$validate->scene('scanLogin')->check($params)){
            $this->error($validate->getError());
        }
        $ticket = $this->request->get('ticket');
        $result = LoginLogic::oaScanLogin($ticket, $this->auth);
        if (true !== $result && !is_array($result)) {
            $this->error($result);
        }
        $this->success('扫码登录成功', $result);
    }


    /**
     * @notes 微信JSSDK授权接口
     * @author Xing <464401240@qq.com>
     */
    public function jsConfig()
    {
        $url = $this->request->get('url/s');
        $result = (new \addons\weixin\library\WechatService)->jsSdk($url);
        if (isset($result['errcode']) && $result['errcode'] != 0) {
            $this->error(json_encode($result));
        }
        $this->success('ok', $result);
    }
}
