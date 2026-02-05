-- =============================================
-- 推广模块数据表
-- =============================================

-- 1. 等级配置表
DROP TABLE IF EXISTS `fa_promo_level`;
CREATE TABLE `fa_promo_level` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '等级名称',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序(数字越小等级越低)',
  `upgrade_type` enum('purchase','performance','both') NOT NULL DEFAULT 'purchase' COMMENT '升级方式:purchase=购买,performance=业绩,both=两者皆可',
  `upgrade_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '购买价格',
  `personal_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩要求',
  `team_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩要求',
  `direct_invite_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直推人数要求',
  `commission_rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '刷单佣金比例',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='等级配置表';

-- 2. 用户推广关系表
DROP TABLE IF EXISTS `fa_promo_relation`;
CREATE TABLE `fa_promo_relation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `level_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前等级ID',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直接上级用户ID',
  `path` varchar(1000) NOT NULL DEFAULT '' COMMENT '完整上级路径,如:1,5,10',
  `depth` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '层级深度',
  `invite_code` varchar(20) NOT NULL DEFAULT '' COMMENT '邀请码',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `invite_code` (`invite_code`),
  KEY `parent_id` (`parent_id`),
  KEY `level_id` (`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户推广关系表';

-- 3. 佣金记录表
DROP TABLE IF EXISTS `fa_promo_commission`;
CREATE TABLE `fa_promo_commission` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '获得者用户ID',
  `source_user_id` int(10) unsigned NOT NULL COMMENT '来源用户ID',
  `scene` varchar(50) NOT NULL DEFAULT '' COMMENT '触发场景:merchant_entry=商户入驻,order_complete=订单完成,level_upgrade=等级升级',
  `reward_type` varchar(50) NOT NULL DEFAULT '' COMMENT '奖励类型:direct=直推,indirect=间推,level_diff=等级差,peer=平级,team=团队',
  `rule_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规则ID',
  `base_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '计算基数',
  `amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '佣金金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `settle_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结算时间',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `source_user_id` (`source_user_id`),
  KEY `scene` (`scene`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金记录表';

-- 4. 分红配置表
DROP TABLE IF EXISTS `fa_promo_bonus_config`;
CREATE TABLE `fa_promo_bonus_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '档位名称',
  `team_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩门槛',
  `personal_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩门槛',
  `qualified_count_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '达标人数门槛',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `pool_rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '奖池比例',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `sort` (`sort`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红配置表';

-- 5. 分红记录表
DROP TABLE IF EXISTS `fa_promo_bonus`;
CREATE TABLE `fa_promo_bonus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `config_id` int(10) unsigned NOT NULL COMMENT '配置ID',
  `period` varchar(20) NOT NULL DEFAULT '' COMMENT '期数,如:202501',
  `pool_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '奖池金额',
  `qualified_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '达标人数',
  `amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '分红金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `settle_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结算时间',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `period` (`period`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红记录表';

-- 6. 业绩统计表(月度)
DROP TABLE IF EXISTS `fa_promo_performance`;
CREATE TABLE `fa_promo_performance` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `period` varchar(20) NOT NULL DEFAULT '' COMMENT '期数,如:202501',
  `personal_performance` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩',
  `team_performance` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩',
  `direct_invite_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直推人数',
  `team_member_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '团队人数',
  `growth` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '业绩增量',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_period` (`user_id`,`period`),
  KEY `period` (`period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业绩统计表';
