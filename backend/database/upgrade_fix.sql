-- =============================================
-- 数据库升级修复脚本
-- 修复测试中发现的问题
-- =============================================

-- 1. 创建提现记录表 fa_withdraw_record
CREATE TABLE IF NOT EXISTS `fa_withdraw_record` (
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

-- 2. 重命名业绩表字段
-- 检查并重命名 month 为 period
SET @col_exists_month = 0;
SELECT COUNT(*) INTO @col_exists_month FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'month';

SET @col_exists_period = 0;
SELECT COUNT(*) INTO @col_exists_period FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'period';

SET @sql = IF(@col_exists_month > 0 AND @col_exists_period = 0, 
  'ALTER TABLE `fa_promo_performance` CHANGE COLUMN `month` `period` varchar(20) NOT NULL DEFAULT '''' COMMENT ''期数,如:202501''',
  'SELECT ''字段month不存在或period已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并重命名 personal_amount 为 personal_performance
SET @col_exists_old = 0;
SELECT COUNT(*) INTO @col_exists_old FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'personal_amount';

SET @col_exists_new = 0;
SELECT COUNT(*) INTO @col_exists_new FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'personal_performance';

SET @sql = IF(@col_exists_old > 0 AND @col_exists_new = 0, 
  'ALTER TABLE `fa_promo_performance` CHANGE COLUMN `personal_amount` `personal_performance` decimal(15,2) unsigned NOT NULL DEFAULT ''0.00'' COMMENT ''个人业绩''',
  'SELECT ''字段personal_amount不存在或personal_performance已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并重命名 team_amount 为 team_performance
SET @col_exists_old = 0;
SELECT COUNT(*) INTO @col_exists_old FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'team_amount';

SET @col_exists_new = 0;
SELECT COUNT(*) INTO @col_exists_new FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'team_performance';

SET @sql = IF(@col_exists_old > 0 AND @col_exists_new = 0, 
  'ALTER TABLE `fa_promo_performance` CHANGE COLUMN `team_amount` `team_performance` decimal(15,2) unsigned NOT NULL DEFAULT ''0.00'' COMMENT ''团队业绩''',
  'SELECT ''字段team_amount不存在或team_performance已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并重命名 growth_amount 为 growth
SET @col_exists_old = 0;
SELECT COUNT(*) INTO @col_exists_old FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'growth_amount';

SET @col_exists_new = 0;
SELECT COUNT(*) INTO @col_exists_new FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'growth';

SET @sql = IF(@col_exists_old > 0 AND @col_exists_new = 0, 
  'ALTER TABLE `fa_promo_performance` CHANGE COLUMN `growth_amount` `growth` decimal(15,2) NOT NULL DEFAULT ''0.00'' COMMENT ''业绩增量''',
  'SELECT ''字段growth_amount不存在或growth已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并重命名 direct_count 为 direct_invite_count
SET @col_exists_old = 0;
SELECT COUNT(*) INTO @col_exists_old FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'direct_count';

SET @col_exists_new = 0;
SELECT COUNT(*) INTO @col_exists_new FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND COLUMN_NAME = 'direct_invite_count';

SET @sql = IF(@col_exists_old > 0 AND @col_exists_new = 0, 
  'ALTER TABLE `fa_promo_performance` CHANGE COLUMN `direct_count` `direct_invite_count` int(10) unsigned NOT NULL DEFAULT ''0'' COMMENT ''直推人数''',
  'SELECT ''字段direct_count不存在或direct_invite_count已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. 重命名分红表字段（在添加索引前）
-- 检查并重命名 month 为 period
SET @col_exists_month = 0;
SELECT COUNT(*) INTO @col_exists_month FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_bonus' AND COLUMN_NAME = 'month';

SET @col_exists_period = 0;
SELECT COUNT(*) INTO @col_exists_period FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_bonus' AND COLUMN_NAME = 'period';

SET @sql = IF(@col_exists_month > 0 AND @col_exists_period = 0, 
  'ALTER TABLE `fa_promo_bonus` CHANGE COLUMN `month` `period` varchar(20) NOT NULL DEFAULT '''' COMMENT ''期数,如:202501''',
  'SELECT ''字段month不存在或period已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4. 添加索引
-- 为 fa_promo_commission 添加索引
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_commission' AND INDEX_NAME = 'user_id';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_commission` ADD KEY `user_id` (`user_id`)',
  'SELECT ''索引user_id已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_commission' AND INDEX_NAME = 'source_user_id';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_commission` ADD KEY `source_user_id` (`source_user_id`)',
  'SELECT ''索引source_user_id已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_commission' AND INDEX_NAME = 'scene';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_commission` ADD KEY `scene` (`scene`)',
  'SELECT ''索引scene已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_commission' AND INDEX_NAME = 'status';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_commission` ADD KEY `status` (`status`)',
  'SELECT ''索引status已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_commission' AND INDEX_NAME = 'createtime';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_commission` ADD KEY `createtime` (`createtime`)',
  'SELECT ''索引createtime已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 为 fa_promo_performance 添加联合索引
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND INDEX_NAME = 'user_period';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_performance` ADD UNIQUE KEY `user_period` (`user_id`,`period`)',
  'SELECT ''索引user_period已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_performance' AND INDEX_NAME = 'period';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_performance` ADD KEY `period` (`period`)',
  'SELECT ''索引period已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 为 fa_promo_bonus 添加索引
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_bonus' AND INDEX_NAME = 'user_id';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_bonus` ADD KEY `user_id` (`user_id`)',
  'SELECT ''索引user_id已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_bonus' AND INDEX_NAME = 'period';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_bonus` ADD KEY `period` (`period`)',
  'SELECT ''索引period已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_promo_bonus' AND INDEX_NAME = 'status';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_promo_bonus` ADD KEY `status` (`status`)',
  'SELECT ''索引status已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 为 fa_reward_rule 添加索引
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_reward_rule' AND INDEX_NAME = 'scene';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_reward_rule` ADD KEY `scene` (`scene`)',
  'SELECT ''索引scene已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_reward_rule' AND INDEX_NAME = 'reward_type';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_reward_rule` ADD KEY `reward_type` (`reward_type`)',
  'SELECT ''索引reward_type已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_reward_rule' AND INDEX_NAME = 'status';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_reward_rule` ADD KEY `status` (`status`)',
  'SELECT ''索引status已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_reward_rule' AND INDEX_NAME = 'sort';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_reward_rule` ADD KEY `sort` (`sort`)',
  'SELECT ''索引sort已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 为 fa_profit_rule 添加索引
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_profit_rule' AND INDEX_NAME = 'level_diff';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_profit_rule` ADD KEY `level_diff` (`level_diff`)',
  'SELECT ''索引level_diff已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_profit_rule' AND INDEX_NAME = 'status';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_profit_rule` ADD KEY `status` (`status`)',
  'SELECT ''索引status已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fa_profit_rule' AND INDEX_NAME = 'sort';

SET @sql = IF(@index_exists = 0, 
  'ALTER TABLE `fa_profit_rule` ADD KEY `sort` (`sort`)',
  'SELECT ''索引sort已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =============================================
-- 修复完成
-- =============================================
SELECT '修复完成！请重新访问 test_upgrade.php 验证结果' as message;
