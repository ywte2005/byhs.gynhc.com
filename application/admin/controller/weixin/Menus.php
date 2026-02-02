<?php

namespace app\admin\controller\weixin;
use app\common\controller\Backend;
use app\admin\validate\weixin\Menus as MenusValidate;
use addons\weixin\library\ConfigService;
use addons\weixin\library\WechatService;

/**
 * 微信菜单控制器
 * Class Menus
 */
class Menus extends Backend
{
    public function _initialize()
    {
        parent::_initialize();
        //内容过滤
        $this->request->filter('trim,strip_tags');
    }

    /**
     * @notes 菜单界面
     * @author Xing <464401240@qq.com>
     */
    public function index()
    {
        if ($this->request->isPost()) {
            try {
                $buttons = (new WechatService())->menuService()->current();
                $buttons = $buttons['selfmenu_info']['button'] ?? [];
                foreach ($buttons as &$val) {
                    if(isset($val['sub_button']['list'])){
                        $val['sub_button'] = $val['sub_button']['list'];
                    }
                }
                ConfigService::set('weixin', 'menus', $buttons);
                ConfigService::set('weixin', 'menusSync', 1);
            } catch (\Exception $e) {
                $this->error($e->getMessage());
            }
            $this->success('拉取成功');
        }
        $buttons   = ConfigService::get('weixin', 'menus', []);
        $menusSync = ConfigService::get('weixin', 'menusSync', 0);
        $this->view->assign('menus', $buttons);
        $this->view->assign('menusSync', $menusSync);
        return $this->view->fetch();
    }

    /**
     * @notes 保存菜单
     * @author Xing <464401240@qq.com>
     */
    public function save()
    {
        $params = $this->request->post('menus');
        $params = (array)json_decode($params, true);
        $validate = new MenusValidate();
        if (!$validate->check(['menus' => $params])){
            $this->error($validate->getError());
        }
        ConfigService::set('weixin', 'menus', $params);
        ConfigService::set('weixin', 'menusSync', 0);
        $this->success('保存成功');
    }

    /**
     * @notes 保存发布
     * @author Xing <464401240@qq.com>
     */
    public function sync()
    {
        $params = $this->request->post('menus');
        $params = (array)json_decode($params, true);
        $validate = new MenusValidate();
        if (!$validate->check(['menus' => $params])){
            $this->error($validate->getError());
        }
        try {
            (new WechatService())->menuService()->create($params);
            ConfigService::set('weixin', 'menus', $params);
            ConfigService::set('weixin', 'menusSync', 1);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
        $this->success('保存与发布菜单成功');
    }
}
