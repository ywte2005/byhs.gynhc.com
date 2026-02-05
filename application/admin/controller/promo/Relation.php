<?php
namespace app\admin\controller\promo;

use app\common\controller\Backend;

class Relation extends Backend
{
    protected $model = null;
    protected $searchFields = 'id,user_id,invite_code,user.mobile';
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\common\model\promo\Relation;
    }

    public function index()
    {
        if ($this->request->isAjax()) {
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            
            $list = $this->model
                ->with(['user', 'level'])
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
        $id = $ids ?: $this->request->param('id');
        $row = $this->model->with(['user', 'level', 'parent' => ['user']])->where('id', $id)->find();
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        
        // 团队统计
        $team_count = $this->model->where('path', 'like', "%{$row->user_id}%")->count();
        $direct_count = $this->model->where('parent_id', $row->user_id)->count();
        $indirect_count = $team_count - $direct_count;

        // 增长统计
        $today_start = strtotime(date('Y-m-d 00:00:00'));
        $week_start = strtotime(date('Y-m-d 00:00:00', strtotime('-7 days')));
        $month_start = strtotime(date('Y-m-01 00:00:00'));

        $growth = [
            'today' => $this->model->where('path', 'like', "%{$row->user_id}%")->where('createtime', '>=', $today_start)->count(),
            'week'  => $this->model->where('path', 'like', "%{$row->user_id}%")->where('createtime', '>=', $week_start)->count(),
            'month' => $this->model->where('path', 'like', "%{$row->user_id}%")->where('createtime', '>=', $month_start)->count(),
        ];
        
        // 团队等级分布
        $level_distribution = $this->model
            ->alias('r')
            ->join('promo_level l', 'r.level_id = l.id', 'LEFT')
            ->where('r.path', 'like', "%{$row->user_id}%")
            ->field('l.name as level_name, count(*) as count')
            ->group('r.level_id')
            ->select();
        $level_distribution = $level_distribution ? collection($level_distribution)->toArray() : [];

        // 业绩统计 (当月)
        $month = date('Y-m');
        $performance = \app\common\model\promo\Performance::getByUserMonth($row->user_id, $month);
        
        // 业绩历史 (最近6个月)
        $performance_history = \app\common\model\promo\Performance::where('user_id', $row->user_id)
            ->order('period', 'desc')
            ->limit(6)
            ->select();
        $performance_history = $performance_history ? collection($performance_history)->toArray() : [];

        // 计算增长率 (对比上月)
        $prev_period = date('Y-m', strtotime('-1 month'));
        $prev_performance = \app\common\model\promo\Performance::getByUserMonth($row->user_id, $prev_period);
        $growth_rate = '0.00';
        if ($prev_performance && isset($prev_performance->team_performance) && $prev_performance->team_performance > 0) {
            $curr_amount = $performance ? bcadd($performance->personal_performance ?? 0, $performance->team_performance ?? 0, 2) : '0.00';
            $prev_amount = bcadd($prev_performance->personal_performance ?? 0, $prev_performance->team_performance ?? 0, 2);
            if ($prev_amount > 0) {
                $growth_rate = bcmul(bcdiv(bcsub($curr_amount, $prev_amount, 2), $prev_amount, 4), 100, 2);
            }
        }

        // 活跃统计 (本月有业绩的下级)
        $active_count = \app\common\model\promo\Performance::alias('p')
            ->join('promo_relation r', 'p.user_id = r.user_id')
            ->where('r.path', 'like', "%{$row->user_id}%")
            ->where('p.period', $period)
            ->where('(p.personal_performance + p.team_performance) > 0')
            ->count();

        // 团队达人 (本月团队内个人业绩前5名)
        $team_top_performers = \app\common\model\promo\Performance::alias('p')
            ->join('promo_relation r', 'p.user_id = r.user_id')
            ->join('user u', 'p.user_id = u.id')
            ->where('r.path', 'like', "%{$row->user_id}%")
            ->where('p.period', $period)
            ->field('u.nickname, p.personal_performance, p.team_performance, p.user_id')
            ->order('p.personal_performance', 'desc')
            ->limit(5)
            ->select();
        $team_top_performers = $team_top_performers ? collection($team_top_performers)->toArray() : [];

        // 团队列表 (直属下级)
        $direct_list = $this->model->with(['user', 'level'])
            ->where('parent_id', $row->user_id)
            ->order('id', 'desc')
            ->limit(10)
            ->select();
        $direct_list = $direct_list ? collection($direct_list)->toArray() : [];

        $this->view->assign([
            'row' => $row,
            'team_count' => $team_count,
            'direct_count' => $direct_count,
            'indirect_count' => $indirect_count,
            'growth' => $growth,
            'level_distribution' => $level_distribution,
            'performance' => $performance,
            'performance_history' => $performance_history,
            'team_top_performers' => $team_top_performers,
            'direct_list' => $direct_list,
            'growth_rate' => $growth_rate,
            'active_count' => $active_count
        ]);

        return $this->view->fetch();
    }
}
