<?php

namespace app\admin\controller\user;

use app\common\controller\Backend;
use app\common\library\Auth;

/**
 * 会员管理
 *
 * @icon fa fa-user
 */
class User extends Backend
{

    protected $relationSearch = true;
    protected $searchFields = 'id,username,nickname';

    /**
     * @var \app\admin\model\User
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\User;
    }

    /**
     * 查看
     */
    public function index()
    {
        //设置过滤方法
        $this->request->filter(['strip_tags', 'trim']);
        if ($this->request->isAjax()) {
            //如果发送的来源是Selectpage，则转发到Selectpage
            if ($this->request->request('keyField')) {
                return $this->selectpage();
            }
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            $list = $this->model
                ->with('group')
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            foreach ($list as $k => $v) {
                $v->avatar = $v->avatar ? cdnurl($v->avatar, true) : letter_avatar($v->nickname);
                $v->hidden(['password', 'salt']);
            }
            $result = array("total" => $list->total(), "rows" => $list->items());

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
            $this->token();
        }
        
        // 获取用户组列表
        $groupList = \app\common\model\UserGroup::where('status', 'normal')
            ->order('id', 'asc')
            ->select();
        
        // 构建用户组下拉选择框
        $groupdata = [];
        foreach ($groupList as $group) {
            $groupdata[$group->id] = $group->name;
        }
        
        // 使用 build_select 函数生成下拉框
        $groupSelect = build_select('row[group_id]', $groupdata, '', ['class' => 'form-control selectpicker']);
        
        $this->view->assign('groupList', $groupSelect);
        
        return parent::add();
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
            $this->token();
        }
        
        // 获取用户组列表
        $groupList = \app\common\model\UserGroup::where('status', 'normal')
            ->order('id', 'asc')
            ->select();
        
        // 构建用户组下拉选择框
        $groupdata = [];
        foreach ($groupList as $group) {
            $groupdata[$group->id] = $group->name;
        }
        
        // 使用 build_select 函数生成下拉框
        $groupSelect = build_select('row[group_id]', $groupdata, $row->group_id, ['class' => 'form-control selectpicker']);
        
        $this->view->assign('groupList', $groupSelect);
        
        return parent::edit($ids);
    }

    /**
     * 会员详情
     */
    public function detail($ids = null)
    {
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->get($id);
        if (!$row) {
            $this->error(__('No Results were found'));
        }

        // 最近资金记录
        $moneyLogs = \app\common\model\MoneyLog::where('user_id', $id)
            ->order('id', 'desc')
            ->limit(10)
            ->select();

        // 活跃记录 (Token)
        $loginLogs = \think\Db::name('user_token')
            ->where('user_id', $id)
            ->order('createtime', 'desc')
            ->limit(5)
            ->select();

        // 获取推荐关系
        $relation = \app\common\model\promo\Relation::where('user_id', $id)->find();
        $upline = null;
        if ($relation && $relation->parent_id > 0) {
            $upline = \app\common\model\User::get($relation->parent_id);
        }

        // 基础统计
        $stats = [
            'merchant' => [
                'total_tasks' => \app\common\model\task\MutualTask::where('user_id', $id)->count(),
                'total_amount' => \app\common\model\task\MutualTask::where('user_id', $id)->sum('total_amount'),
            ],
            'worker' => [
                'total_completed' => \app\common\model\task\SubTask::where('to_user_id', $id)->where('status', 'completed')->count(),
                'total_commission' => \app\common\model\task\SubTask::where('to_user_id', $id)->where('status', 'completed')->sum('commission'),
            ],
            'promo' => [
                'invite_count' => \app\common\model\promo\Relation::where('parent_id', $id)->count(),
                'upline' => $upline ? ['pid' => $upline->id, 'parent' => ['nickname' => $upline->nickname]] : null,
            ]
        ];

        // 获取该用户的商户信息 ID
        $merchant = \app\common\model\merchant\Merchant::where('user_id', $id)->find();
        $merchant_id = $merchant ? $merchant->id : 0;

        $this->view->assign('row', $row);
        $this->view->assign('stats', $stats);
        $this->view->assign('moneyLogs', $moneyLogs);
        $this->view->assign('loginLogs', $loginLogs);
        $this->view->assign('merchant_id', $merchant_id);
        return $this->view->fetch();
    }

    /**
     * 禁用会员
     */
    public function disable($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row) {
                $this->error(__('No Results were found'));
            }
            $row->status = 'hidden';
            $row->save();
            $this->success(__('Operation completed'));
        }
    }

    /**
     * 启用会员
     */
    public function enable($ids = null)
    {
        if ($this->request->isPost()) {
            $ids = $ids ?: $this->request->post('ids');
            $row = $this->model->get($ids);
            if (!$row) {
                $this->error(__('No Results were found'));
            }
            $row->status = 'normal';
            $row->save();
            $this->success(__('Operation completed'));
        }
    }

    /**
     * 删除
     */
    public function del($ids = "")
    {
        if (!$this->request->isPost()) {
            $this->error(__("Invalid parameters"));
        }
        $ids = $ids ? $ids : $this->request->post("ids");
        if ($ids) {
            $idlist = explode(',', $ids);
            $count = 0;
            foreach ($idlist as $id) {
                $row = $this->model->get($id);
                if ($row) {
                    Auth::instance()->delete($row['id']);
                    $count++;
                }
            }
            if ($count) {
                $this->success();
            }
        }
        $this->error(__('No Results were found'));
    }

}
