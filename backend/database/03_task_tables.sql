-- =============================================
-- 任务模块数据表
-- =============================================

-- 1. 互助主任务表
DROP TABLE IF EXISTS `fa_mutual_task`;
CREATE TABLE `fa_mutual_task` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '发起用户ID',
  `task_no` varchar(32) NOT NULL DEFAULT '' COMMENT '任务编号',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '任务标题',
  `category` varchar(50) NOT NULL DEFAULT '' COMMENT '任务类目',
  `platform` varchar(50) NOT NULL DEFAULT '' COMMENT '平台类型',
  `total_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '目标总金额',
  `completed_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '已完成金额',
  `deposit_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '缴纳保证金',
  `frozen_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '冻结金额',
  `service_fee_rate` decimal(5,4) unsigned NOT NULL DEFAULT '0.0500' COMMENT '服务费率',
  `sub_task_min` decimal(10,2) unsigned NOT NULL DEFAULT '2000.00' COMMENT '子任务最小金额',
  `sub_task_max` decimal(10,2) unsigned NOT NULL DEFAULT '5000.00' COMMENT '子任务最大金额',
  `channel_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支付通道ID',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `time_limit` int(10) unsigned NOT NULL DEFAULT '3600' COMMENT '完成时限(秒)',
  `proof_type` varchar(50) NOT NULL DEFAULT 'image' COMMENT '凭证类型',
  `requirements` text COMMENT '任务要求',
  `status` enum('pending','approved','running','paused','completed','cancelled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_no` (`task_no`),
  KEY `user_id` (`user_id`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='互助主任务表';

-- 2. 子任务表
DROP TABLE IF EXISTS `fa_sub_task`;
CREATE TABLE `fa_sub_task` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `task_id` int(10) unsigned NOT NULL COMMENT '主任务ID',
  `task_no` varchar(32) NOT NULL DEFAULT '' COMMENT '子任务编号',
  `from_user_id` int(10) unsigned NOT NULL COMMENT '发起方用户ID',
  `to_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行方用户ID',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '刷单金额',
  `commission` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '佣金',
  `service_fee` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '服务费',
  `proof_image` varchar(500) NOT NULL DEFAULT '' COMMENT '支付凭证图片',
  `proof_desc` varchar(500) NOT NULL DEFAULT '' COMMENT '凭证说明',
  `third_order_no` varchar(64) NOT NULL DEFAULT '' COMMENT '第三方订单号',
  `status` enum('pending','assigned','accepted','paid','verified','completed','failed','cancelled') NOT NULL DEFAULT 'pending' COMMENT '状态',
  `assigned_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '派发时间',
  `accepted_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '接单时间',
  `paid_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `completed_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '完成时间',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_no` (`task_no`),
  KEY `task_id` (`task_id`),
  KEY `from_user_id` (`from_user_id`),
  KEY `to_user_id` (`to_user_id`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='子任务表';
