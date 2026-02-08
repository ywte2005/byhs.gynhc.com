-- =============================================
-- 商户进件管理菜单
-- =============================================

-- 添加进件管理菜单（假设商户管理的父ID为已存在的ID，这里使用占位符）
-- 请根据实际情况调整 pid 值

-- 查找商户管理的菜单ID
-- SELECT id FROM fa_auth_rule WHERE name = 'merchant' LIMIT 1;

-- 进件管理主菜单
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) 
SELECT 'menu', id, 'merchant/application', '进件管理', 'fa fa-file-text-o', '', '商户进件申请管理', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'
FROM `fa_auth_rule` WHERE `name` = 'merchant' LIMIT 1;

-- 进件管理子菜单
INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) 
SELECT 'file', id, 'merchant/application/index', '查看', 'fa fa-circle-o', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'
FROM `fa_auth_rule` WHERE `name` = 'merchant/application' LIMIT 1;

INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) 
SELECT 'file', id, 'merchant/application/detail', '详情', 'fa fa-circle-o', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'
FROM `fa_auth_rule` WHERE `name` = 'merchant/application' LIMIT 1;

INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) 
SELECT 'file', id, 'merchant/application/approve', '审核通过', 'fa fa-circle-o', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'
FROM `fa_auth_rule` WHERE `name` = 'merchant/application' LIMIT 1;

INSERT INTO `fa_auth_rule` (`type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) 
SELECT 'file', id, 'merchant/application/reject', '审核驳回', 'fa fa-circle-o', '', '', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 'normal'
FROM `fa_auth_rule` WHERE `name` = 'merchant/application' LIMIT 1;
