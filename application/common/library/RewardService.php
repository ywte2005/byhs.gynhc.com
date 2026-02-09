<?php
namespace app\common\library;

use app\common\model\promo\Level;
use app\common\model\promo\Relation;
use app\common\model\promo\Commission;
use app\common\model\promo\Performance;
use app\common\model\config\RewardRule;
use app\common\model\config\ProfitRule;
use think\Db;

class RewardService
{
    public static function triggerReward($scene, $userId, $baseAmount, $bizId = 0)
    {
        \think\Log::info("[RewardService] triggerReward called - scene: {$scene}, userId: {$userId}, baseAmount: {$baseAmount}, bizId: {$bizId}");
        
        $rules = RewardRule::getRulesByScene($scene);
        \think\Log::info("[RewardService] Found " . count($rules) . " rules for scene: {$scene}");
        
        $relation = Relation::getByUserId($userId);
        
        if (!$relation) {
            \think\Log::info("[RewardService] No relation found for userId: {$userId}");
            return [];
        }
        
        if (!$relation->parent_id) {
            \think\Log::info("[RewardService] User {$userId} has no parent_id (parent_id: {$relation->parent_id})");
            return [];
        }
        
        \think\Log::info("[RewardService] User {$userId} has parent_id: {$relation->parent_id}");
        
        $results = [];
        foreach ($rules as $rule) {
            try {
                \think\Log::info("[RewardService] Processing rule: {$rule->id} - {$rule->name}, type: {$rule->reward_type}");
                $result = self::processRule($rule, $userId, $relation, $baseAmount, $bizId);
                if ($result) {
                    \think\Log::info("[RewardService] Rule {$rule->id} processed successfully, commission created");
                    $results[] = $result;
                } else {
                    \think\Log::info("[RewardService] Rule {$rule->id} returned null");
                }
            } catch (\Exception $e) {
                \think\Log::error("[RewardService] Rule {$rule->id} exception: " . $e->getMessage());
                continue;
            }
        }
        
        \think\Log::info("[RewardService] triggerReward completed, " . count($results) . " commissions created");
        return $results;
    }

    protected static function processRule($rule, $sourceUserId, $sourceRelation, $baseAmount, $bizId)
    {
        $parentChain = $sourceRelation->getParentChain();
        if (empty($parentChain)) {
            return null;
        }
        
        switch ($rule->reward_type) {
            case 'direct':
                return self::processDirectReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId);
            case 'indirect':
                return self::processIndirectReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId);
            case 'level_diff':
                return self::processLevelDiffReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId);
            case 'peer':
                return self::processPeerReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId);
            case 'team':
                return self::processTeamReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId);
            default:
                return null;
        }
    }

    protected static function processDirectReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId)
    {
        \think\Log::info("[RewardService] processDirectReward - sourceUserId: {$sourceUserId}, parentChain count: " . count($parentChain));
        
        if (empty($parentChain)) {
            \think\Log::info("[RewardService] processDirectReward - parentChain is empty");
            return null;
        }
        
        $directParent = $parentChain[0] ?? null;
        if (!$directParent) {
            \think\Log::info("[RewardService] processDirectReward - directParent is null");
            return null;
        }
        
        \think\Log::info("[RewardService] processDirectReward - directParent user_id: {$directParent->user_id}, level_id: {$directParent->level_id}");
        
        // 检查等级要求
        if (!self::checkLevelRequire($rule, $directParent)) {
            \think\Log::info("[RewardService] processDirectReward - checkLevelRequire failed");
            return null;
        }
        
        // 检查增量门槛
        if (!self::checkGrowthRequire($rule, $directParent->user_id)) {
            \think\Log::info("[RewardService] processDirectReward - checkGrowthRequire failed");
            return null;
        }
        
        $amount = self::calculateAmount($rule, $baseAmount);
        \think\Log::info("[RewardService] processDirectReward - calculated amount: {$amount}");
        
        if (bccomp($amount, '0', 2) <= 0) {
            \think\Log::info("[RewardService] processDirectReward - amount is zero or negative");
            return null;
        }
        
        \think\Log::info("[RewardService] processDirectReward - creating commission for user {$directParent->user_id}, amount: {$amount}");
        
        $commission = Commission::createCommission(
            $directParent->user_id,
            $sourceUserId,
            $rule->scene,
            'direct',
            $baseAmount,
            $amount,
            $rule->id,
            '直推奖励'
        );
        
        \think\Log::info("[RewardService] processDirectReward - commission created, id: {$commission->id}, settling...");
        
        self::settleCommission($commission);
        
        \think\Log::info("[RewardService] processDirectReward - commission settled");
        
        return $commission;
    }

    protected static function processIndirectReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId)
    {
        if (count($parentChain) < 2) {
            return null;
        }
        
        $indirectParent = $parentChain[1] ?? null;
        if (!$indirectParent) {
            return null;
        }
        
        // 检查等级要求
        if (!self::checkLevelRequire($rule, $indirectParent)) {
            return null;
        }
        
        // 检查增量门槛
        if (!self::checkGrowthRequire($rule, $indirectParent->user_id)) {
            return null;
        }
        
        $amount = self::calculateAmount($rule, $baseAmount);
        if (bccomp($amount, '0', 2) <= 0) {
            return null;
        }
        
        $commission = Commission::createCommission(
            $indirectParent->user_id,
            $sourceUserId,
            $rule->scene,
            'indirect',
            $baseAmount,
            $amount,
            $rule->id,
            '间推奖励'
        );
        
        self::settleCommission($commission);
        
        return $commission;
    }

    protected static function processLevelDiffReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId)
    {
        $sourceRelation = Relation::getByUserId($sourceUserId);
        $sourceLevel = $sourceRelation && $sourceRelation->level_id ? Level::getById($sourceRelation->level_id) : null;
        $sourceLevelSort = $sourceLevel ? $sourceLevel->sort : 0;
        
        $month = date('Y-m');
        $results = [];
        foreach ($parentChain as $parent) {
            $parentLevel = $parent->level_id ? Level::getById($parent->level_id) : null;
            $parentLevelSort = $parentLevel ? $parentLevel->sort : 0;
            
            $levelDiff = $parentLevelSort - $sourceLevelSort;
            if ($levelDiff <= 0) {
                continue;
            }
            
            $profitRule = ProfitRule::getByLevelDiff($levelDiff);
            if (!$profitRule) {
                continue;
            }
            
            // 检查增量条件
            if (isset($profitRule->growth_min) && bccomp($profitRule->growth_min, '0', 2) > 0) {
                $growth = Performance::calculateGrowth($parent->user_id, $month);
                if (bccomp($growth, $profitRule->growth_min, 2) < 0) {
                    continue;
                }
            }
            
            $amount = bcmul($baseAmount, $profitRule->profit_rate, 2);
            if (bccomp($amount, '0', 2) <= 0) {
                continue;
            }
            
            $commission = Commission::createCommission(
                $parent->user_id,
                $sourceUserId,
                $rule->scene,
                'level_diff',
                $baseAmount,
                $amount,
                $profitRule->id,
                '等级差分润(差' . $levelDiff . '级)'
            );
            
            self::settleCommission($commission);
            $results[] = $commission;
            
            $sourceLevelSort = $parentLevelSort;
        }
        
        return $results;
    }

    protected static function calculateAmount($rule, $baseAmount)
    {
        if ($rule->amount_type === 'fixed') {
            return $rule->amount_value;
        }
        return bcmul($baseAmount, $rule->amount_value, 2);
    }

    /**
     * 检查等级要求
     */
    protected static function checkLevelRequire($rule, $parent)
    {
        if (empty($rule->level_require)) {
            return true;
        }
        
        $levelRequire = json_decode($rule->level_require, true);
        if (empty($levelRequire)) {
            return true;
        }
        
        return in_array($parent->level_id, $levelRequire);
    }

    /**
     * 检查增量门槛
     */
    protected static function checkGrowthRequire($rule, $userId)
    {
        if (!isset($rule->growth_min) || bccomp($rule->growth_min, '0', 2) <= 0) {
            return true;
        }
        
        $month = date('Y-m');
        $growth = Performance::calculateGrowth($userId, $month);
        return bccomp($growth, $rule->growth_min, 2) >= 0;
    }

    public static function settleCommission($commission)
    {
        if ($commission->status !== 'pending') {
            return false;
        }
        
        Db::startTrans();
        try {
            WalletService::changeBalance(
                $commission->user_id,
                $commission->amount,
                'commission',
                $commission->id,
                $commission->remark
            );
            
            $commission->status = 'settled';
            $commission->settle_time = time();
            $commission->save();
            
            Db::commit();
            return true;
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }
    }

    public static function updatePerformance($userId, $amount)
    {
        $month = date('Y-m');
        Performance::updatePerformance($userId, $month, $amount, 0);
        
        $relation = Relation::getByUserId($userId);
        if ($relation && $relation->path) {
            $parentIds = explode(',', $relation->path);
            foreach ($parentIds as $parentId) {
                Performance::updatePerformance($parentId, $month, 0, $amount);
            }
        }
    }

    /**
     * 平级奖处理 - 同等级查找仅发放第一个平级
     */
    protected static function processPeerReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId)
    {
        $sourceRelation = Relation::getByUserId($sourceUserId);
        $sourceLevel = $sourceRelation && $sourceRelation->level_id ? Level::getById($sourceRelation->level_id) : null;
        if (!$sourceLevel) {
            return null;
        }
        $sourceLevelSort = $sourceLevel->sort;
        
        foreach ($parentChain as $parent) {
            $parentLevel = $parent->level_id ? Level::getById($parent->level_id) : null;
            if (!$parentLevel) {
                continue;
            }
            
            if ($parentLevel->sort == $sourceLevelSort) {
                $amount = self::calculateAmount($rule, $baseAmount);
                if (bccomp($amount, '0', 2) <= 0) {
                    return null;
                }
                
                $commission = Commission::createCommission(
                    $parent->user_id,
                    $sourceUserId,
                    $rule->scene,
                    'peer',
                    $baseAmount,
                    $amount,
                    $rule->id,
                    '平级奖励'
                );
                
                self::settleCommission($commission);
                return $commission;
            }
        }
        
        return null;
    }

    /**
     * 团队奖处理 - 向上遍历满足等级条件的上级
     */
    protected static function processTeamReward($rule, $sourceUserId, $parentChain, $baseAmount, $bizId)
    {
        $targetDepth = $rule->target_depth;
        $results = [];
        
        foreach ($parentChain as $index => $parent) {
            if ($targetDepth > 0 && ($index + 1) != $targetDepth) {
                continue;
            }
            
            $parentLevel = $parent->level_id ? Level::getById($parent->level_id) : null;
            if (!$parentLevel) {
                continue;
            }
            
            if ($rule->level_require) {
                $levelRequire = json_decode($rule->level_require, true);
                if ($levelRequire && !in_array($parent->level_id, $levelRequire)) {
                    continue;
                }
            }
            
            if (bccomp($rule->growth_min, '0', 2) > 0) {
                $month = date('Y-m');
                $growth = Performance::calculateGrowth($parent->user_id, $month);
                if (bccomp($growth, $rule->growth_min, 2) < 0) {
                    continue;
                }
            }
            
            $amount = self::calculateAmount($rule, $baseAmount);
            if (bccomp($amount, '0', 2) <= 0) {
                continue;
            }
            
            $commission = Commission::createCommission(
                $parent->user_id,
                $sourceUserId,
                $rule->scene,
                'team',
                $baseAmount,
                $amount,
                $rule->id,
                '团队奖励'
            );
            
            self::settleCommission($commission);
            $results[] = $commission;
            
            if ($targetDepth > 0) {
                break;
            }
        }
        
        return $results;
    }
}
