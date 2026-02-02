<?php

namespace app\admin\controller\merchant;

use app\common\controller\Backend;

/**
 * 商户审核记录
 */
class Audit extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,merchant_id';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\merchant\MerchantAudit;
        $this->view->assign("actionList", [
            'approve' => '通过',
            'reject'  => '拒绝'
        ]);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['merchant', 'admin'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }
}
