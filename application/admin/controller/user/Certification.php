<?php
namespace app\admin\controller\user;

use app\common\controller\Backend;
use app\common\model\Certification as CertificationModel;
use think\Db;

/**
 * 实名认证管理
 */
class Certification extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,name,id_card,contact_phone';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new CertificationModel();
        $this->view->assign('typeList', CertificationModel::$types);
        $this->view->assign('statusList', CertificationModel::$statuses);
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
                $row->visible(['id', 'user_id', 'type', 'name', 'id_card', 'contact_phone', 'status', 'createtime', 'audit_time']);
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
        
        // 处理图片URL
        $row->id_card_front = $row->id_card_front ? cdnurl($row->id_card_front, true) : '';
        $row->id_card_back = $row->id_card_back ? cdnurl($row->id_card_back, true) : '';
        $row->business_license = $row->business_license ? cdnurl($row->business_license, true) : '';
        
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 审核通过
     */
    public function approve($ids = null)
    {
        if (!$this->request->isPost()) {
            $this->error(__('Invalid parameters'));
        }
        
        $ids = $ids ? $ids : $this->request->post('ids');
        if (!$ids) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        
        $list = $this->model->where('id', 'in', $ids)->where('status', 'pending')->select();
        if (!$list) {
            $this->error(__('No Results were found'));
        }
        
        Db::startTrans();
        try {
            $count = 0;
            foreach ($list as $row) {
                $row->approve($this->auth->id);
                $count++;
            }
            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            $this->error($e->getMessage());
        }
        
        $this->success('审核通过成功，共处理' . $count . '条记录');
    }

    /**
     * 审核拒绝
     */
    public function reject($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ? $ids : $this->request->post('ids');
            $reason = $this->request->post('reason', '');
            
            if (!$ids) {
                $this->error(__('Parameter %s can not be empty', 'ids'));
            }
            if (!$reason) {
                $this->error('请输入拒绝原因');
            }
            
            $list = $this->model->where('id', 'in', $ids)->where('status', 'pending')->select();
            if (!$list) {
                $this->error(__('No Results were found'));
            }
            
            Db::startTrans();
            try {
                $count = 0;
                foreach ($list as $row) {
                    $row->reject($reason, $this->auth->id);
                    $count++;
                }
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                $this->error($e->getMessage());
            }
            
            $this->success('审核拒绝成功，共处理' . $count . '条记录');
        }
        
        $this->view->assign('ids', $ids);
        return $this->view->fetch();
    }
}
