-- =============================================
-- 配置模块数据表
-- =============================================

-- 1. 奖励规则配置表
DROP TABLE IF EXISTS `fa_reward_rule`;
CREATE TABLE `fa_reward_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '规则名称',
  `scene` enum('merchant_entry','order_complete','level_upgrade') NOT NULL DEFAULT 'merchant_entry' COMMENT '触发场景',
  `reward_type` enum('direct','indirect','level_diff','peer','team') NOT NULL DEFAULT 'direct' COMMENT '奖励类型',
  `target_depth` int(10) NOT NULL DEFAULT '0' COMMENT '目标层级(0=全部,-1=不限)',
  `level_require` varchar(100) NOT NULL DEFAULT '' COMMENT '等级要求(JSON)',
  `amount_type` enum('fixed','percent') NOT NULL DEFAULT 'fixed' COMMENT '金额类型',
  `amount_value` decimal(10,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '金额值',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `scene` (`scene`),
  KEY `reward_type` (`reward_type`),
  KEY `status` (`status`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖励规则配置表';

-- 2. 分润规则配置表
DROP TABLE IF EXISTS `fa_profit_rule`;
CREATE TABLE `fa_profit_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '规则名称',
  `level_diff` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '等级差',
  `rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '分润比例',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `level_diff` (`level_diff`),
  KEY `status` (`status`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分润规则配置表';

-- 3. 系统配置扩展表
DROP TABLE IF EXISTS `fa_system_config_ext`;
CREATE TABLE `fa_system_config_ext` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group` varchar(50) NOT NULL DEFAULT '' COMMENT '配置分组',
  `key` varchar(50) NOT NULL DEFAULT '' COMMENT '配置键',
  `value` text COMMENT '配置值',
  `type` varchar(20) NOT NULL DEFAULT 'string' COMMENT '类型:string,number,boolean,json',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '配置标题',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_key` (`group`,`key`),
  KEY `group` (`group`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置扩展表';
