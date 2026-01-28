-- ----------------------------
-- Table structure for __PREFIX__weixin_config
-- ----------------------------
CREATE TABLE IF NOT EXISTS `__PREFIX__weixin_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '变量名',
  `group` varchar(30) NOT NULL DEFAULT '' COMMENT '分组',
  `value` text COMMENT '变量值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';

-- ----------------------------
-- Table structure for __PREFIX__weixin_reply
-- ----------------------------
CREATE TABLE IF NOT EXISTS `__PREFIX__weixin_reply` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '微信关键字回复id',
  `keyword` varchar(1000) NOT NULL DEFAULT '' COMMENT '关键字',
  `reply_type` enum('text','image','news','voice','video') NOT NULL DEFAULT 'text' COMMENT '回复类型:text=文本消息,image=图片消息,news=图文消息,voice=音频消息,video=视频消息',
  `matching_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '匹配方式：1-全匹配；2-模糊匹配',
  `content` text COMMENT '回复数据',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` BIGINT(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` BIGINT(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `reply_type` (`reply_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='微信回复表';

-- ----------------------------
-- Table structure for __PREFIX__weixin_news
-- ----------------------------
CREATE TABLE IF NOT EXISTS `__PREFIX__weixin_news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '图文消息表',
  `title` varchar(255) NOT NULL COMMENT '图文标题',
  `description` varchar(255) NOT NULL COMMENT '图文简介',
  `pic` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'URL',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` BIGINT(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` BIGINT(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='图文消息管理表';

-- ----------------------------
-- Table structure for __PREFIX__weixin_template
-- ----------------------------
CREATE TABLE IF NOT EXISTS `__PREFIX__weixin_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '模板id',
  `tempkey` char(50) NOT NULL DEFAULT '' COMMENT '模板编号',
  `name` char(100) NOT NULL DEFAULT '' COMMENT '模板名',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '回复内容',
  `tempid` char(100) DEFAULT NULL COMMENT '模板ID',
  `open_type` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '跳转类型：0网址1小程序',
  `open_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转网址',
  `appid` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序appid',
  `pagepath` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序页面path',
  `add_time` BIGINT(16) DEFAULT NULL COMMENT '添加时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tempkey` (`tempkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='微信模板';

-- ----------------------------
-- Table structure for __PREFIX__weixin_user
-- ----------------------------
CREATE TABLE IF NOT EXISTS `__PREFIX__weixin_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `openid` varchar(128) NOT NULL COMMENT '微信openid',
  `unionid` varchar(128) DEFAULT '' COMMENT '微信unionid',
  `tagid_list` varchar(256) DEFAULT NULL COMMENT '用户被打上的标签ID列表',
  `user_type` varchar(32) DEFAULT NULL DEFAULT 'wechat' COMMENT '用户类型',
  `createtime` BIGINT(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `openid` (`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户授权表';

-- ----------------------------
-- Table structure for __PREFIX__weixin_fans
-- ----------------------------
CREATE TABLE IF NOT EXISTS `__PREFIX__weixin_fans` (
  `fans_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '粉丝ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称',
  `nickname_decode` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称编码',
  `headimgurl` varchar(500) NOT NULL DEFAULT '' COMMENT '头像',
  `sex` smallint(6) NOT NULL DEFAULT '1' COMMENT '性别',
  `language` varchar(20) NOT NULL DEFAULT '' COMMENT '用户语言',
  `country` varchar(60) NOT NULL DEFAULT '' COMMENT '国家',
  `province` varchar(255) NOT NULL DEFAULT '' COMMENT '省',
  `city` varchar(255) NOT NULL DEFAULT '' COMMENT '城市',
  `district` varchar(255) NOT NULL DEFAULT '' COMMENT '行政区/县',
  `openid` varchar(255) NOT NULL DEFAULT '' COMMENT '用户的标识，对当前公众号唯一     用户的唯一身份ID',
  `unionid` varchar(255) NOT NULL DEFAULT '' COMMENT '粉丝unionid',
  `groupid` int(11) NOT NULL DEFAULT '0' COMMENT '粉丝所在组id',
  `is_subscribe` bigint(1) NOT NULL DEFAULT '1' COMMENT '是否订阅',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `subscribe_time` BIGINT(16) DEFAULT NULL COMMENT '关注时间',
  `subscribe_scene` varchar(100) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源',
  `unsubscribe_time` BIGINT(16) DEFAULT NULL COMMENT '取消关注时间',
  `update_date` BIGINT(16) DEFAULT NULL COMMENT '粉丝信息最后更新时间',
  `tagid_list` varchar(255) NOT NULL DEFAULT '' COMMENT '用户被打上的标签ID列表',
  `subscribe_scene_name` varchar(50) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源名称',
  `qr_scene` varchar(255) NOT NULL DEFAULT '' COMMENT 'qr_scene',
  `qr_scene_str` varchar(255) NOT NULL DEFAULT '' COMMENT 'qr_scene_str',
  PRIMARY KEY (`fans_id`) USING BTREE,
  KEY `idx_wxfans` (`unionid`,`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信粉丝列表';


--
-- 3.0.0
--
BEGIN;
ALTER TABLE `__PREFIX__weixin_config` DROP `tip`;
ALTER TABLE `__PREFIX__weixin_config` DROP `title`;
ALTER TABLE `__PREFIX__weixin_config` DROP `type`;
ALTER TABLE `__PREFIX__weixin_config` DROP `content`;
ALTER TABLE `__PREFIX__weixin_config` DROP `rule`;
ALTER TABLE `__PREFIX__weixin_config` DROP `extend`;

ALTER TABLE `__PREFIX__weixin_template` ADD `open_type` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '跳转类型：0网址1小程序' AFTER `tempid`;
ALTER TABLE `__PREFIX__weixin_template` ADD `open_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转网址' AFTER `open_type`;
ALTER TABLE `__PREFIX__weixin_template` ADD `appid` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序appid' AFTER `open_url`;
ALTER TABLE `__PREFIX__weixin_template` ADD `pagepath` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序页面path' AFTER `appid`;

ALTER TABLE `__PREFIX__weixin_user` ADD `user_id` INT(10) NOT NULL COMMENT '会员id' AFTER `openid`;
UPDATE      `__PREFIX__weixin_user` SET user_id = uid;
ALTER TABLE `__PREFIX__weixin_user` CHANGE `uid` `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '微信用户id';
ALTER TABLE `__PREFIX__weixin_user` DROP `routine_openid`;
ALTER TABLE `__PREFIX__weixin_user` DROP `nickname`;
ALTER TABLE `__PREFIX__weixin_user` DROP `headimgurl`;
ALTER TABLE `__PREFIX__weixin_user` DROP `sex`;
ALTER TABLE `__PREFIX__weixin_user` DROP `city`;
ALTER TABLE `__PREFIX__weixin_user` DROP `language`;
ALTER TABLE `__PREFIX__weixin_user` DROP `province`;
ALTER TABLE `__PREFIX__weixin_user` DROP `country`;
ALTER TABLE `__PREFIX__weixin_user` DROP `remark`;
ALTER TABLE `__PREFIX__weixin_user` DROP `groupid`;
ALTER TABLE `__PREFIX__weixin_user` DROP `subscribe`;
ALTER TABLE `__PREFIX__weixin_user` DROP `subscribe_time`;
ALTER TABLE `__PREFIX__weixin_user` DROP `parent_id`;
ALTER TABLE `__PREFIX__weixin_user` DROP `session_key`;

ALTER TABLE `__PREFIX__weixin_reply` ADD `matching_type` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT '匹配方式：1-全匹配；2-模糊匹配' AFTER `reply_type`;
COMMIT;

--
-- 3.0.3
--
BEGIN;
ALTER TABLE `__PREFIX___weixin_fans` DROP INDEX `IDX_ns_weixin_fans`, ADD INDEX `idx_wxfans` (`unionid`, `openid`) USING BTREE;
COMMIT;