<?php
namespace app\admin\controller\wallet;

use app\common\controller\Backend;

class Wallet extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\wallet\Wallet;
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

    /**
     * 手动调账
     */
    public function edit($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        if ($this->request->isPost()) {
            $params = $this->request->post("row/a");
            if ($params) {
                \think\Db::startTrans();
                try {
                    // 记录账变逻辑（可选，根据业务需求决定是否在此处记录日志）
                    $row->save($params);
                    \think\Db::commit();
                    $this->success();
                } catch (\Exception $e) {
                    \think\Db::rollback();
                    $this->error($e->getMessage());
                }
            }
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }
}
