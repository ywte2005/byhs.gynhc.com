<?php
namespace app\admin\controller\user;

use app\common\controller\Backend;
use app\common\model\Feedback as FeedbackModel;

/**
 * 工单反馈管理
 */
class Feedback extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,title,content,contact';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new FeedbackModel();
        $this->view->assign('typeList', FeedbackModel::$types);
        $this->view->assign('statusList', FeedbackModel::$statuses);
    }

    /**
     * 查看
     */
    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            foreach ($list as $row) {
                $row->visible(['id', 'user_id', 'type', 'title', 'content', 'status', 'createtime', 'reply_time']);
                $row->visible(['user']);
                $row->getRelation('user')->visible(['id', 'username', 'nickname', 'mobile']);
            }
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 详情
     */
    public function detail($ids = null)
    {
        $row = $this->model->with(['user'])->find($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        // 处理图片
        $row->images_arr = $row->images ? array_map(function($img) {
            return cdnurl($img, true);
        }, explode(',', $row->images)) : [];
        
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 回复
     */
    public function reply($ids = null)
    {
        $row = $this->model->find($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        if ($this->request->isPost()) {
            $reply = $this->request->post('reply', '');
            
            if (!$reply) {
                $this->error('请输入回复内容');
            }
            
            $row->reply($reply, $this->auth->id);
            $this->success('回复成功');
        }
        
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 关闭
     */
    public function close($ids = null)
    {
        if (!$this->request->isPost()) {
            $this->error(__('Invalid parameters'));
        }
        
        $ids = $ids ? $ids : $this->request->post('ids');
        if (!$ids) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        
        $list = $this->model->where('id', 'in', $ids)->where('status', 'in', ['pending', 'processing', 'replied'])->select();
        if (!$list) {
            $this->error(__('No Results were found'));
        }
        
        $count = 0;
        foreach ($list as $row) {
            $row->close($this->auth->id);
            $count++;
        }
        
        $this->success('关闭成功，共处理' . $count . '条记录');
    }

    /**
     * 设置处理中
     */
    public function processing($ids = null)
    {
        if (!$this->request->isPost()) {
            $this->error(__('Invalid parameters'));
        }
        
        $ids = $ids ? $ids : $this->request->post('ids');
        if (!$ids) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        
        $count = $this->model->where('id', 'in', $ids)->where('status', 'pending')->update([
            'status' => 'processing',
            'admin_id' => $this->auth->id
        ]);
        
        $this->success('操作成功，共处理' . $count . '条记录');
    }
}
