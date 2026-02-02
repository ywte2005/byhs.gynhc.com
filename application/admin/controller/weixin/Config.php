<?php

namespace app\admin\controller\weixin;
use app\common\controller\Backend;
use addons\weixin\library\ConfigService;

/**
 * 系统配置
 */
class Config extends Backend
{

    public function _initialize()
    {
        parent::_initialize();
        //内容过滤
        $this->request->filter('trim,strip_tags,htmlspecialchars');
    }

    /**
     * 查看
     */
    public function index()
    {
        $domainName = request()->domain();
        $config = ConfigService::get('weixin');
        $config = [
            'name'              => $config['name'] ?? '',
            'original_id'       => $config['original_id'] ?? '',
            'qrcode'            => $config['qrcode'] ?? '',
            'appid'             => $config['appid'] ?? '',
            'appsecret'         => $config['appsecret'] ?? '',
            'url'               => $domainName . '/addons/weixin/index/wechat',
            'token'             => $config['token'] ?? '',
            'encodingaeskey'    => $config['encodingaeskey'] ?? '',
            'encode'            => $config['encode'] ?? 0,
            'business_domain'   => str_replace(request()->scheme() . '://','', $domainName),
            'js_secure_domain'  => str_replace(request()->scheme() . '://','', $domainName),
            'web_auth_domain'   => str_replace(request()->scheme() . '://','', $domainName),
        ];
        $this->view->assign('oaconfig', $config);
        return $this->view->fetch();
    }

    /**
     * 编辑
     */
    public function edit($ids = null)
    {
        if (!$this->request->isPost()) {
            $this->error('请求方式错误');
        }
        $params = $this->request->post('row/a');
        ConfigService::set('weixin','name', $params['name'] ?? '');
        ConfigService::set('weixin','original_id', $params['original_id'] ?? '');
        ConfigService::set('weixin','qrcode', $params['qrcode'] ?? '');
        ConfigService::set('weixin','appid',$params['appid']);
        ConfigService::set('weixin','appsecret',$params['appsecret']);
        ConfigService::set('weixin','token',$params['token'] ?? '');
        ConfigService::set('weixin','encodingaeskey',$params['encodingaeskey'] ?? '');
        ConfigService::set('weixin','encode',$params['encode']);
        $this->success('操作成功');
    }
}
