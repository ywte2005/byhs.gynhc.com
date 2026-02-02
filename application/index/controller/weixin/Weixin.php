<?php

namespace app\index\controller\weixin;

use app\common\controller\Frontend;
use app\weixin\logic\LoginLogic;
use app\weixin\validate\LoginValidate;

class Weixin extends Frontend
{
    protected $noNeedLogin = '*';
    protected $noNeedRight = '*';
    protected $layout = '';

    public function scan()
    {
        return $this->view->fetch();
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
            $this->error('not login');
        } else {
            \think\Cookie::set('token', $result['token']);
        }
        $this->success('扫码登录成功');
    }
}
