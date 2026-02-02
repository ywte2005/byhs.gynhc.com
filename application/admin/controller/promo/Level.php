<?php
namespace app\admin\controller\promo;

use app\common\controller\Backend;

class Level extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,name';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\promo\Level;
        $this->view->assign("statusList", ['normal' => '正常', 'hidden' => '隐藏']);
        $this->view->assign("upgradeTypeList", ['purchase' => '购买升级', 'performance' => '业绩升级', 'both' => '两者皆可']);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }
}
