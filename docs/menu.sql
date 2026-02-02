-- 后台菜单配置
-- 菜单顺序按业务流程：商户入驻 → 互助任务 → 资金管理 → 推广分销 → 系统配置

-- 1. 商户管理（业务起点：商户入驻审核）
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', 0, 'merchant', '商户管理', 'fa fa-building', '', '商户入驻与审核管理', 1, 100, 'normal');
SET @merchant_pid = LAST_INSERT_ID();
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', @merchant_pid, 'merchant/merchant', '商户列表', 'fa fa-list', '', '商户信息与状态管理', 1, 10, 'normal'),
('file', @merchant_pid, 'merchant/audit', '审核管理', 'fa fa-check-square', '', '商户入驻审核', 1, 9, 'normal');

-- 2. 任务管理（核心业务：互助刷单流程）
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', 0, 'task', '任务管理', 'fa fa-tasks', '', '互助任务与子任务管理', 1, 90, 'normal');
SET @task_pid = LAST_INSERT_ID();
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', @task_pid, 'task/mutualtask', '主任务列表', 'fa fa-list', '', '互助主任务管理', 1, 10, 'normal'),
('file', @task_pid, 'task/subtask', '子任务列表', 'fa fa-list-alt', '', '子任务执行与监控', 1, 9, 'normal');

-- 3. 钱包管理（资金流转：余额、保证金、提现）
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', 0, 'wallet', '钱包管理', 'fa fa-money', '', '用户资金与流水管理', 1, 80, 'normal');
SET @wallet_pid = LAST_INSERT_ID();
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', @wallet_pid, 'wallet/wallet', '用户钱包', 'fa fa-credit-card', '', '钱包余额与保证金', 1, 10, 'normal'),
('file', @wallet_pid, 'wallet/log', '流水查询', 'fa fa-history', '', '资金变动明细', 1, 9, 'normal'),
('file', @wallet_pid, 'wallet/withdraw', '提现审核', 'fa fa-sign-out', '', '用户提现申请审核', 1, 8, 'normal');

-- 4. 推广管理（分销体系：等级、关系、佣金、分红）
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', 0, 'promo', '推广管理', 'fa fa-users', '', '推广分销与收益管理', 1, 70, 'normal');
SET @promo_pid = LAST_INSERT_ID();
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', @promo_pid, 'promo/level', '等级配置', 'fa fa-star', '', '用户等级体系配置', 1, 10, 'normal'),
('file', @promo_pid, 'promo/relation', '推广关系', 'fa fa-sitemap', '', '用户推广关系树', 1, 9, 'normal'),
('file', @promo_pid, 'promo/commission', '佣金记录', 'fa fa-dollar', '', '佣金发放明细', 1, 8, 'normal'),
('file', @promo_pid, 'promo/bonus', '分红管理', 'fa fa-gift', '', '月度分红统计与发放', 1, 7, 'normal');

-- 5. 配置中心（系统配置：奖励、分润、分红规则）
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', 0, 'config_center', '配置中心', 'fa fa-cogs', '', '业务规则与系统配置', 1, 60, 'normal');
SET @config_pid = LAST_INSERT_ID();
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `weigh`, `status`) VALUES
('file', @config_pid, 'config/reward', '奖励规则', 'fa fa-trophy', '', '佣金奖励规则配置', 1, 10, 'normal'),
('file', @config_pid, 'config/profit', '分润规则', 'fa fa-percent', '', '等级差分润配置', 1, 9, 'normal'),
('file', @config_pid, 'config/bonusconfig', '分红配置', 'fa fa-pie-chart', '', '月度分红档位配置', 1, 8, 'normal');
