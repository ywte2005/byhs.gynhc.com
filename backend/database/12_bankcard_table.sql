-- 用户银行卡表
CREATE TABLE IF NOT EXISTS `fa_user_bankcard` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `bank_name` varchar(100) NOT NULL COMMENT '银行名称',
  `bank_code` varchar(20) NOT NULL DEFAULT '' COMMENT '银行代码',
  `card_no` varchar(30) NOT NULL COMMENT '卡号',
  `card_holder` varchar(50) NOT NULL COMMENT '持卡人',
  `bank_branch` varchar(200) DEFAULT '' COMMENT '开户支行',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认',
  `status` enum('normal','disabled') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户银行卡表';

-- 消息表
CREATE TABLE IF NOT EXISTS `fa_message` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `type` varchar(50) NOT NULL COMMENT '消息类型',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读',
  `extra` text COMMENT '扩展数据JSON',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_read` (`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';
