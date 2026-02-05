-- =============================================
-- 商户模块数据表
-- =============================================

-- 1. 商户信息表
DROP TABLE IF EXISTS `fa_merchant`;
CREATE TABLE `fa_merchant` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `merchant_no` varchar(32) NOT NULL DEFAULT '' COMMENT '商户编号',
  `type` enum('personal','enterprise') NOT NULL DEFAULT 'personal' COMMENT '商户类型:personal=个人,enterprise=企业',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '商户名称',
  `legal_name` varchar(50) NOT NULL DEFAULT '' COMMENT '法人姓名',
  `id_card` varchar(20) NOT NULL DEFAULT '' COMMENT '身份证号',
  `id_card_front` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `id_card_back` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证反面',
  `business_license` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `business_license_no` varchar(50) NOT NULL DEFAULT '' COMMENT '统一社会信用代码',
  `bank_name` varchar(100) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_account` varchar(30) NOT NULL DEFAULT '' COMMENT '银行账号',
  `bank_branch` varchar(200) NOT NULL DEFAULT '' COMMENT '开户支行',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `contact_address` varchar(255) NOT NULL DEFAULT '' COMMENT '联系地址',
  `category` varchar(50) NOT NULL DEFAULT '' COMMENT '经营类目',
  `entry_fee` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '入驻费',
  `status` enum('pending','approved','rejected','disabled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `approved_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核通过时间',
  `reject_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '驳回原因',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `merchant_no` (`merchant_no`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户信息表';

-- 2. 商户审核记录表
DROP TABLE IF EXISTS `fa_merchant_audit`;
CREATE TABLE `fa_merchant_audit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `merchant_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `operator_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作员ID',
  `operator_name` varchar(50) NOT NULL DEFAULT '' COMMENT '操作员姓名',
  `reason` varchar(255) NOT NULL DEFAULT '' COMMENT '审核意见',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `merchant_id` (`merchant_id`),
  KEY `user_id` (`user_id`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户审核记录表';
