<?php
namespace app\admin\controller\task;

use app\common\controller\Backend;
use app\common\model\TaskType;

/**
 * 任务类型管理
 */
class Tasktype extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,name,code';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new TaskType();
        $this->view->assign('statusList', [
            'normal' => '正常',
            'hidden' => '隐藏'
        ]);
    }

    /**
     * 查看
     */
    public function index()
    {
        $this->request->filter(['strip_tags', 'trim']);
        
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
            if (empty($params)) {
                $this->error(__('Parameter %s can not be empty', ''));
            }
            
            // 检查编码是否重复
            if (TaskType::getByCode($params['code'])) {
                $this->error('类型编码已存在');
            }
            
            $result = $this->model->save($params);
            if ($result) {
                $this->success();
            } else {
                $this->error(__('No rows were inserted'));
            }
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
            if (empty($params)) {
                $this->error(__('Parameter %s can not be empty', ''));
            }
            
            // 检查编码是否重复（排除自己）
            $existing = TaskType::getByCode($params['code']);
            if ($existing && $existing->id != $ids) {
                $this->error('类型编码已存在');
            }
            
            $result = $row->save($params);
            if ($result !== false) {
                $this->success();
            } else {
                $this->error(__('No rows were updated'));
            }
        }
        
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 删除
     */
    public function del($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error('参数缺失');
            }
            
            $result = $this->model->destroy($ids);
            if ($result) {
                $this->success();
            } else {
                $this->error(__('No rows were deleted'));
            }
        }
    }
}
