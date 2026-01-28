<?php

namespace app\admin\controller\weixin;
use app\common\controller\Backend;

/**
 * 微信模板
 * @icon fa fa-circle-o
 */
class Template extends Backend
{

    /**
     * Wechat模型对象
     * @var \app\admin\model\weixin\Template
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\weixin\Template;
        //开启模型验证
        $this->modelValidate = true;
        //内容过滤
        $this->request->filter('trim,strip_tags');
    }

}
