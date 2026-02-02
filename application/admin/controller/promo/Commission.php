<?php
namespace app\admin\controller\promo;

use app\common\controller\Backend;

class Commission extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,source_user_id,scene,reward_type';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\promo\Commission;
        $this->view->assign("statusList", ['pending' => '待结算', 'settled' => '已结算', 'cancelled' => '已取消']);
        $this->view->assign("sceneList", ['merchant_entry' => '商户入驻', 'order_complete' => '刷单完成', 'level_upgrade' => '等级升级']);
        $this->view->assign("rewardTypeList", ['direct' => '直推奖', 'indirect' => '间推奖', 'level_diff' => '等级差分润', 'peer' => '平级奖', 'team' => '团队奖']);
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user', 'sourceUser'])
                ->where($where)
                ->order($sort, $order)
                ->paginate($limit);
            
            $result = ['total' => $list->total(), 'rows' => $list->items()];
            return json($result);
        }
        return $this->view->fetch();
    }
}
