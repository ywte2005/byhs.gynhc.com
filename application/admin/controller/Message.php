<?php
namespace app\admin\controller;

use app\common\controller\Backend;

/**
 * 消息管理
 */
class Message extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,title,content';
    protected $relationSearch = true;
    protected $noNeedRight = ['searchuser', 'index', 'add', 'detail', 'del', 'markread'];

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\Message;
        $this->view->assign("typeList", [
            'system' => '系统消息',
            'task' => '任务消息',
            'wallet' => '钱包消息',
            'promo' => '推广消息'
        ]);
        $this->view->assign("isReadList", [
            0 => '未读',
            1 => '已读'
        ]);
    }

    /**
     * 消息列表
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
     * 添加消息（群发）
     */
    public function add()
    {
        if (false === $this->request->isPost()) {
            return $this->view->fetch();
        }
        $params = $this->request->post('row/a');
        if (empty($params)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        
        $userIds = $this->request->post('user_ids', '');
        $sendAll = $this->request->post('send_all', 0);
        
        \think\Db::startTrans();
        try {
            if ($sendAll == 1) {
                // 群发给所有用户
                $users = \app\common\model\User::where('status', 'normal')->column('id');
            } else {
                // 指定用户
                if (empty($userIds)) {
                    $this->error('请选择接收用户');
                }
                $users = array_filter(explode(',', $userIds));
            }
            
            if (empty($users)) {
                $this->error('请选择接收用户');
            }
            
            $data = [];
            $time = time();
            foreach ($users as $userId) {
                $data[] = [
                    'user_id' => intval($userId),
                    'type' => $params['type'],
                    'title' => $params['title'],
                    'content' => $params['content'],
                    'is_read' => 0,
                    'createtime' => $time
                ];
            }
            
            \think\Db::name('message')->insertAll($data);
            \think\Db::commit();
        } catch (\Exception $e) {
            \think\Db::rollback();
            $this->error($e->getMessage());
        }
        $this->success();
    }

    /**
     * 消息详情
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
     * 删除消息
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
                $this->success('删除成功，共删除 ' . $count . ' 条');
            } else {
                $this->error(__('No rows were deleted'));
            }
        }
    }

    /**
     * 批量标记已读
     */
    public function markread($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            if (!$ids) {
                $this->error(__('Parameter %s can not be empty', 'ids'));
            }
            
            $count = $this->model->where('id', 'in', $ids)->update(['is_read' => 1]);
            $this->success('已标记 ' . $count . ' 条为已读');
        }
    }

    /**
     * 用户搜索（支持手机号模糊搜索）
     * 返回格式：手机号（用户名：ID）
     */
    public function searchuser()
    {
        $q_word = $this->request->request('q_word/a', []);
        $page = $this->request->request('pageNumber', 1);
        $pagesize = $this->request->request('pageSize', 10);
        
        // 支持手机号或用户名模糊搜索
        $keyword = '';
        if (!empty($q_word[0])) {
            $keyword = trim($q_word[0]);
        }
        
        // 构建查询 - ThinkPHP 5.0 语法
        $query = \app\common\model\User::where('status', 'normal');
        if ($keyword) {
            $query->where(function($q) use ($keyword) {
                $q->where('mobile', 'like', '%' . $keyword . '%')
                  ->whereOr('nickname', 'like', '%' . $keyword . '%')
                  ->whereOr('username', 'like', '%' . $keyword . '%');
            });
        }
        $total = $query->count();
        
        // 重新构建查询获取列表
        $query2 = \app\common\model\User::where('status', 'normal');
        if ($keyword) {
            $query2->where(function($q) use ($keyword) {
                $q->where('mobile', 'like', '%' . $keyword . '%')
                  ->whereOr('nickname', 'like', '%' . $keyword . '%')
                  ->whereOr('username', 'like', '%' . $keyword . '%');
            });
        }
        $list = $query2->order('id', 'desc')
            ->page($page, $pagesize)
            ->select();
        
        $result = [];
        foreach ($list as $item) {
            $mobile = $item->mobile ?: '无手机号';
            $nickname = $item->nickname ?: $item->username;
            $result[] = [
                'id' => $item->id,
                'name' => $mobile . '（' . $nickname . '：' . $item->id . '）'
            ];
        }
        
        return json([
            'list' => $result,
            'total' => $total
        ]);
    }
}
