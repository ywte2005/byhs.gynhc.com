<?php
namespace app\admin\controller\config;

use app\common\controller\Backend;

class Bonusconfig extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,name';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\promo\BonusConfig;
        $this->view->assign("statusList", ['normal' => '正常', 'hidden' => '隐藏']);
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
