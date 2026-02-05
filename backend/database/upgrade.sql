-- =============================================
-- 数据库增量更新脚本
-- 从现有线上数据库升级到新版本
-- 执行前请备份数据库！
-- =============================================

-- =============================================
-- 第一部分：修改现有表结构
-- =============================================

-- 1. 修改商户表 fa_merchant
-- 添加缺失字段（检查字段是否存在）
SET @exist_type := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant' AND COLUMN_NAME = 'type');
SET @sql_type := IF(@exist_type = 0, 'ALTER TABLE `fa_merchant` ADD COLUMN `type` enum(''personal'',''enterprise'') NOT NULL DEFAULT ''personal'' COMMENT ''商户类型:personal=个人,enterprise=企业'' AFTER `merchant_no`', 'SELECT ''字段type已存在''');
PREPARE stmt FROM @sql_type;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_license_no := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant' AND COLUMN_NAME = 'business_license_no');
SET @sql_license_no := IF(@exist_license_no = 0, 'ALTER TABLE `fa_merchant` ADD COLUMN `business_license_no` varchar(50) NOT NULL DEFAULT '''' COMMENT ''统一社会信用代码'' AFTER `business_license`', 'SELECT ''字段business_license_no已存在''');
PREPARE stmt FROM @sql_license_no;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_address := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant' AND COLUMN_NAME = 'contact_address');
SET @sql_address := IF(@exist_address = 0, 'ALTER TABLE `fa_merchant` ADD COLUMN `contact_address` varchar(255) NOT NULL DEFAULT '''' COMMENT ''联系地址'' AFTER `contact_phone`', 'SELECT ''字段contact_address已存在''');
PREPARE stmt FROM @sql_address;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_category := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant' AND COLUMN_NAME = 'category');
SET @sql_category := IF(@exist_category = 0, 'ALTER TABLE `fa_merchant` ADD COLUMN `category` varchar(50) NOT NULL DEFAULT '''' COMMENT ''经营类目'' AFTER `contact_address`', 'SELECT ''字段category已存在''');
PREPARE stmt FROM @sql_category;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 修改entry_fee字段类型
ALTER TABLE `fa_merchant` 
  MODIFY COLUMN `entry_fee` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '入驻费';

-- 删除旧字段
SET @exist_paid := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant' AND COLUMN_NAME = 'entry_fee_paid');
SET @sql_paid := IF(@exist_paid > 0, 'ALTER TABLE `fa_merchant` DROP COLUMN `entry_fee_paid`', 'SELECT ''字段entry_fee_paid不存在''');
PREPARE stmt FROM @sql_paid;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 修改商户审核表 fa_merchant_audit
-- 添加新字段
SET @exist_user_id := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'user_id');
SET @sql_user_id := IF(@exist_user_id = 0, 'ALTER TABLE `fa_merchant_audit` ADD COLUMN `user_id` int(10) unsigned NOT NULL COMMENT ''用户ID'' AFTER `merchant_id`', 'SELECT ''字段user_id已存在''');
PREPARE stmt FROM @sql_user_id;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_operator_id := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'operator_id');
SET @sql_operator_id := IF(@exist_operator_id = 0, 'ALTER TABLE `fa_merchant_audit` ADD COLUMN `operator_id` int(10) unsigned NOT NULL DEFAULT ''0'' COMMENT ''操作员ID'' AFTER `user_id`', 'SELECT ''字段operator_id已存在''');
PREPARE stmt FROM @sql_operator_id;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_operator_name := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'operator_name');
SET @sql_operator_name := IF(@exist_operator_name = 0, 'ALTER TABLE `fa_merchant_audit` ADD COLUMN `operator_name` varchar(50) NOT NULL DEFAULT '''' COMMENT ''操作员姓名'' AFTER `operator_id`', 'SELECT ''字段operator_name已存在''');
PREPARE stmt FROM @sql_operator_name;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 重命名字段（如果旧字段存在）
SET @exist_action := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'action');
SET @exist_status := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'status');
SET @sql_status := IF(@exist_action > 0 AND @exist_status = 0, 'ALTER TABLE `fa_merchant_audit` CHANGE COLUMN `action` `status` enum(''pending'',''approved'',''rejected'') NOT NULL DEFAULT ''pending'' COMMENT ''状态''', 'SELECT ''字段action不存在或status已存在''');
PREPARE stmt FROM @sql_status;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_remark := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'remark');
SET @exist_reason := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_merchant_audit' AND COLUMN_NAME = 'reason');
SET @sql_reason := IF(@exist_remark > 0 AND @exist_reason = 0, 'ALTER TABLE `fa_merchant_audit` CHANGE COLUMN `remark` `reason` varchar(255) NOT NULL DEFAULT '''' COMMENT ''审核意见''', 'SELECT ''字段remark不存在或reason已存在''');
PREPARE stmt FROM @sql_reason;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. 修改互助主任务表 fa_mutual_task
-- 添加新字段
SET @exist_title := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'title');
SET @sql_title := IF(@exist_title = 0, 'ALTER TABLE `fa_mutual_task` ADD COLUMN `title` varchar(100) NOT NULL DEFAULT '''' COMMENT ''任务标题'' AFTER `task_no`', 'SELECT ''字段title已存在''');
PREPARE stmt FROM @sql_title;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_category := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'category');
SET @sql_category := IF(@exist_category = 0, 'ALTER TABLE `fa_mutual_task` ADD COLUMN `category` varchar(50) NOT NULL DEFAULT '''' COMMENT ''任务类目'' AFTER `title`', 'SELECT ''字段category已存在''');
PREPARE stmt FROM @sql_category;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_platform := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'platform');
SET @sql_platform := IF(@exist_platform = 0, 'ALTER TABLE `fa_mutual_task` ADD COLUMN `platform` varchar(50) NOT NULL DEFAULT '''' COMMENT ''平台类型'' AFTER `category`', 'SELECT ''字段platform已存在''');
PREPARE stmt FROM @sql_platform;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_time_limit := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'time_limit');
SET @sql_time_limit := IF(@exist_time_limit = 0, 'ALTER TABLE `fa_mutual_task` ADD COLUMN `time_limit` int(10) unsigned NOT NULL DEFAULT ''3600'' COMMENT ''完成时限(秒)'' AFTER `end_time`', 'SELECT ''字段time_limit已存在''');
PREPARE stmt FROM @sql_time_limit;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_proof_type := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'proof_type');
SET @sql_proof_type := IF(@exist_proof_type = 0, 'ALTER TABLE `fa_mutual_task` ADD COLUMN `proof_type` varchar(50) NOT NULL DEFAULT ''image'' COMMENT ''凭证类型'' AFTER `time_limit`', 'SELECT ''字段proof_type已存在''');
PREPARE stmt FROM @sql_proof_type;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_requirements := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'requirements');
SET @sql_requirements := IF(@exist_requirements = 0, 'ALTER TABLE `fa_mutual_task` ADD COLUMN `requirements` text COMMENT ''任务要求'' AFTER `proof_type`', 'SELECT ''字段requirements已存在''');
PREPARE stmt FROM @sql_requirements;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 删除旧字段
SET @exist_receipt_type := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'receipt_type');
SET @sql_receipt_type := IF(@exist_receipt_type > 0, 'ALTER TABLE `fa_mutual_task` DROP COLUMN `receipt_type`', 'SELECT ''字段receipt_type不存在''');
PREPARE stmt FROM @sql_receipt_type;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_entry_qrcode := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'entry_qrcode');
SET @sql_entry_qrcode := IF(@exist_entry_qrcode > 0, 'ALTER TABLE `fa_mutual_task` DROP COLUMN `entry_qrcode`', 'SELECT ''字段entry_qrcode不存在''');
PREPARE stmt FROM @sql_entry_qrcode;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist_collection_qrcode := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_mutual_task' AND COLUMN_NAME = 'collection_qrcode');
SET @sql_collection_qrcode := IF(@exist_collection_qrcode > 0, 'ALTER TABLE `fa_mutual_task` DROP COLUMN `collection_qrcode`', 'SELECT ''字段collection_qrcode不存在''');
PREPARE stmt FROM @sql_collection_qrcode;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4. 修改子任务表 fa_sub_task
ALTER TABLE `fa_sub_task`
  ADD COLUMN `proof_desc` varchar(500) NOT NULL DEFAULT '' COMMENT '凭证说明' AFTER `proof_image`;

-- 5. 修改钱包表 fa_wallet
ALTER TABLE `fa_wallet`
  ADD COLUMN `total_recharge` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计充值' AFTER `total_withdraw`,
  MODIFY COLUMN `deposit` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '保证金',
  MODIFY COLUMN `frozen` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '冻结金额(已派发待完成)',
  MODIFY COLUMN `total_income` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计收入',
  MODIFY COLUMN `total_withdraw` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计提现';

-- 6. 修改钱包流水表 fa_wallet_log (无需修改，结构已匹配)

-- 7. 修改充值记录表 fa_recharge
ALTER TABLE `fa_recharge`
  MODIFY COLUMN `status` enum('pending','paid','failed') NOT NULL DEFAULT 'pending' COMMENT '状态';

-- 8. 修改提现表 fa_withdraw
ALTER TABLE `fa_withdraw`
  CHANGE COLUMN `withdraw_no` `order_no` varchar(32) NOT NULL COMMENT '提现单号',
  MODIFY COLUMN `status` enum('pending','processing','completed','failed','cancelled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  ADD COLUMN `complete_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间' AFTER `audit_time`,
  ADD COLUMN `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因' AFTER `complete_time`,
  ADD COLUMN `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注' AFTER `fail_reason`;

-- 删除旧字段
ALTER TABLE `fa_withdraw`
  DROP COLUMN IF EXISTS `reject_reason`,
  DROP COLUMN IF EXISTS `admin_id`,
  DROP COLUMN IF EXISTS `paid_time`;

-- 9. 修改等级配置表 fa_promo_level
ALTER TABLE `fa_promo_level`
  MODIFY COLUMN `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序(数字越小等级越低)',
  MODIFY COLUMN `upgrade_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '购买价格',
  MODIFY COLUMN `personal_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩要求',
  MODIFY COLUMN `team_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩要求',
  MODIFY COLUMN `direct_invite_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直推人数要求',
  MODIFY COLUMN `commission_rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '刷单佣金比例',
  ADD COLUMN `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `status`,
  ADD COLUMN `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

-- 更新时间字段
UPDATE `fa_promo_level` SET `createtime` = UNIX_TIMESTAMP(), `updatetime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 10. 修改推广关系表 fa_promo_relation
ALTER TABLE `fa_promo_relation`
  MODIFY COLUMN `level_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前等级ID',
  MODIFY COLUMN `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直接上级用户ID',
  MODIFY COLUMN `path` varchar(1000) NOT NULL DEFAULT '' COMMENT '完整上级路径,如:1,5,10',
  MODIFY COLUMN `depth` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '层级深度',
  ADD COLUMN `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

-- 更新时间字段
UPDATE `fa_promo_relation` SET `updatetime` = `createtime` WHERE `updatetime` = 0;

-- 11. 修改佣金记录表 fa_promo_commission
ALTER TABLE `fa_promo_commission`
  MODIFY COLUMN `user_id` int(10) unsigned NOT NULL COMMENT '获得者用户ID',
  MODIFY COLUMN `source_user_id` int(10) unsigned NOT NULL COMMENT '来源用户ID',
  MODIFY COLUMN `scene` varchar(50) NOT NULL DEFAULT '' COMMENT '触发场景:merchant_entry=商户入驻,order_complete=订单完成,level_upgrade=等级升级',
  MODIFY COLUMN `reward_type` varchar(50) NOT NULL DEFAULT '' COMMENT '奖励类型:direct=直推,indirect=间推,level_diff=等级差,peer=平级,team=团队',
  MODIFY COLUMN `base_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '计算基数',
  MODIFY COLUMN `amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '佣金金额',
  MODIFY COLUMN `settle_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结算时间',
  MODIFY COLUMN `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  ADD COLUMN `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `remark`;

-- 更新时间字段
UPDATE `fa_promo_commission` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 12. 修改分红配置表 fa_promo_bonus_config
ALTER TABLE `fa_promo_bonus_config`
  MODIFY COLUMN `team_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩门槛',
  MODIFY COLUMN `personal_performance_min` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩门槛',
  MODIFY COLUMN `qualified_count_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '达标人数门槛',
  MODIFY COLUMN `pool_rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '奖池比例',
  MODIFY COLUMN `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  ADD COLUMN `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `status`,
  ADD COLUMN `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

-- 更新时间字段
UPDATE `fa_promo_bonus_config` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 13. 修改分红记录表 fa_promo_bonus
ALTER TABLE `fa_promo_bonus`
  CHANGE COLUMN `month` `period` varchar(20) NOT NULL DEFAULT '' COMMENT '期数,如:202501',
  MODIFY COLUMN `pool_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '奖池金额',
  MODIFY COLUMN `qualified_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '达标人数',
  MODIFY COLUMN `amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '分红金额',
  MODIFY COLUMN `settle_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结算时间',
  ADD COLUMN `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `settle_time`;

-- 更新时间字段
UPDATE `fa_promo_bonus` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 14. 修改业绩统计表 fa_promo_performance
ALTER TABLE `fa_promo_performance`
  CHANGE COLUMN `month` `period` varchar(20) NOT NULL DEFAULT '' COMMENT '期数,如:202501',
  CHANGE COLUMN `personal_amount` `personal_performance` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩',
  CHANGE COLUMN `team_amount` `team_performance` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩',
  CHANGE COLUMN `growth_amount` `growth` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '业绩增量',
  CHANGE COLUMN `direct_count` `direct_invite_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直推人数',
  ADD COLUMN `team_member_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '团队人数' AFTER `direct_invite_count`,
  ADD COLUMN `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间' AFTER `team_member_count`;

-- 更新时间字段
UPDATE `fa_promo_performance` SET `createtime` = UNIX_TIMESTAMP() WHERE `createtime` = 0;

-- 15. 修改奖励规则表 fa_reward_rule
ALTER TABLE `fa_reward_rule`
  MODIFY COLUMN `target_depth` int(10) NOT NULL DEFAULT '0' COMMENT '目标层级(0=全部,-1=不限)',
  MODIFY COLUMN `level_require` varchar(100) NOT NULL DEFAULT '' COMMENT '等级要求(JSON)',
  MODIFY COLUMN `amount_value` decimal(10,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '金额值',
  ADD COLUMN `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序' AFTER `growth_min`,
  ADD COLUMN `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

-- 更新时间字段
UPDATE `fa_reward_rule` SET `updatetime` = `createtime` WHERE `updatetime` = 0;

-- 16. 修改分润规则表 fa_profit_rule
ALTER TABLE `fa_profit_rule`
  CHANGE COLUMN `profit_rate` `rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '分润比例',
  MODIFY COLUMN `level_diff` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '等级差',
  ADD COLUMN `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序' AFTER `growth_min`,
  ADD COLUMN `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间' AFTER `createtime`;

-- 更新时间字段
UPDATE `fa_profit_rule` SET `updatetime` = `createtime` WHERE `updatetime` = 0;

-- =============================================
-- 第二部分：创建新表
-- =============================================

-- 1. 创建提现记录表（新表名）
DROP TABLE IF EXISTS `fa_withdraw_record`;
CREATE TABLE `fa_withdraw_record` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `order_no` varchar(32) NOT NULL DEFAULT '' COMMENT '提现单号',
  `amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '提现金额',
  `fee` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '手续费',
  `actual_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际到账金额',
  `bank_name` varchar(100) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_account` varchar(30) NOT NULL DEFAULT '' COMMENT '银行账号',
  `bank_branch` varchar(200) NOT NULL DEFAULT '' COMMENT '开户支行',
  `account_name` varchar(50) NOT NULL DEFAULT '' COMMENT '账户名',
  `status` enum('pending','processing','completed','failed','cancelled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `audit_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `complete_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no` (`order_no`),
  KEY `user_id` (`user_id`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现记录表';

-- 2. 创建系统配置扩展表
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

-- =============================================
-- 第三部分：添加索引优化
-- =============================================

-- 为fa_promo_commission添加索引
ALTER TABLE `fa_promo_commission`
  ADD KEY IF NOT EXISTS `user_id` (`user_id`),
  ADD KEY IF NOT EXISTS `source_user_id` (`source_user_id`),
  ADD KEY IF NOT EXISTS `scene` (`scene`),
  ADD KEY IF NOT EXISTS `status` (`status`),
  ADD KEY IF NOT EXISTS `createtime` (`createtime`);

-- 为fa_promo_bonus添加索引
ALTER TABLE `fa_promo_bonus`
  ADD KEY IF NOT EXISTS `user_id` (`user_id`),
  ADD KEY IF NOT EXISTS `period` (`period`),
  ADD KEY IF NOT EXISTS `status` (`status`);

-- 为fa_promo_performance添加索引
ALTER TABLE `fa_promo_performance`
  ADD UNIQUE KEY IF NOT EXISTS `user_period` (`user_id`,`period`),
  ADD KEY IF NOT EXISTS `period` (`period`);

-- 为fa_reward_rule添加索引
ALTER TABLE `fa_reward_rule`
  ADD KEY IF NOT EXISTS `scene` (`scene`),
  ADD KEY IF NOT EXISTS `reward_type` (`reward_type`),
  ADD KEY IF NOT EXISTS `status` (`status`),
  ADD KEY IF NOT EXISTS `sort` (`sort`);

-- 为fa_profit_rule添加索引
ALTER TABLE `fa_profit_rule`
  ADD KEY IF NOT EXISTS `level_diff` (`level_diff`),
  ADD KEY IF NOT EXISTS `status` (`status`),
  ADD KEY IF NOT EXISTS `sort` (`sort`);

-- =============================================
-- 第四部分：初始化系统配置数据
-- =============================================

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

-- =============================================
-- 升级完成
-- =============================================
-- 请检查执行结果，确认所有表结构已正确更新
-- 建议执行后进行数据验证测试
