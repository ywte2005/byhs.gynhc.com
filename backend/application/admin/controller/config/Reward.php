<?php
namespace app\admin\controller\config;

use app\common\controller\Backend;

class Reward extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,name';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\config\RewardRule;
        $this->view->assign("statusList", ['normal' => '正常', 'hidden' => '隐藏']);
        $this->view->assign("sceneList", ['merchant_entry' => '商户入驻', 'order_complete' => '刷单完成', 'level_upgrade' => '等级升级']);
        $this->view->assign("rewardTypeList", ['direct' => '直推奖', 'indirect' => '间推奖', 'level_diff' => '等级差分润', 'peer' => '平级奖', 'team' => '团队奖']);
        $this->view->assign("amountTypeList", ['fixed' => '固定金额', 'percent' => '比例']);
    }

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
}
