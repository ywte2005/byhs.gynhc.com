-- 后台管理菜单补充
-- 执行前请先备份 fa_auth_rule 表

-- 消息管理菜单
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
('file', 0, 'message', '消息管理', 'fa fa-envelope', '', '消息管理', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 85, 'normal');

SET @message_pid = LAST_INSERT_ID();

INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
('file', @message_pid, 'message/index', '消息列表', 'fa fa-list', '', '', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @message_pid, 'message/add', '发送消息', 'fa fa-plus', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @message_pid, 'message/detail', '消息详情', 'fa fa-eye', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @message_pid, 'message/del', '删除消息', 'fa fa-trash', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @message_pid, 'message/markread', '标记已读', 'fa fa-check', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal');

-- 银行卡管理菜单（添加到钱包管理下）
-- 先查找钱包管理的pid
SET @wallet_pid = (SELECT id FROM `fa_auth_rule` WHERE `name` = 'wallet' LIMIT 1);

-- 如果钱包管理不存在，则创建
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) 
SELECT 'file', 0, 'wallet', '钱包管理', 'fa fa-money', '', '钱包管理', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 80, 'normal'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `fa_auth_rule` WHERE `name` = 'wallet');

SET @wallet_pid = (SELECT id FROM `fa_auth_rule` WHERE `name` = 'wallet' LIMIT 1);

INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
('file', @wallet_pid, 'wallet/bankcard', '银行卡管理', 'fa fa-credit-card', '', '', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal');

SET @bankcard_pid = LAST_INSERT_ID();

INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
('file', @bankcard_pid, 'wallet/bankcard/index', '银行卡列表', 'fa fa-list', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @bankcard_pid, 'wallet/bankcard/detail', '银行卡详情', 'fa fa-eye', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @bankcard_pid, 'wallet/bankcard/enable', '启用银行卡', 'fa fa-check', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @bankcard_pid, 'wallet/bankcard/disable', '禁用银行卡', 'fa fa-ban', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'),
('file', @bankcard_pid, 'wallet/bankcard/del', '删除银行卡', 'fa fa-trash', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal');

-- 给超级管理员组授权（假设超级管理员组ID为1）
-- 获取新增的规则ID
SET @new_rules = (SELECT GROUP_CONCAT(id) FROM `fa_auth_rule` WHERE `name` LIKE 'message%' OR `name` LIKE 'wallet/bankcard%');

-- 更新管理员组权限（需要手动在后台操作或执行以下SQL）
-- UPDATE `fa_auth_group` SET `rules` = CONCAT(`rules`, ',', @new_rules) WHERE `id` = 1;

-- 注意：执行完SQL后，需要在后台【权限管理】-【角色组】中为相应角色分配新菜单权限
