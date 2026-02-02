<?php
namespace app\admin\controller\wallet;

use app\common\controller\Backend;

class Log extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,biz_type';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\wallet\WalletLog;
        $this->view->assign("walletTypeList", ['balance' => '余额', 'deposit' => '保证金', 'frozen' => '冻结', 'mutual' => '互助余额']);
        $this->view->assign("changeTypeList", ['income' => '收入', 'expense' => '支出', 'freeze' => '冻结', 'unfreeze' => '解冻']);
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
