-- =============================================
-- 商户进件申请表
-- 用于存储商户的支付通道进件申请
-- =============================================

-- 进件申请表
DROP TABLE IF EXISTS `fa_merchant_application`;
CREATE TABLE `fa_merchant_application` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `merchant_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `application_no` varchar(32) NOT NULL DEFAULT '' COMMENT '进件编号',
  `channel` varchar(50) NOT NULL DEFAULT '' COMMENT '支付通道:wechat=微信,alipay=支付宝,unionpay=银联',
  `type` enum('personal','individual','enterprise') NOT NULL DEFAULT 'individual' COMMENT '主体类型:personal=个人,individual=个体,enterprise=企业',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '主体名称',
  `id_card` varchar(50) NOT NULL DEFAULT '' COMMENT '证件号码(身份证/统一社会信用代码)',
  `contact_name` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人姓名',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `category` varchar(100) NOT NULL DEFAULT '' COMMENT '经营类目',
  `category_code` varchar(50) NOT NULL DEFAULT '' COMMENT '经营类目代码',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '经营地址',
  `business_license` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `id_card_front` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `id_card_back` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证反面',
  `shop_front` varchar(255) NOT NULL DEFAULT '' COMMENT '门头照',
  `other_files` varchar(500) NOT NULL DEFAULT '' COMMENT '其他附件',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending' COMMENT '状态:pending=待审核,approved=已通过,rejected=已驳回',
  `reject_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '驳回原因',
  `approved_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核通过时间',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核管理员ID',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_no` (`application_no`),
  KEY `merchant_id` (`merchant_id`),
  KEY `user_id` (`user_id`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户进件申请表';
