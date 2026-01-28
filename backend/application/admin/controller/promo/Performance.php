<?php

namespace app\admin\controller\promo;

use app\common\controller\Backend;

/**
 * 业绩统计管理
 */
class Performance extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,month';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\promo\Performance;
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }
}
