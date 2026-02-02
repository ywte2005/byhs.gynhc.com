<?php

namespace addons\weixin\library;
use EasyWeChat\Kernel\Contracts\EventHandlerInterface;
use app\weixin\service\WechatUserService;

/**
 * 公众号事件处理类
 * Class WechatEventLogic
 */
class WechatEvent implements EventHandlerInterface
{

    /**
     * @notes 接收到的消息
     * @author Xing <464401240@qq.com>
     */
    private $message = [];

    /**
     * @notes 事件处理入口（任务分发）
     * @author Xing <464401240@qq.com>
     */
    public function handle($message = null)
    {
        $this->message = $message;
        if (empty($this->message)) {
            return false;
        }
        if ($this->message['MsgType'] == 'event') {
            $action = strtolower($this->message['Event']);
        } else {
            $action = strtolower($this->message['MsgType']);
        }
        if (method_exists($this, $action)) {
            return $this->$action();
        }
        return false;
    }

    /**
     * @notes 关注事件
     * @author Xing <464401240@qq.com>
     */
    private function subscribe()
    {
        //您自己的其他业务逻辑在这里写，但最后一定要return消息处理方法，否则消息无法得到回复
        return (new MessageReply)->handle('subscribe');
    }

    /**
     * @notes 取消关注
     * @author Xing <464401240@qq.com>
     */
    private function unsubscribe()
    {
        return false;
    }

    /**
     * @notes 已关注扫码
     * @author Xing <464401240@qq.com>
     */
    private function scan()
    {
        $event_key = str_replace('qrscene_', '', $this->message['EventKey']);
        //扫码登录
        if ($event_key == 'scan_login') {
            $userServer = new WechatUserService([
                'openid' => $this->message['FromUserName'],
                'ticket' => $this->message['Ticket']
            ], 'wechat');
            $auth = new \app\common\library\Auth();
            $userInfo = $userServer->getResopnseByUserInfo()->authUserLogin($auth)->getUserInfo();
            if (empty($userInfo)) {
                $replyContent = $auth->getError() ?? '发生未知错误';
            } else {
                $replyContent = '恭喜 [' . $userInfo['nickname'] . '] 登录成功！';
            }
            return (new MessageReply)->text($replyContent);
        }

        return (new MessageReply)->handle('subscribe');
    }

    /**
     * @notes 用户点击菜单
     * @author Xing <464401240@qq.com>
     */
    private function click()
    {
        //您自己的其他业务逻辑在这里写，但最后一定要return消息处理方法，否则消息无法得到回复
        return (new MessageReply)->handle($this->message['EventKey']);
    }

    /**
     * @notes 收到文本消息
     * @author Xing <464401240@qq.com>
     */
    private function text()
    {
        //您自己的其他业务逻辑在这里写，但最后一定要return消息处理方法，否则消息无法得到回复
        return (new MessageReply)->handle($this->message['Content']);
    }

    /**
     * @notes 收到图片消息
     * @author Xing <464401240@qq.com>
     */
    private function image()
    {
        //您自己的其他业务逻辑在这里写，但最后一定要return消息处理方法，否则消息无法得到回复
        return (new MessageReply)->handle('default');
    }

    /**
     * @notes 收到语音消息
     * @author Xing <464401240@qq.com>
     */
    private function voice()
    {
        //您自己的其他业务逻辑在这里写，但最后一定要return消息处理方法，否则消息无法得到回复
        return (new MessageReply)->handle('default');
    }

    /**
     * @notes 收到视频消息
     * @author Xing <464401240@qq.com>
     */
    private function video()
    {
        //您自己的其他业务逻辑在这里写，但最后一定要return消息处理方法，否则消息无法得到回复
        return (new MessageReply)->handle('default');
    }

}