-- =============================================
-- 数据库增量更新脚本（安全版本）
-- 从现有线上数据库升级到新版本
-- 执行前请备份数据库！
-- =============================================

-- =============================================
-- 第一部分：修改现有表结构
-- =============================================

-- 1. 修改商户表 fa_merchant - 添加新字段
ALTER TABLE `fa_merchant` 
  ADD COLUMN IF NOT EXISTS `type` enum('personal','enterprise') NOT NULL DEFAULT 'personal' COMMENT '商户类型' AFTER `merchant_no`,
  ADD COLUMN IF NOT EXISTS `business_license_no` varchar(50) NOT NULL DEFAULT '' COMMENT '统一社会信用代码' AFTER `business_license`,
  ADD COLUMN IF NOT EXISTS `contact_address` varchar(255) NOT NULL DEFAULT '' COMMENT '联系地址' AFTER `contact_phone`,
  ADD COLUMN IF NOT EXISTS `category` varchar(50) NOT NULL DEFAULT '' COMMENT '经营类目' AFTER `contact_address`;

-- 2. 修改商户审核表 fa_merchant_audit - 添加新字段
ALTER TABLE `fa_merchant_audit`
  ADD COLUMN IF NOT EXISTS `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID' AFTER `merchant_id`,
  ADD COLUMN IF NOT EXISTS `operator_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作员ID' AFTER `user_id`,
  ADD COLUMN IF NOT EXISTS `operator_name` varchar(50) NOT NULL DEFAULT '' COMMENT '操作员姓名' AFTER `operator_id`;

-- 3. 修改互助主任务表 fa_mutual_task - 添加新字段
ALTER TABLE `fa_mutual_task`
  ADD COLUMN IF NOT EXISTS `title` varchar(100) NOT NULL DEFAULT '' COMMENT '任务标题' AFTER `task_no`,
  ADD COLUMN IF NOT EXISTS `category` varchar(50) NOT NULL DEFAULT '' COMMENT '任务类目' AFTER `title`,
  ADD COLUMN IF NOT EXISTS `platform` varchar(50) NOT NULL DEFAULT '' COMMENT '平台类型' AFTER `category`,
  ADD COLUMN IF NOT EXISTS `time_limit` int(10) unsigned NOT NULL DEFAULT '3600' COMMENT '完成时限(秒)' AFTER `end_time`,
  ADD COLUMN IF NOT EXISTS `proof_type` varchar(50) NOT NULL DEFAULT 'image' COMMENT '凭证类型' AFTER `time_limit`,
  ADD COLUMN IF NOT EXISTS `requirements` text COMMENT '任务要求' AFTER `proof_type`;

-- 4. 修改子任务表 fa_sub_task - 添加新字段
ALTER TABLE `fa_sub_task`
  ADD COLUMN IF NOT EXISTS `proof_desc` varchar(500) NOT NULL DEFAULT '' COMMENT '凭证说明' AFTER `proof_image`;

-- 5. 修改钱包表 fa_wallet - 添加新字段
ALTER TABLE `fa_wallet`
  ADD COLUMN IF NOT EXISTS `total_recharge` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计充值' AFTER `total_withdraw`;

-- 6. 修改等级配置表 fa_promo_level - 添加时间字段
ALTER TABLE `fa_promo_level`
  ADD COLUMN IF NOT EXISTS `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `status`,
  ADD COLUMN IF NOT EXISTS `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

-- 更新时间字段
UPDATE `fa_promo_level` SET `createtime` = UNIX_TIMESTAMP(), `updatetime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 7. 修改推广关系表 fa_promo_relation - 添加时间字段
ALTER TABLE `fa_promo_relation`
  ADD COLUMN IF NOT EXISTS `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

UPDATE `fa_promo_relation` SET `updatetime` = `createtime` WHERE `updatetime` = 0;

-- 8. 修改佣金记录表 fa_promo_commission - 添加时间字段
ALTER TABLE `fa_promo_commission`
  ADD COLUMN IF NOT EXISTS `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `remark`;

UPDATE `fa_promo_commission` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 9. 修改分红配置表 fa_promo_bonus_config - 添加时间字段
ALTER TABLE `fa_promo_bonus_config`
  ADD COLUMN IF NOT EXISTS `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `status`,
  ADD COLUMN IF NOT EXISTS `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

UPDATE `fa_promo_bonus_config` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 10. 修改分红记录表 fa_promo_bonus - 添加时间字段
ALTER TABLE `fa_promo_bonus`
  ADD COLUMN IF NOT EXISTS `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `settle_time`;

UPDATE `fa_promo_bonus` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 11. 修改业绩统计表 fa_promo_performance - 添加字段
ALTER TABLE `fa_promo_performance`
  ADD COLUMN IF NOT EXISTS `team_member_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '团队人数' AFTER `direct_count`,
  ADD COLUMN IF NOT EXISTS `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `team_member_count`;

UPDATE `fa_promo_performance` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 12. 修改奖励规则表 fa_reward_rule - 添加字段
ALTER TABLE `fa_reward_rule`
  ADD COLUMN IF NOT EXISTS `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序' AFTER `growth_min`,
  ADD COLUMN IF NOT EXISTS `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

UPDATE `fa_reward_rule` SET `updatetime` = `createtime` WHERE `updatetime` = 0;

-- 13. 修改分润规则表 fa_profit_rule - 添加字段
ALTER TABLE `fa_profit_rule`
  ADD COLUMN IF NOT EXISTS `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序' AFTER `growth_min`,
  ADD COLUMN IF NOT EXISTS `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

UPDATE `fa_profit_rule` SET `updatetime` = `createtime` WHERE `updatetime` = 0;

-- =============================================
-- 第二部分：创建新表
-- =============================================

-- 1. 创建系统配置扩展表
CREATE TABLE IF NOT EXISTS `fa_system_config_ext` (
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

-- =============================================
-- 第三部分：初始化系统配置数据
-- =============================================

INSERT IGNORE INTO `fa_system_config_ext` (`group`, `key`, `value`, `type`, `title`, `remark`, `sort`, `createtime`, `updatetime`) VALUES
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

-- =============================================
-- 升级完成
-- =============================================
SELECT '数据库升级完成！' as message;
