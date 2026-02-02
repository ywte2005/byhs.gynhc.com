<?php

namespace addons\weixin\controller;
use think\addons\Controller;
use addons\weixin\library\WechatService;

class Index extends Controller
{
    public function index()
    {
        $this->error("当前插件暂无前台页面");
    }

    /**
     * @notes 微信公众号回调-服务器接口
     * @author Xing <464401240@qq.com>
     */
    public function wechat()
    {
        $result = (new WechatService)->observe();
        return response($result->getContent())->header([
            'Content-Type' => 'text/plain;charset=utf-8'
        ]);
    }

    /**
     * @notes 更新素材有效期
     * @author Xing <464401240@qq.com>
     * 请设置定时任务建议设置30分钟执行一次，也可根据自身情况调整
     */
    public function updateMaterial()
    {
        $time = time() - 60 * 60 * 24 * 3 + 3600;
        $list = \app\admin\model\weixin\Reply::where('updatetime', '<', $time)->select();
        foreach ($list as $row) {
            $row->save();
        }
        echo 'ok';
    }
}