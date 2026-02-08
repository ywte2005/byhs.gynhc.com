<?php
namespace app\admin\controller\wallet;

use app\common\controller\Backend;

/**
 * 银行卡管理
 */
class Bankcard extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,bank_name,card_no,card_holder';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\wallet\Bankcard;
        $this->view->assign("statusList", [
            'normal' => '正常',
            'disabled' => '已禁用'
        ]);
    }

    /**
     * 银行卡列表
     */
    public function index()
    {
        $this->relationSearch = true;
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
     * 银行卡详情
     */
    public function detail($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->with(['user'])->find($id);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 禁用银行卡
     */
    public function disable($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error(__('Parameter %s can not be empty', 'ids'));
            }
            
            $count = $this->model->where('id', 'in', $ids)->update(['status' => 'disabled']);
            $this->success('已禁用 ' . $count . ' 张银行卡');
        }
    }

    /**
     * 启用银行卡
     */
    public function enable($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error(__('Parameter %s can not be empty', 'ids'));
            }
            
            $count = $this->model->where('id', 'in', $ids)->update(['status' => 'normal']);
            $this->success('已启用 ' . $count . ' 张银行卡');
        }
    }

    /**
     * 删除银行卡
     */
    public function del($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error(__('Parameter %s can not be empty', 'ids'));
            }
            
            $pk = $this->model->getPk();
            $list = $this->model->where($pk, 'in', $ids)->select();
            $count = 0;
            foreach ($list as $item) {
                $item->delete();
                $count++;
            }
            
            if ($count) {
                $this->success('删除成功，共删除 ' . $count . ' 张');
            } else {
                $this->error(__('No rows were deleted'));
            }
        }
    }
}
