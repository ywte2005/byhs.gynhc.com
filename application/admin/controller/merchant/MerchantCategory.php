<?php

namespace app\admin\controller\merchant;

use app\common\controller\Backend;

/**
 * 商户经营类目管理
 */
class MerchantCategory extends Backend
{
    protected $model = null;
    protected $searchFields = 'name,code';
    
    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\MerchantCategory;
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
                
                // 检查类目代码是否重复
                $exists = $this->model->where('code', $params['code'])->find();
                if ($exists) {
                    $this->error('类目代码已存在');
                }
                
                // 设置默认值
                if (!isset($params['parent_id'])) {
                    $params['parent_id'] = 0;
                }
                if (!isset($params['level'])) {
                    $params['level'] = $params['parent_id'] == 0 ? 1 : 2;
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
        
        // 获取父级类目列表
        $parentList = $this->model
            ->where('parent_id', 0)
            ->where('status', 'normal')
            ->order('sort', 'asc')
            ->select();
        
        $this->view->assign('parentList', $parentList);
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
                
                // 检查类目代码是否重复（排除自己）
                $exists = $this->model
                    ->where('code', $params['code'])
                    ->where('id', '<>', $ids)
                    ->find();
                if ($exists) {
                    $this->error('类目代码已存在');
                }
                
                // 更新层级
                if (isset($params['parent_id'])) {
                    $params['level'] = $params['parent_id'] == 0 ? 1 : 2;
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
        
        // 获取父级类目列表（排除自己和自己的子类）
        $parentList = $this->model
            ->where('parent_id', 0)
            ->where('id', '<>', $ids)
            ->where('status', 'normal')
            ->order('sort', 'asc')
            ->select();
        
        $this->view->assign('row', $row);
        $this->view->assign('parentList', $parentList);
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
            // 检查是否有子类目
            $hasChildren = $this->model
                ->where('parent_id', 'in', $ids)
                ->count();
            
            if ($hasChildren > 0) {
                $this->error('请先删除子类目');
            }
            
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
