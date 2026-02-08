<?php

namespace app\admin\controller\config;

use app\common\controller\Backend;

/**
 * 银行配置管理
 */
class BankConfig extends Backend
{
    protected $model = null;
    protected $searchFields = 'bank_name,bank_code';
    
    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\BankConfig;
    }

    /**
     * 查看
     */
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

    /**
     * 添加
     */
    public function add()
    {
        if ($this->request->isPost()) {
            $params = $this->request->post('row/a');
            if ($params) {
                $params = $this->preExcludeFields($params);
                
                // 检查银行代码是否重复
                $exists = $this->model->where('bank_code', $params['bank_code'])->find();
                if ($exists) {
                    $this->error('银行代码已存在');
                }
                
                $result = $this->model->save($params);
                if ($result !== false) {
                    $this->success();
                } else {
                    $this->error(__('No rows were inserted'));
                }
            }
            $this->error(__('Parameter %s can not be empty', ''));
        }
        return $this->view->fetch();
    }

    /**
     * 编辑
     */
    public function edit($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        if ($this->request->isPost()) {
            $params = $this->request->post('row/a');
            if ($params) {
                $params = $this->preExcludeFields($params);
                
                // 检查银行代码是否重复（排除自己）
                $exists = $this->model
                    ->where('bank_code', $params['bank_code'])
                    ->where('id', '<>', $ids)
                    ->find();
                if ($exists) {
                    $this->error('银行代码已存在');
                }
                
                $result = $row->save($params);
                if ($result !== false) {
                    $this->success();
                } else {
                    $this->error(__('No rows were updated'));
                }
            }
            $this->error(__('Parameter %s can not be empty', ''));
        }
        
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 删除
     */
    public function del($ids = '')
    {
        if (!$this->request->isPost()) {
            $this->error(__('Invalid parameters'));
        }
        $ids = $ids ? $ids : $this->request->post('ids');
        if ($ids) {
            $list = $this->model->where('id', 'in', $ids)->select();
            if ($list) {
                $deleteCount = 0;
                foreach ($list as $item) {
                    $deleteCount += $item->delete();
                }
                if ($deleteCount) {
                    $this->success();
                } else {
                    $this->error(__('No rows were deleted'));
                }
            }
        }
        $this->error(__('Parameter %s can not be empty', 'ids'));
    }
}
