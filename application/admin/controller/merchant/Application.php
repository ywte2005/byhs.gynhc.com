<?php
namespace app\admin\controller\merchant;

use app\common\controller\Backend;
use app\common\model\merchant\MerchantApplication;

/**
 * 商户进件管理
 */
class Application extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,application_no,name,contact_name,contact_phone';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new MerchantApplication();
        $this->view->assign('statusList', [
            'pending' => '待审核',
            'approved' => '已通过',
            'rejected' => '已驳回'
        ]);
        $this->view->assign('typeList', [
            'personal' => '个人',
            'individual' => '个体',
            'enterprise' => '企业'
        ]);
    }

    /**
     * 查看
     */
    public function index()
    {
        $this->relationSearch = true;
        $this->request->filter(['strip_tags', 'trim']);
        
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['merchant', 'user'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
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
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        if ($this->request->isAjax()) {
            $this->success('获取成功', $row);
        }
        
        $this->view->assign('row', $row);
        return $this->view->fetch();
    }

    /**
     * 审核通过
     */
    public function approve($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        if ($row->status !== 'pending') {
            $this->error('只能审核待审核状态的进件');
        }
        
        try {
            $adminId = $this->auth->id;
            $row->approve($adminId);
            $this->success('审核通过');
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    /**
     * 审核驳回
     */
    public function reject($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        if ($row->status !== 'pending') {
            $this->error('只能审核待审核状态的进件');
        }
        
        $reason = $this->request->post('reason', '');
        if (empty($reason)) {
            $this->error('请填写驳回原因');
        }
        
        try {
            $adminId = $this->auth->id;
            $row->reject($reason, $adminId);
            $this->success('已驳回');
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }
}
