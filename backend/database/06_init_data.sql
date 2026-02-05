-- =============================================
-- 初始化数据
-- =============================================

-- 1. 初始化等级配置
INSERT INTO `fa_promo_level` (`id`, `name`, `sort`, `upgrade_type`, `upgrade_price`, `personal_performance_min`, `team_performance_min`, `direct_invite_min`, `commission_rate`, `status`, `createtime`, `updatetime`) VALUES
(1, '普通会员', 0, 'purchase', 0.00, 0.00, 0.00, 0, 0.0000, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '初级代理', 1, 'both', 1000.00, 10000.00, 50000.00, 3, 0.0100, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '中级代理', 2, 'both', 5000.00, 50000.00, 200000.00, 5, 0.0150, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(4, '高级代理', 3, 'both', 10000.00, 100000.00, 500000.00, 10, 0.0200, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(5, '市级代理', 4, 'both', 50000.00, 500000.00, 2000000.00, 20, 0.0250, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '省级代理', 5, 'both', 100000.00, 1000000.00, 5000000.00, 50, 0.0300, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 2. 初始化分红配置
INSERT INTO `fa_promo_bonus_config` (`id`, `name`, `team_performance_min`, `personal_performance_min`, `qualified_count_min`, `growth_min`, `pool_rate`, `sort`, `status`, `createtime`) VALUES
(1, '基础分红', 100000.00, 10000.00, 5, 0.00, 0.0100, 1, 'normal', UNIX_TIMESTAMP()),
(2, '进阶分红', 500000.00, 50000.00, 10, 10000.00, 0.0150, 2, 'normal', UNIX_TIMESTAMP()),
(3, '高级分红', 1000000.00, 100000.00, 20, 50000.00, 0.0200, 3, 'normal', UNIX_TIMESTAMP()),
(4, '顶级分红', 5000000.00, 500000.00, 50, 100000.00, 0.0300, 4, 'normal', UNIX_TIMESTAMP());

-- 3. 初始化奖励规则 - 商户入驻场景
INSERT INTO `fa_reward_rule` (`id`, `name`, `scene`, `reward_type`, `target_depth`, `level_require`, `amount_type`, `amount_value`, `growth_min`, `sort`, `status`, `createtime`, `updatetime`) VALUES
(1, '入驻直推奖', 'merchant_entry', 'direct', 1, '[]', 'percent', 0.1000, 0.00, 1, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '入驻间推奖', 'merchant_entry', 'indirect', 2, '[2,3,4,5,6]', 'percent', 0.0500, 0.00, 2, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 4. 初始化奖励规则 - 订单完成场景
INSERT INTO `fa_reward_rule` (`id`, `name`, `scene`, `reward_type`, `target_depth`, `level_require`, `amount_type`, `amount_value`, `growth_min`, `sort`, `status`, `createtime`, `updatetime`) VALUES
(3, '订单直推奖', 'order_complete', 'direct', 1, '[]', 'percent', 0.0100, 0.00, 3, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(4, '订单间推奖', 'order_complete', 'indirect', 2, '[2,3,4,5,6]', 'percent', 0.0050, 0.00, 4, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 5. 初始化奖励规则 - 等级升级场景
INSERT INTO `fa_reward_rule` (`id`, `name`, `scene`, `reward_type`, `target_depth`, `level_require`, `amount_type`, `amount_value`, `growth_min`, `sort`, `status`, `createtime`, `updatetime`) VALUES
(5, '升级直推奖', 'level_upgrade', 'direct', 1, '[]', 'percent', 0.1000, 0.00, 5, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '升级间推奖', 'level_upgrade', 'indirect', 2, '[2,3,4,5,6]', 'percent', 0.0500, 0.00, 6, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 6. 初始化分润规则
INSERT INTO `fa_profit_rule` (`id`, `name`, `level_diff`, `rate`, `growth_min`, `sort`, `status`, `createtime`, `updatetime`) VALUES
(1, '1级差分润', 1, 0.0050, 0.00, 1, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '2级差分润', 2, 0.0100, 0.00, 2, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '3级差分润', 3, 0.0150, 10000.00, 3, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(4, '4级差分润', 4, 0.0200, 50000.00, 4, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(5, '5级差分润', 5, 0.0250, 100000.00, 5, 'normal', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 7. 初始化系统配置
INSERT INTO `fa_system_config_ext` (`group`, `key`, `value`, `type`, `title`, `remark`, `sort`, `createtime`, `updatetime`) VALUES
('task', 'sub_task_min_amount', '2000', 'number', '子任务最小金额', '单位：元', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('task', 'sub_task_max_amount', '5000', 'number', '子任务最大金额', '单位：元', 2, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('task', 'service_fee_rate', '0.05', 'number', '服务费率', '默认5%', 3, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('task', 'mutual_balance_min', '-50000', 'number', '互助余额最小值', '低于此值暂停派发', 4, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('task', 'mutual_balance_resume', '-20000', 'number', '互助余额恢复值', '高于此值恢复派发', 5, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('wallet', 'withdraw_fee_rate', '0.006', 'number', '提现手续费率', '默认0.6%', 6, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('wallet', 'withdraw_fee_min', '2', 'number', '提现最低手续费', '单位：元', 7, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('wallet', 'withdraw_min_amount', '100', 'number', '最低提现金额', '单位：元', 8, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('wallet', 'withdraw_max_amount', '50000', 'number', '单次最高提现金额', '单位：元', 9, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('bonus', 'calculate_day', '1', 'number', '分红计算日', '每月几号计算', 10, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('bonus', 'settle_day', '3', 'number', '分红发放日', '每月几号发放', 11, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());
