<?php
namespace app\admin\controller\promo;

use app\common\controller\Backend;

class Bonus extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,month';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\promo\Bonus;
        $this->view->assign("statusList", ['pending' => '待发放', 'settled' => '已发放', 'cancelled' => '已取消']);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user', 'config'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }
}
