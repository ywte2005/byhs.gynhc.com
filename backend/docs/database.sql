-- 商户互助平台 数据库设计
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 等级配置表
DROP TABLE IF EXISTS `fa_promo_level`;
CREATE TABLE `fa_promo_level` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '等级名称',
  `sort` int(10) NOT NULL DEFAULT 0 COMMENT '排序',
  `upgrade_type` enum('purchase','performance','both') NOT NULL DEFAULT 'purchase' COMMENT '升级方式',
  `upgrade_price` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '购买价格',
  `personal_performance_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '个人业绩要求',
  `team_performance_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '团队业绩要求',
  `direct_invite_min` int(10) NOT NULL DEFAULT 0 COMMENT '直推人数要求',
  `commission_rate` decimal(5,4) NOT NULL DEFAULT 0.0000 COMMENT '佣金比例',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='等级配置表';

-- 2. 用户推广关系表
DROP TABLE IF EXISTS `fa_promo_relation`;
CREATE TABLE `fa_promo_relation` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `level_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '等级ID',
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级ID',
  `path` varchar(1000) NOT NULL DEFAULT '' COMMENT '路径',
  `depth` int(10) NOT NULL DEFAULT 0 COMMENT '深度',
  `invite_code` varchar(20) NOT NULL DEFAULT '' COMMENT '邀请码',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_invite_code` (`invite_code`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推广关系表';

-- 3. 佣金记录表
DROP TABLE IF EXISTS `fa_promo_commission`;
CREATE TABLE `fa_promo_commission` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '获得者',
  `source_user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '来源用户',
  `scene` varchar(50) NOT NULL COMMENT '场景',
  `reward_type` varchar(50) NOT NULL COMMENT '奖励类型',
  `rule_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '规则ID',
  `base_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '基数',
  `amount` decimal(15,2) NOT NULL COMMENT '金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending',
  `settle_time` int(10) UNSIGNED DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_source_user_id` (`source_user_id`),
  KEY `idx_scene` (`scene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金记录表';

-- 4. 分红配置表
DROP TABLE IF EXISTS `fa_promo_bonus_config`;
CREATE TABLE `fa_promo_bonus_config` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '档位名称',
  `team_performance_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '团队业绩门槛',
  `personal_performance_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '个人业绩门槛',
  `qualified_count_min` int(10) NOT NULL DEFAULT 0 COMMENT '达标人数',
  `growth_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '增量门槛',
  `pool_rate` decimal(5,4) NOT NULL COMMENT '奖池比例',
  `sort` int(10) NOT NULL DEFAULT 0,
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红配置表';

-- 5. 分红记录表
DROP TABLE IF EXISTS `fa_promo_bonus`;
CREATE TABLE `fa_promo_bonus` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `config_id` int(10) UNSIGNED NOT NULL COMMENT '配置ID',
  `month` char(7) NOT NULL COMMENT '月份',
  `pool_amount` decimal(15,2) NOT NULL COMMENT '奖池金额',
  `qualified_count` int(10) NOT NULL COMMENT '达标人数',
  `amount` decimal(15,2) NOT NULL COMMENT '分红金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending',
  `settle_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_month` (`user_id`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红记录表';

-- 6. 业绩统计表
DROP TABLE IF EXISTS `fa_promo_performance`;
CREATE TABLE `fa_promo_performance` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `month` char(7) NOT NULL COMMENT '月份',
  `personal_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '个人业绩',
  `team_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '团队业绩',
  `growth_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '增量',
  `direct_count` int(10) NOT NULL DEFAULT 0 COMMENT '直推达标数',
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_month` (`user_id`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业绩统计表';

-- 7. 商户信息表
DROP TABLE IF EXISTS `fa_merchant`;
CREATE TABLE `fa_merchant` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `merchant_no` varchar(32) NOT NULL DEFAULT '' COMMENT '商户编号',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '商户名称',
  `legal_name` varchar(50) NOT NULL DEFAULT '' COMMENT '法人姓名',
  `id_card` varchar(20) NOT NULL DEFAULT '' COMMENT '身份证号',
  `id_card_front` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `id_card_back` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证反面',
  `business_license` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `bank_name` varchar(100) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_account` varchar(30) NOT NULL DEFAULT '' COMMENT '银行账号',
  `bank_branch` varchar(200) NOT NULL DEFAULT '' COMMENT '开户支行',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `entry_fee` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '入驻费',
  `entry_fee_paid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '入驻费已支付',
  `status` enum('pending','approved','rejected','disabled') NOT NULL DEFAULT 'pending',
  `reject_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `approved_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_merchant_no` (`merchant_no`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户信息表';

-- 8. 商户审核记录表
DROP TABLE IF EXISTS `fa_merchant_audit`;
CREATE TABLE `fa_merchant_audit` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `merchant_id` int(10) UNSIGNED NOT NULL,
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核人',
  `action` enum('submit','approve','reject') NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户审核记录表';

-- 9. 互助主任务表
DROP TABLE IF EXISTS `fa_mutual_task`;
CREATE TABLE `fa_mutual_task` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '发起用户',
  `task_no` varchar(32) NOT NULL COMMENT '任务编号',
  `total_amount` decimal(15,2) NOT NULL COMMENT '目标金额',
  `completed_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '已完成金额',
  `pending_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '待完成金额',
  `deposit_amount` decimal(15,2) NOT NULL COMMENT '保证金',
  `frozen_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '已冻结金额',
  `service_fee_rate` decimal(5,4) NOT NULL DEFAULT 0.0000 COMMENT '服务费率',
  `sub_task_min` decimal(10,2) NOT NULL DEFAULT 2000.00 COMMENT '子任务最小金额',
  `sub_task_max` decimal(10,2) NOT NULL DEFAULT 5000.00 COMMENT '子任务最大金额',
  `channel_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付通道',
  `start_time` int(10) UNSIGNED DEFAULT NULL,
  `end_time` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('pending','approved','rejected','running','paused','completed','cancelled') NOT NULL DEFAULT 'pending',
  `reject_reason` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_no` (`task_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='互助主任务表';

-- 10. 子任务表
DROP TABLE IF EXISTS `fa_sub_task`;
CREATE TABLE `fa_sub_task` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_id` int(10) UNSIGNED NOT NULL COMMENT '主任务ID',
  `task_no` varchar(32) NOT NULL COMMENT '子任务编号',
  `from_user_id` int(10) UNSIGNED NOT NULL COMMENT '发起方',
  `to_user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '执行方',
  `amount` decimal(10,2) NOT NULL COMMENT '刷单金额',
  `commission` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '佣金',
  `service_fee` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `proof_image` varchar(500) DEFAULT NULL COMMENT '支付凭证',
  `third_order_no` varchar(64) DEFAULT NULL COMMENT '第三方订单号',
  `status` enum('pending','assigned','accepted','paid','verified','completed','failed','cancelled') NOT NULL DEFAULT 'pending',
  `assigned_time` int(10) UNSIGNED DEFAULT NULL,
  `accepted_time` int(10) UNSIGNED DEFAULT NULL,
  `paid_time` int(10) UNSIGNED DEFAULT NULL,
  `completed_time` int(10) UNSIGNED DEFAULT NULL,
  `fail_reason` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_no` (`task_no`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_from_user_id` (`from_user_id`),
  KEY `idx_to_user_id` (`to_user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='子任务表';

-- 11. 钱包表
DROP TABLE IF EXISTS `fa_wallet`;
CREATE TABLE `fa_wallet` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '可用余额',
  `deposit` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '保证金',
  `frozen` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '冻结金额',
  `mutual_balance` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '互助余额',
  `total_income` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '累计收入',
  `total_withdraw` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '累计提现',
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钱包表';

-- 12. 钱包流水表
DROP TABLE IF EXISTS `fa_wallet_log`;
CREATE TABLE `fa_wallet_log` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `wallet_type` enum('balance','deposit','frozen','mutual') NOT NULL COMMENT '钱包类型',
  `change_type` enum('income','expense','freeze','unfreeze') NOT NULL COMMENT '变动类型',
  `amount` decimal(15,2) NOT NULL COMMENT '变动金额',
  `before_amount` decimal(15,2) NOT NULL COMMENT '变动前',
  `after_amount` decimal(15,2) NOT NULL COMMENT '变动后',
  `biz_type` varchar(50) NOT NULL COMMENT '业务类型',
  `biz_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '业务ID',
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_biz` (`biz_type`, `biz_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钱包流水表';

-- 13. 提现申请表
DROP TABLE IF EXISTS `fa_withdraw`;
CREATE TABLE `fa_withdraw` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `withdraw_no` varchar(32) NOT NULL COMMENT '提现单号',
  `amount` decimal(15,2) NOT NULL COMMENT '提现金额',
  `fee` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '手续费',
  `actual_amount` decimal(15,2) NOT NULL COMMENT '实际到账',
  `bank_name` varchar(100) NOT NULL,
  `bank_account` varchar(30) NOT NULL,
  `bank_branch` varchar(200) DEFAULT NULL,
  `account_name` varchar(50) NOT NULL COMMENT '户名',
  `status` enum('pending','approved','rejected','paid','failed') NOT NULL DEFAULT 'pending',
  `reject_reason` varchar(255) DEFAULT NULL,
  `admin_id` int(10) UNSIGNED DEFAULT NULL,
  `audit_time` int(10) UNSIGNED DEFAULT NULL,
  `paid_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_withdraw_no` (`withdraw_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现申请表';

-- 14. 奖励规则配置表
DROP TABLE IF EXISTS `fa_reward_rule`;
CREATE TABLE `fa_reward_rule` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '规则名称',
  `scene` enum('merchant_entry','order_complete','level_upgrade') NOT NULL COMMENT '触发场景',
  `reward_type` enum('direct','indirect','level_diff','peer','team') NOT NULL COMMENT '奖励类型',
  `target_depth` int(10) NOT NULL DEFAULT 1 COMMENT '目标层级',
  `level_require` varchar(255) DEFAULT NULL COMMENT '等级要求JSON',
  `amount_type` enum('fixed','percent') NOT NULL COMMENT '金额类型',
  `amount_value` decimal(10,4) NOT NULL COMMENT '金额值',
  `growth_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '增量门槛',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_scene` (`scene`),
  KEY `idx_reward_type` (`reward_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖励规则配置表';

-- 15. 分润规则配置表
DROP TABLE IF EXISTS `fa_profit_rule`;
CREATE TABLE `fa_profit_rule` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '规则名称',
  `level_diff` int(10) NOT NULL COMMENT '等级差',
  `profit_rate` decimal(5,4) NOT NULL COMMENT '分润比例',
  `growth_min` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT '增量门槛',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_level_diff` (`level_diff`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分润规则配置表';

-- 16. 充值记录表
DROP TABLE IF EXISTS `fa_recharge`;
CREATE TABLE `fa_recharge` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `order_no` varchar(32) NOT NULL COMMENT '订单号',
  `amount` decimal(15,2) NOT NULL COMMENT '充值金额',
  `target` enum('balance','deposit') NOT NULL DEFAULT 'balance' COMMENT '充值目标',
  `pay_method` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式',
  `third_order_no` varchar(64) DEFAULT NULL COMMENT '第三方订单号',
  `status` enum('pending','paid','failed') NOT NULL DEFAULT 'pending',
  `paid_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='充值记录表';

SET FOREIGN_KEY_CHECKS = 1;

-- 初始化等级数据
INSERT INTO `fa_promo_level` (`name`, `sort`, `upgrade_type`, `upgrade_price`, `personal_performance_min`, `team_performance_min`, `direct_invite_min`, `commission_rate`, `status`, `createtime`) VALUES
('普通会员', 0, 'purchase', 0.00, 0.00, 0.00, 0, 0.0010, 'normal', UNIX_TIMESTAMP()),
('银卡会员', 1, 'both', 1000.00, 50000.00, 100000.00, 5, 0.0020, 'normal', UNIX_TIMESTAMP()),
('金卡会员', 2, 'both', 3000.00, 150000.00, 500000.00, 10, 0.0030, 'normal', UNIX_TIMESTAMP()),
('铂金会员', 3, 'both', 10000.00, 500000.00, 2000000.00, 20, 0.0050, 'normal', UNIX_TIMESTAMP()),
('钻石会员', 4, 'both', 30000.00, 1500000.00, 10000000.00, 50, 0.0080, 'normal', UNIX_TIMESTAMP());

-- 初始化奖励规则
INSERT INTO `fa_reward_rule` (`name`, `scene`, `reward_type`, `target_depth`, `amount_type`, `amount_value`, `status`, `createtime`) VALUES
('商户入驻直推奖', 'merchant_entry', 'direct', 1, 'percent', 0.1000, 'normal', UNIX_TIMESTAMP()),
('商户入驻间推奖', 'merchant_entry', 'indirect', 2, 'percent', 0.0500, 'normal', UNIX_TIMESTAMP()),
('等级升级直推奖', 'level_upgrade', 'direct', 1, 'percent', 0.1000, 'normal', UNIX_TIMESTAMP()),
('等级升级间推奖', 'level_upgrade', 'indirect', 2, 'percent', 0.0500, 'normal', UNIX_TIMESTAMP());

-- 初始化分润规则
INSERT INTO `fa_profit_rule` (`name`, `level_diff`, `profit_rate`, `growth_min`, `status`, `createtime`) VALUES
('一级差分润', 1, 0.0005, 0.00, 'normal', UNIX_TIMESTAMP()),
('二级差分润', 2, 0.0010, 0.00, 'normal', UNIX_TIMESTAMP()),
('三级差分润', 3, 0.0015, 0.00, 'normal', UNIX_TIMESTAMP()),
('四级差分润', 4, 0.0020, 0.00, 'normal', UNIX_TIMESTAMP());

-- 初始化分红配置
INSERT INTO `fa_promo_bonus_config` (`name`, `team_performance_min`, `personal_performance_min`, `qualified_count_min`, `growth_min`, `pool_rate`, `sort`, `status`, `createtime`) VALUES
('基础分红', 100000.00, 10000.00, 3, 0.00, 0.0100, 1, 'normal', UNIX_TIMESTAMP()),
('进阶分红', 500000.00, 50000.00, 10, 10000.00, 0.0150, 2, 'normal', UNIX_TIMESTAMP()),
('高级分红', 2000000.00, 200000.00, 30, 50000.00, 0.0200, 3, 'normal', UNIX_TIMESTAMP());
