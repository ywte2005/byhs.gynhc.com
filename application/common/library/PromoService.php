<?php
namespace app\common\library;

use app\common\model\promo\Level;
use app\common\model\promo\Relation;
use app\common\model\promo\Commission;
use app\common\model\promo\Performance;
use app\common\model\promo\Bonus;
use app\common\model\promo\BonusConfig;
use think\Db;

class PromoService
{
    public static function getRelation($userId)
    {
        return Relation::getByUserId($userId);
    }

    public static function createRelation($userId, $parentId = 0)
    {
        $existing = Relation::getByUserId($userId);
        if ($existing) {
            return $existing;
        }
        return Relation::createRelation($userId, $parentId);
    }

    public static function bindParent($userId, $inviteCode)
    {
        $relation = Relation::getByUserId($userId);
        if (!$relation) {
            $parent = Relation::getByInviteCode($inviteCode);
            if (!$parent) {
                throw new \Exception('邀请码无效');
            }
            if ($parent->user_id == $userId) {
                throw new \Exception('不能绑定自己');
            }
            return Relation::createRelation($userId, $parent->user_id);
        }
        
        if ($relation->parent_id > 0) {
            throw new \Exception('已绑定上级');
        }
        
        $parent = Relation::getByInviteCode($inviteCode);
        if (!$parent) {
            throw new \Exception('邀请码无效');
        }
        if ($parent->user_id == $userId) {
            throw new \Exception('不能绑定自己');
        }
        
        $relation->parent_id = $parent->user_id;
        $relation->path = $parent->path ? $parent->path . ',' . $parent->user_id : (string)$parent->user_id;
        $relation->depth = $parent->depth + 1;
        $relation->save();
        
        return $relation;
    }

    public static function getInviteCode($userId)
    {
        $relation = self::getRelation($userId);
        if (!$relation) {
            $relation = self::createRelation($userId);
        }
        return $relation->invite_code;
    }

    public static function getParentChain($userId, $depth = 0)
    {
        $relation = self::getRelation($userId);
        if (!$relation) {
            return [];
        }
        return $relation->getParentChain($depth);
    }

    public static function getDirectChildren($userId)
    {
        return Relation::getDirectChildren($userId);
    }

    public static function getTeamMembers($userId, $page = 1, $limit = 20)
    {
        return Relation::where('path', 'like', '%' . $userId . '%')
            ->order('id', 'desc')
            ->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function getUserLevel($userId)
    {
        $relation = self::getRelation($userId);
        if (!$relation || !$relation->level_id) {
            return null;
        }
        return Level::getById($relation->level_id);
    }

    public static function getLevels()
    {
        return Level::getAll();
    }

    public static function purchaseLevel($userId, $levelId, $payMethod = 'balance')
    {
        Db::startTrans();
        try {
            $level = Level::getById($levelId);
            if (!$level) {
                throw new \Exception('等级不存在');
            }
            
            $relation = self::getRelation($userId);
            if (!$relation) {
                $relation = self::createRelation($userId);
            }
            
            $currentLevel = $relation->level_id ? Level::getById($relation->level_id) : null;
            if ($currentLevel && $currentLevel->sort >= $level->sort) {
                throw new \Exception('不能降级或购买相同等级');
            }
            
            if (bccomp($level->upgrade_price, '0', 2) > 0) {
                WalletService::changeBalance($userId, '-' . $level->upgrade_price, 'level_upgrade', $levelId, '购买等级:' . $level->name);
            }
            
            $relation->level_id = $levelId;
            $relation->save();
            
            if (bccomp($level->upgrade_price, '0', 2) > 0) {
                RewardService::triggerReward('level_upgrade', $userId, $level->upgrade_price, $levelId);
            }
            
            Db::commit();
            return $relation;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function checkAutoUpgrade($userId)
    {
        $relation = self::getRelation($userId);
        if (!$relation) {
            return false;
        }
        
        $currentLevel = $relation->level_id ? Level::getById($relation->level_id) : null;
        $currentSort = $currentLevel ? $currentLevel->sort : -1;
        
        $period = date('Y-m');
        $performance = Performance::getByUserMonth($userId, $period);
        $personalAmount = $performance ? $performance->personal_performance : 0;
        $teamAmount = $performance ? $performance->team_performance : 0;
        $directCount = count(Relation::getDirectChildren($userId));
        
        $levels = Level::where('status', 'normal')
            ->where('sort', '>', $currentSort)
            ->whereIn('upgrade_type', ['performance', 'both'])
            ->order('sort', 'asc')
            ->select();
        
        foreach ($levels as $level) {
            if (bccomp($personalAmount, $level->personal_performance_min, 2) >= 0 &&
                bccomp($teamAmount, $level->team_performance_min, 2) >= 0 &&
                $directCount >= $level->direct_invite_min) {
                $relation->level_id = $level->id;
                $relation->save();
                return $level;
            }
        }
        
        return false;
    }

    public static function getOverview($userId)
    {
        $relation = self::getRelation($userId);
        $wallet = WalletService::getWallet($userId);
        $level = $relation && $relation->level_id ? Level::getById($relation->level_id) : null;
        
        $period = date('Y-m');
        $performance = Performance::getByUserMonth($userId, $period);
        $growth = Performance::calculateGrowth($userId, $period);
        $directCount = $relation ? count(Relation::getDirectChildren($userId)) : 0;
        
        $totalBonus = Commission::getUserTotalCommission($userId, 'settled');
        $monthBonus = Commission::where('user_id', $userId)
            ->where('status', 'settled')
            ->whereTime('createtime', 'month')
            ->sum('amount');
        
        // 获取最近动态（最近5条佣金记录）
        $recentList = Commission::where('user_id', $userId)
            ->order('id', 'desc')
            ->limit(5)
            ->select();
        $recentListData = [];
        foreach ($recentList as $item) {
            $recentListData[] = [
                'id' => $item->id,
                'type' => $item->type,
                'amount' => $item->amount,
                'status' => $item->status,
                'status_text' => $item->status_text ?? '',
                'remark' => $item->remark ?? '',
                'createtime' => $item->createtime
            ];
        }
        
        return [
            'level' => $level ? [
                'id' => $level->id,
                'name' => $level->name,
                'sort' => $level->sort
            ] : null,
            'relation' => [
                'invite_code' => $relation ? $relation->invite_code : '',
                'parent_id' => $relation ? $relation->parent_id : 0,
                'depth' => $relation ? $relation->depth : 0
            ],
            'wallet' => [
                'balance' => $wallet->balance,
                'deposit' => $wallet->deposit,
                'frozen' => $wallet->frozen,
                'total_income' => $wallet->total_income
            ],
            'performance' => [
                'period' => $period,
                'personal_total' => $performance ? $performance->personal_performance : '0.00',
                'team_total' => $performance ? $performance->team_performance : '0.00',
                'growth' => $growth,
                'direct_count' => $directCount
            ],
            'bonus' => [
                'total_bonus' => $totalBonus,
                'month_bonus' => $monthBonus
            ],
            'recent_list' => $recentListData
        ];
    }

    public static function getCommissionList($userId, $page = 1, $limit = 20)
    {
        return Commission::getUserCommissions($userId, $page, $limit);
    }
}
