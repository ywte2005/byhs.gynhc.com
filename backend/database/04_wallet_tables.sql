-- =============================================
-- 钱包模块数据表
-- =============================================

-- 1. 用户钱包表
DROP TABLE IF EXISTS `fa_wallet`;
CREATE TABLE `fa_wallet` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额',
  `deposit` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '保证金',
  `frozen` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '冻结金额(已派发待完成)',
  `mutual_balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '互助余额',
  `total_income` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计收入',
  `total_withdraw` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计提现',
  `total_recharge` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计充值',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户钱包表';

-- 2. 钱包流水表
DROP TABLE IF EXISTS `fa_wallet_log`;
CREATE TABLE `fa_wallet_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `wallet_type` enum('balance','deposit','frozen','mutual') NOT NULL DEFAULT 'balance' COMMENT '钱包类型',
  `change_type` enum('income','expense','freeze','unfreeze') NOT NULL DEFAULT 'income' COMMENT '变动类型',
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '变动金额',
  `before_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '变动前金额',
  `after_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '变动后金额',
  `biz_type` varchar(50) NOT NULL DEFAULT '' COMMENT '业务类型',
  `biz_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '业务ID',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `wallet_type` (`wallet_type`),
  KEY `change_type` (`change_type`),
  KEY `biz_type` (`biz_type`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钱包流水表';

-- 3. 提现记录表
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
