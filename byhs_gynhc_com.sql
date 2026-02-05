-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2026-02-03 10:20:37
-- 服务器版本： 5.7.43-log
-- PHP 版本： 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `byhs_gynhc_com`
--

-- --------------------------------------------------------

--
-- 表的结构 `fa_admin`
--

CREATE TABLE `fa_admin` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `username` varchar(20) DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) DEFAULT '' COMMENT '昵称',
  `password` varchar(32) DEFAULT '' COMMENT '密码',
  `salt` varchar(30) DEFAULT '' COMMENT '密码盐',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `email` varchar(100) DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) DEFAULT '' COMMENT '手机号码',
  `loginfailure` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '失败次数',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) DEFAULT NULL COMMENT '登录IP',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(59) DEFAULT '' COMMENT 'Session标识',
  `status` varchar(30) NOT NULL DEFAULT 'normal' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

--
-- 转存表中的数据 `fa_admin`
--

INSERT INTO `fa_admin` (`id`, `username`, `nickname`, `password`, `salt`, `avatar`, `email`, `mobile`, `loginfailure`, `logintime`, `loginip`, `createtime`, `updatetime`, `token`, `status`) VALUES
(1, 'admin', 'Admin', 'ad03dc7ab8330457346e9421c56433cc', '2cbc73', '/uploads/20260122/3c6dc05388bec4a18110fb88563936eb.jpeg', 'admin@admin.com', '', 0, 1770085095, '89.185.27.147', 1491635035, 1770085095, '250e9460-400b-490e-8531-106432c95afd', 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `fa_admin_log`
--

CREATE TABLE `fa_admin_log` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `username` varchar(30) DEFAULT '' COMMENT '管理员名字',
  `url` varchar(1500) DEFAULT '' COMMENT '操作页面',
  `title` varchar(100) DEFAULT '' COMMENT '日志标题',
  `content` longtext NOT NULL COMMENT '内容',
  `ip` varchar(50) DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) DEFAULT '' COMMENT 'User-Agent',
  `createtime` bigint(16) DEFAULT NULL COMMENT '操作时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员日志表';

--
-- 转存表中的数据 `fa_admin_log`
--

INSERT INTO `fa_admin_log` (`id`, `admin_id`, `username`, `url`, `title`, `content`, `ip`, `useragent`, `createtime`) VALUES
(1, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013586),
(2, 1, 'admin', '/a.php/addon/install', '插件管理', '{\"name\":\"epay\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"1.3.15\",\"faversion\":\"1.6.1.20250430\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013615),
(3, 1, 'admin', '/a.php/addon/state', '插件管理 / 禁用启用', '{\"name\":\"epay\",\"action\":\"enable\",\"force\":\"0\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013615),
(4, 1, 'admin', '/a.php/addon/install', '插件管理', '{\"name\":\"weixin\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"3.0.6\",\"faversion\":\"1.6.1.20250430\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013663),
(5, 1, 'admin', '/a.php/addon/state', '插件管理 / 禁用启用', '{\"name\":\"weixin\",\"action\":\"enable\",\"force\":\"0\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013664),
(6, 1, 'admin', '/a.php/addon/install', '插件管理', '{\"name\":\"summernote\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"1.2.2\",\"faversion\":\"1.6.1.20250430\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013678),
(7, 1, 'admin', '/a.php/addon/state', '插件管理 / 禁用启用', '{\"name\":\"summernote\",\"action\":\"enable\",\"force\":\"0\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769013678),
(8, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769043479),
(9, 1, 'admin', '/a.php/task/mutualtask/dispatchAll', '任务管理 / 主任务列表', '', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769043553),
(10, 1, 'admin', '/a.php/task/mutualtask/approve', '任务管理 / 主任务列表', '{\"ids\":\"3\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769043567),
(11, 1, 'admin', '/a.php/task/mutualtask/approve', '任务管理 / 主任务列表', '{\"ids\":\"3\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769043584),
(12, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769067909),
(13, 1, 'admin', '/a.php/addon/install', '插件管理', '{\"name\":\"sdtheme\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"1.0.0\",\"faversion\":\"1.6.1.20250430\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769068019),
(14, 1, 'admin', '/a.php/addon/state', '插件管理 / 禁用启用', '{\"name\":\"sdtheme\",\"action\":\"enable\",\"force\":\"0\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769068019),
(15, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769069754),
(16, 1, 'admin', '/a.php/index/login?url=/a.php/promo/performance?ref=addtabs', '登录', '{\"url\":\"\\/a.php\\/promo\\/performance?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769069810),
(17, 1, 'admin', '/a.php/general.config/edit', '常规管理 / 系统配置 / 编辑', '{\"__token__\":\"***\",\"row\":{\"name\":\"互助平台\",\"beian\":\"\",\"version\":\"1.0.3\",\"timezone\":\"Asia\\/Shanghai\",\"forbiddenip\":\"\",\"languages\":\"{&quot;backend&quot;:&quot;zh-cn&quot;,&quot;frontend&quot;:&quot;zh-cn&quot;}\",\"fixedpage\":\"dashboard\"}}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769070336),
(18, 1, 'admin', '/a.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"4\",\"params\":\"ismenu=0\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769070378),
(19, 1, 'admin', '/a.php/auth/rule/edit/ids/161?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"weixin\",\"title\":\"公众号管理\",\"url\":\"\",\"icon\":\"fa fa-weixin\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"161\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769070387),
(20, 1, 'admin', '/a.php/task/mutualtask/approve/ids/3', '任务管理 / 主任务列表 / 审核通过', '{\"ids\":\"3\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769070731),
(21, 1, 'admin', '/a.php/ajax/upload', '', '{\"category\":\"\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071473),
(22, 1, 'admin', '/a.php/ajax/upload', '', '{\"category\":\"\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071479),
(23, 1, 'admin', '/a.php/general.profile/update', '常规管理 / 个人资料 / 更新个人信息', '{\"__token__\":\"***\",\"row\":{\"avatar\":\"\\/uploads\\/20260122\\/fa7bee50fc7af6fdf31694cee4b9972b.png\",\"email\":\"admin@admin.com\",\"nickname\":\"Admin\",\"password\":\"***\"}}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071482),
(24, 1, 'admin', '/a.php/ajax/upload', '', '{\"category\":\"\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071507),
(25, 1, 'admin', '/a.php/general.profile/update', '常规管理 / 个人资料 / 更新个人信息', '{\"__token__\":\"***\",\"row\":{\"avatar\":\"\\/uploads\\/20260122\\/3c6dc05388bec4a18110fb88563936eb.jpeg\",\"email\":\"admin@admin.com\",\"nickname\":\"Admin\",\"password\":\"***\"}}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071509),
(26, 1, 'admin', '/a.php/ajax/upload', '', '{\"category\":\"\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071545),
(27, 1, 'admin', '/a.php/ajax/upload', '', '{\"category\":\"\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071585),
(28, 1, 'admin', '/a.php/ajax/upload', '', '{\"category\":\"\"}', '111.85.26.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769071608),
(29, 1, 'admin', '/a.php/index/login?url=/a.php/wallet/wallet?ref=addtabs', '登录', '{\"url\":\"\\/a.php\\/wallet\\/wallet?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166348),
(30, 1, 'admin', '/a.php/task/mutualtask/approve/ids/3', '任务管理 / 主任务列表', '{\"ids\":\"3\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166413),
(31, 1, 'admin', '/a.php/merchant/merchant/disable/ids/1', '商户管理 / 商户列表', '{\"ids\":\"1\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166594),
(32, 1, 'admin', '/a.php/merchant/merchant/disable/ids/1', '商户管理 / 商户列表', '{\"ids\":\"1\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166597),
(33, 1, 'admin', '/a.php/task/mutualtask/approve/ids/3', '任务管理 / 主任务列表', '{\"ids\":\"3\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166618),
(34, 1, 'admin', '/a.php/promo/level/edit/ids/5?dialog=1', '推广管理 / 等级配置', '{\"dialog\":\"1\",\"row\":{\"name\":\"钻石会员\",\"sort\":\"4\",\"upgrade_type\":\"performance\",\"upgrade_price\":\"30000.00\",\"personal_performance_min\":\"1500000.00\",\"team_performance_min\":\"10000000.00\",\"direct_invite_min\":\"50\",\"commission_rate\":\"0.0080\",\"status\":\"normal\"},\"ids\":\"5\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166738),
(35, 1, 'admin', '/a.php/promo/level/edit/ids/4?dialog=1', '推广管理 / 等级配置', '{\"dialog\":\"1\",\"row\":{\"name\":\"铂金会员\",\"sort\":\"3\",\"upgrade_type\":\"performance\",\"upgrade_price\":\"10000.00\",\"personal_performance_min\":\"500000.00\",\"team_performance_min\":\"2000000.00\",\"direct_invite_min\":\"20\",\"commission_rate\":\"0.0050\",\"status\":\"normal\"},\"ids\":\"4\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769166745),
(36, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.196', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769237072),
(37, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '111.85.26.195', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769362181),
(38, 1, 'admin', '/a.php/promo/level/edit/ids/5?dialog=1', '推广管理 / 等级配置', '{\"dialog\":\"1\",\"row\":{\"name\":\"钻石会员\",\"sort\":\"4\",\"upgrade_type\":\"performance\",\"upgrade_price\":\"30000.00\",\"personal_performance_min\":\"1500000.00\",\"team_performance_min\":\"10000000.00\",\"direct_invite_min\":\"50\",\"commission_rate\":\"0.0080\",\"status\":\"normal\"},\"ids\":\"5\"}', '111.85.26.195', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769362209),
(39, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '117.188.14.231', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769484928),
(40, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '142.91.99.238', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769484946),
(41, 1, 'admin', '/a.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '89.185.27.147', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1770008303),
(42, 1, 'admin', '/a.php/index/login?url=/a.php/merchant/merchant?addtabs=1', '登录', '{\"url\":\"\\/a.php\\/merchant\\/merchant?addtabs=1\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '89.185.27.147', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1770036987),
(43, 1, 'admin', '/a.php/index/login?url=/a.php/merchant/merchant/detail/ids/3?addtabs=1', '登录', '{\"url\":\"\\/a.php\\/merchant\\/merchant\\/detail\\/ids\\/3?addtabs=1\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '89.185.27.147', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1770085095);

-- --------------------------------------------------------

--
-- 表的结构 `fa_area`
--

CREATE TABLE `fa_area` (
  `id` int(10) NOT NULL COMMENT 'ID',
  `pid` int(10) DEFAULT NULL COMMENT '父id',
  `shortname` varchar(100) DEFAULT NULL COMMENT '简称',
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `mergename` varchar(255) DEFAULT NULL COMMENT '全称',
  `level` tinyint(4) DEFAULT NULL COMMENT '层级:1=省,2=市,3=区/县',
  `pinyin` varchar(100) DEFAULT NULL COMMENT '拼音',
  `code` varchar(100) DEFAULT NULL COMMENT '长途区号',
  `zip` varchar(100) DEFAULT NULL COMMENT '邮编',
  `first` varchar(50) DEFAULT NULL COMMENT '首字母',
  `lng` varchar(100) DEFAULT NULL COMMENT '经度',
  `lat` varchar(100) DEFAULT NULL COMMENT '纬度'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='地区表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_attachment`
--

CREATE TABLE `fa_attachment` (
  `id` int(20) UNSIGNED NOT NULL COMMENT 'ID',
  `category` varchar(50) DEFAULT '' COMMENT '类别',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `url` varchar(255) DEFAULT '' COMMENT '物理路径',
  `imagewidth` int(10) UNSIGNED DEFAULT '0' COMMENT '宽度',
  `imageheight` int(10) UNSIGNED DEFAULT '0' COMMENT '高度',
  `imagetype` varchar(30) DEFAULT '' COMMENT '图片类型',
  `imageframes` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '图片帧数',
  `filename` varchar(100) DEFAULT '' COMMENT '文件名称',
  `filesize` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '文件大小',
  `mimetype` varchar(100) DEFAULT '' COMMENT 'mime类型',
  `extparam` varchar(255) DEFAULT '' COMMENT '透传数据',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建日期',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `uploadtime` bigint(16) DEFAULT NULL COMMENT '上传时间',
  `storage` varchar(100) NOT NULL DEFAULT 'local' COMMENT '存储位置',
  `sha1` varchar(40) DEFAULT '' COMMENT '文件 sha1编码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='附件表';

--
-- 转存表中的数据 `fa_attachment`
--

INSERT INTO `fa_attachment` (`id`, `category`, `admin_id`, `user_id`, `url`, `imagewidth`, `imageheight`, `imagetype`, `imageframes`, `filename`, `filesize`, `mimetype`, `extparam`, `createtime`, `updatetime`, `uploadtime`, `storage`, `sha1`) VALUES
(1, '', 1, 0, '/assets/img/qrcode.png', 150, 150, 'png', 0, 'qrcode.png', 21859, 'image/png', '', 1491635035, 1491635035, 1491635035, 'local', '17163603d0263e4838b9387ff2cd4877e8b018f6'),
(2, '', 1, 0, '/uploads/20260122/e01d83ec44f5b6bb9791babf17ff7d13.png', 3068, 16385, 'png', 0, '电商平台.png', 3529808, 'image/png', '', 1769071473, 1769071473, 1769071473, 'local', 'aa701c561e567038ef1772d3c03464b3960fb4f1'),
(3, '', 1, 0, '/uploads/20260122/fa7bee50fc7af6fdf31694cee4b9972b.png', 200, 200, 'png', 0, '啤酒.png', 2892, 'image/png', '', 1769071479, 1769071479, 1769071479, 'local', '0ae706fe828d332efb1d7f362937f9cfa21e71c7'),
(4, '', 1, 0, '/uploads/20260122/3c6dc05388bec4a18110fb88563936eb.jpeg', 500, 500, 'jpeg', 0, 'ecf8f4ea1fc93d19b5e53afdcf1be041.jpeg', 19954, 'image/jpeg', '', 1769071507, 1769071507, 1769071507, 'local', 'b2fae927eaab292007230c8c5827f0f640695dfb'),
(5, '', 1, 0, '/uploads/20260122/f5641c49313e077c0f9380a8e8e2a3bd.jpg', 430, 430, 'jpg', 0, '202577.jpg', 29692, 'image/jpeg', '', 1769071545, 1769071545, 1769071545, 'local', '56fcd91d41c76118af00b852ea64c057d76e74d1'),
(6, '', 1, 0, '/uploads/20260122/d5483c86eabfdce11d988a144e0fb557.png', 1533, 752, 'png', 0, 'blank-view.png', 47560, 'image/png', '', 1769071585, 1769071585, 1769071585, 'local', '039674621765021ceca62aa3c538442313ce4c44'),
(7, '', 1, 0, '/uploads/20260122/88bbbe2e6045bf23eaa2acca639e6e7f.png', 1861, 1090, 'png', 0, '微信截图_20240822140711.png', 419771, 'image/png', '', 1769071608, 1769071608, 1769071608, 'local', '053cd42a34c1a9b3200656aa28dccc7d1d34be71');

-- --------------------------------------------------------

--
-- 表的结构 `fa_auth_group`
--

CREATE TABLE `fa_auth_group` (
  `id` int(10) UNSIGNED NOT NULL,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父组别',
  `name` varchar(100) DEFAULT '' COMMENT '组名',
  `rules` text NOT NULL COMMENT '规则ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `status` varchar(30) DEFAULT '' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分组表';

--
-- 转存表中的数据 `fa_auth_group`
--

INSERT INTO `fa_auth_group` (`id`, `pid`, `name`, `rules`, `createtime`, `updatetime`, `status`) VALUES
(1, 0, 'Admin group', '*', 1491635035, 1491635035, 'normal'),
(2, 1, 'Second group', '13,14,16,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,40,41,42,43,44,45,46,47,48,49,50,55,56,57,58,59,60,61,62,63,64,65,1,9,10,11,7,6,8,2,4,5', 1491635035, 1491635035, 'normal'),
(3, 2, 'Third group', '1,4,9,10,11,13,14,15,16,17,40,41,42,43,44,45,46,47,48,49,50,55,56,57,58,59,60,61,62,63,64,65,5', 1491635035, 1491635035, 'normal'),
(4, 1, 'Second group 2', '1,4,13,14,15,16,17,55,56,57,58,59,60,61,62,63,64,65', 1491635035, 1491635035, 'normal'),
(5, 2, 'Third group 2', '1,2,6,7,8,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34', 1491635035, 1491635035, 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `fa_auth_group_access`
--

CREATE TABLE `fa_auth_group_access` (
  `uid` int(10) UNSIGNED NOT NULL COMMENT '会员ID',
  `group_id` int(10) UNSIGNED NOT NULL COMMENT '级别ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限分组表';

--
-- 转存表中的数据 `fa_auth_group_access`
--

INSERT INTO `fa_auth_group_access` (`uid`, `group_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- 表的结构 `fa_auth_rule`
--

CREATE TABLE `fa_auth_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` enum('menu','file') NOT NULL DEFAULT 'file' COMMENT 'menu为菜单,file为权限节点',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父ID',
  `name` varchar(100) DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) DEFAULT '' COMMENT '规则名称',
  `icon` varchar(50) DEFAULT '' COMMENT '图标',
  `url` varchar(255) DEFAULT '' COMMENT '规则URL',
  `condition` varchar(255) DEFAULT '' COMMENT '条件',
  `remark` varchar(255) DEFAULT '' COMMENT '备注',
  `ismenu` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否为菜单',
  `menutype` enum('addtabs','blank','dialog','ajax') DEFAULT NULL COMMENT '菜单类型',
  `extend` varchar(255) DEFAULT '' COMMENT '扩展属性',
  `py` varchar(30) DEFAULT '' COMMENT '拼音首字母',
  `pinyin` varchar(100) DEFAULT '' COMMENT '拼音',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) DEFAULT '' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='节点表';

--
-- 转存表中的数据 `fa_auth_rule`
--

INSERT INTO `fa_auth_rule` (`id`, `type`, `pid`, `name`, `title`, `icon`, `url`, `condition`, `remark`, `ismenu`, `menutype`, `extend`, `py`, `pinyin`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
(1, 'file', 0, 'dashboard', 'Dashboard', 'fa fa-dashboard', '', '', 'Dashboard tips', 1, NULL, '', 'kzt', 'kongzhitai', 1491635035, 1491635035, 143, 'normal'),
(2, 'file', 0, 'general', 'General', 'fa fa-cogs', '', '', '', 1, NULL, '', 'cggl', 'changguiguanli', 1491635035, 1491635035, 137, 'normal'),
(3, 'file', 0, 'category', 'Category', 'fa fa-leaf', '', '', 'Category tips', 0, NULL, '', 'flgl', 'fenleiguanli', 1491635035, 1491635035, 119, 'normal'),
(4, 'file', 0, 'addon', 'Addon', 'fa fa-rocket', '', '', 'Addon tips', 0, NULL, '', 'cjgl', 'chajianguanli', 1491635035, 1769070378, 0, 'normal'),
(5, 'file', 0, 'auth', 'Auth', 'fa fa-group', '', '', '', 1, NULL, '', 'qxgl', 'quanxianguanli', 1491635035, 1491635035, 99, 'normal'),
(6, 'file', 2, 'general/config', 'Config', 'fa fa-cog', '', '', 'Config tips', 1, NULL, '', 'xtpz', 'xitongpeizhi', 1491635035, 1491635035, 60, 'normal'),
(7, 'file', 2, 'general/attachment', 'Attachment', 'fa fa-file-image-o', '', '', 'Attachment tips', 1, NULL, '', 'fjgl', 'fujianguanli', 1491635035, 1491635035, 53, 'normal'),
(8, 'file', 2, 'general/profile', 'Profile', 'fa fa-user', '', '', '', 1, NULL, '', 'grzl', 'gerenziliao', 1491635035, 1491635035, 34, 'normal'),
(9, 'file', 5, 'auth/admin', 'Admin', 'fa fa-user', '', '', 'Admin tips', 1, NULL, '', 'glygl', 'guanliyuanguanli', 1491635035, 1491635035, 118, 'normal'),
(10, 'file', 5, 'auth/adminlog', 'Admin log', 'fa fa-list-alt', '', '', 'Admin log tips', 1, NULL, '', 'glyrz', 'guanliyuanrizhi', 1491635035, 1491635035, 113, 'normal'),
(11, 'file', 5, 'auth/group', 'Group', 'fa fa-group', '', '', 'Group tips', 1, NULL, '', 'jsz', 'juesezu', 1491635035, 1491635035, 109, 'normal'),
(12, 'file', 5, 'auth/rule', 'Rule', 'fa fa-bars', '', '', 'Rule tips', 1, NULL, '', 'cdgz', 'caidanguize', 1491635035, 1491635035, 104, 'normal'),
(13, 'file', 1, 'dashboard/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 136, 'normal'),
(14, 'file', 1, 'dashboard/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 135, 'normal'),
(15, 'file', 1, 'dashboard/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 133, 'normal'),
(16, 'file', 1, 'dashboard/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 134, 'normal'),
(17, 'file', 1, 'dashboard/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 132, 'normal'),
(18, 'file', 6, 'general/config/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 52, 'normal'),
(19, 'file', 6, 'general/config/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 51, 'normal'),
(20, 'file', 6, 'general/config/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 50, 'normal'),
(21, 'file', 6, 'general/config/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 49, 'normal'),
(22, 'file', 6, 'general/config/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 48, 'normal'),
(23, 'file', 7, 'general/attachment/index', 'View', 'fa fa-circle-o', '', '', 'Attachment tips', 0, NULL, '', '', '', 1491635035, 1491635035, 59, 'normal'),
(24, 'file', 7, 'general/attachment/select', 'Select attachment', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 58, 'normal'),
(25, 'file', 7, 'general/attachment/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 57, 'normal'),
(26, 'file', 7, 'general/attachment/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 56, 'normal'),
(27, 'file', 7, 'general/attachment/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 55, 'normal'),
(28, 'file', 7, 'general/attachment/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 54, 'normal'),
(29, 'file', 8, 'general/profile/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 33, 'normal'),
(30, 'file', 8, 'general/profile/update', 'Update profile', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 32, 'normal'),
(31, 'file', 8, 'general/profile/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 31, 'normal'),
(32, 'file', 8, 'general/profile/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 30, 'normal'),
(33, 'file', 8, 'general/profile/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 29, 'normal'),
(34, 'file', 8, 'general/profile/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 28, 'normal'),
(35, 'file', 3, 'category/index', 'View', 'fa fa-circle-o', '', '', 'Category tips', 0, NULL, '', '', '', 1491635035, 1491635035, 142, 'normal'),
(36, 'file', 3, 'category/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 141, 'normal'),
(37, 'file', 3, 'category/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 140, 'normal'),
(38, 'file', 3, 'category/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 139, 'normal'),
(39, 'file', 3, 'category/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 138, 'normal'),
(40, 'file', 9, 'auth/admin/index', 'View', 'fa fa-circle-o', '', '', 'Admin tips', 0, NULL, '', '', '', 1491635035, 1491635035, 117, 'normal'),
(41, 'file', 9, 'auth/admin/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 116, 'normal'),
(42, 'file', 9, 'auth/admin/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 115, 'normal'),
(43, 'file', 9, 'auth/admin/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 114, 'normal'),
(44, 'file', 10, 'auth/adminlog/index', 'View', 'fa fa-circle-o', '', '', 'Admin log tips', 0, NULL, '', '', '', 1491635035, 1491635035, 112, 'normal'),
(45, 'file', 10, 'auth/adminlog/detail', 'Detail', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 111, 'normal'),
(46, 'file', 10, 'auth/adminlog/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 110, 'normal'),
(47, 'file', 11, 'auth/group/index', 'View', 'fa fa-circle-o', '', '', 'Group tips', 0, NULL, '', '', '', 1491635035, 1491635035, 108, 'normal'),
(48, 'file', 11, 'auth/group/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 107, 'normal'),
(49, 'file', 11, 'auth/group/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 106, 'normal'),
(50, 'file', 11, 'auth/group/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 105, 'normal'),
(51, 'file', 12, 'auth/rule/index', 'View', 'fa fa-circle-o', '', '', 'Rule tips', 0, NULL, '', '', '', 1491635035, 1491635035, 103, 'normal'),
(52, 'file', 12, 'auth/rule/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 102, 'normal'),
(53, 'file', 12, 'auth/rule/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 101, 'normal'),
(54, 'file', 12, 'auth/rule/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 100, 'normal'),
(55, 'file', 4, 'addon/index', 'View', 'fa fa-circle-o', '', '', 'Addon tips', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(56, 'file', 4, 'addon/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(57, 'file', 4, 'addon/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(58, 'file', 4, 'addon/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(59, 'file', 4, 'addon/downloaded', 'Local addon', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(60, 'file', 4, 'addon/state', 'Update state', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(63, 'file', 4, 'addon/config', 'Setting', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(64, 'file', 4, 'addon/refresh', 'Refresh', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(65, 'file', 4, 'addon/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(66, 'file', 0, 'user', 'User', 'fa fa-user-circle', '', '', '', 1, NULL, '', 'hygl', 'huiyuanguanli', 1491635035, 1491635035, 0, 'normal'),
(67, 'file', 66, 'user/user', 'User', 'fa fa-user', '', '', '', 1, NULL, '', 'hygl', 'huiyuanguanli', 1491635035, 1491635035, 0, 'normal'),
(68, 'file', 67, 'user/user/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(69, 'file', 67, 'user/user/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(70, 'file', 67, 'user/user/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(71, 'file', 67, 'user/user/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(72, 'file', 67, 'user/user/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(73, 'file', 66, 'user/group', 'User group', 'fa fa-users', '', '', '', 1, NULL, '', 'hyfz', 'huiyuanfenzu', 1491635035, 1491635035, 0, 'normal'),
(74, 'file', 73, 'user/group/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(75, 'file', 73, 'user/group/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(76, 'file', 73, 'user/group/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(77, 'file', 73, 'user/group/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(78, 'file', 73, 'user/group/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(79, 'file', 66, 'user/rule', 'User rule', 'fa fa-circle-o', '', '', '', 1, NULL, '', 'hygz', 'huiyuanguize', 1491635035, 1491635035, 0, 'normal'),
(80, 'file', 79, 'user/rule/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(81, 'file', 79, 'user/rule/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(82, 'file', 79, 'user/rule/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(83, 'file', 79, 'user/rule/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(84, 'file', 79, 'user/rule/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal'),
(161, 'file', 0, 'weixin', '公众号管理', 'fa fa-weixin', '', '', '', 1, 'addtabs', '', 'gzhgl', 'gongzhonghaoguanli', 1769013664, 1769070387, 0, 'normal'),
(162, 'file', 161, 'weixin/config', '应用配置', 'fa fa-angle-double-right', '', '', '填写微信公众号开发配置，请前往微信公众平台申请服务号并完成认证，请使用已认证的公众号服务号，否则可能缺少接口权限。', 1, NULL, 'padding-left: 15px;', 'yypz', 'yingyongpeizhi', 1769013664, 1769013664, 0, 'normal'),
(163, 'file', 162, 'weixin/config/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1769013664, 1769013664, 0, 'normal'),
(164, 'file', 162, 'weixin/config/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1769013664, 1769013664, 0, 'normal'),
(165, 'file', 161, 'weixin/menus', '菜单管理', 'fa fa-angle-double-right', '', '', '', 1, NULL, 'padding-left: 15px;', 'cdgl', 'caidanguanli', 1769013664, 1769013664, 0, 'normal'),
(166, 'file', 165, 'weixin/menus/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1769013664, 1769013664, 0, 'normal'),
(167, 'file', 165, 'weixin/menus/save', '保存', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bc', 'baocun', 1769013664, 1769013664, 0, 'normal'),
(168, 'file', 165, 'weixin/menus/sync', '保存与同步', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bcytb', 'baocunyutongbu', 1769013664, 1769013664, 0, 'normal'),
(169, 'file', 161, 'weixin/template', '模板消息', 'fa fa-angle-double-right', '', '', '模板消息仅用于公众号向用户发送重要的服务通知，只能用于符合其要求的服务场景中，如信用卡刷卡通知，商品购买成功通知等。', 1, NULL, 'padding-left: 15px;', 'mbxx', 'mubanxiaoxi', 1769013664, 1769013664, 0, 'normal'),
(170, 'file', 169, 'weixin/template/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1769013664, 1769013664, 0, 'normal'),
(171, 'file', 169, 'weixin/template/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1769013664, 1769013664, 0, 'normal'),
(172, 'file', 169, 'weixin/template/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1769013664, 1769013664, 0, 'normal'),
(173, 'file', 169, 'weixin/template/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1769013664, 1769013664, 0, 'normal'),
(174, 'file', 169, 'weixin/template/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1769013664, 1769013664, 0, 'normal'),
(175, 'file', 161, 'weixin/reply', '回复管理', 'fa fa-angle-double-right', '', '', '', 1, NULL, 'padding-left: 15px;', 'hfgl', 'huifuguanli', 1769013664, 1769013664, 0, 'normal'),
(176, 'file', 175, 'weixin/reply/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1769013664, 1769013664, 0, 'normal'),
(177, 'file', 175, 'weixin/reply/add', '新增', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'xz', 'xinzeng', 1769013664, 1769013664, 0, 'normal'),
(178, 'file', 175, 'weixin/reply/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1769013664, 1769013664, 0, 'normal'),
(179, 'file', 175, 'weixin/reply/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1769013664, 1769013664, 0, 'normal'),
(180, 'file', 175, 'weixin/reply/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1769013664, 1769013664, 0, 'normal'),
(181, 'file', 161, 'weixin/news', '图文消息', 'fa fa-angle-double-right', '', '', '图文消息可以通过关键词或者主动推送等方式发送到用户端的公众号中显示。', 1, NULL, 'padding-left: 15px;', 'twxx', 'tuwenxiaoxi', 1769013664, 1769013664, 0, 'normal'),
(182, 'file', 181, 'weixin/news/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1769013664, 1769013664, 0, 'normal'),
(183, 'file', 181, 'weixin/news/add', '新增', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'xz', 'xinzeng', 1769013664, 1769013664, 0, 'normal'),
(184, 'file', 181, 'weixin/news/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1769013664, 1769013664, 0, 'normal'),
(185, 'file', 181, 'weixin/news/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1769013664, 1769013664, 0, 'normal'),
(186, 'file', 181, 'weixin/news/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1769013664, 1769013664, 0, 'normal'),
(187, 'file', 161, 'weixin/user', '微信用户', 'fa fa-angle-double-right', '', '', '该微信用户数据列表是用户在微信端通过登录接口主动授权登录后获得。', 1, NULL, 'padding-left: 15px;', 'wxyh', 'weixinyonghu', 1769013664, 1769013664, 0, 'normal'),
(188, 'file', 187, 'weixin/user/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1769013664, 1769013664, 0, 'normal'),
(189, 'file', 187, 'weixin/user/sendmsg', '推送消息', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tsxx', 'tuisongxiaoxi', 1769013664, 1769013664, 0, 'normal'),
(190, 'file', 187, 'weixin/user/edit_user_tag', '修改用户标签', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'xgyhbq', 'xiugaiyonghubiaoqian', 1769013664, 1769013664, 0, 'normal'),
(191, 'file', 187, 'weixin/user/edit_user_group', '修改用户分组', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'xgyhfz', 'xiugaiyonghufenzu', 1769013664, 1769013664, 0, 'normal'),
(192, 'file', 161, 'weixin/user/tag', '用户标签', 'fa fa-angle-double-right', '', '', '维护和管理微信公众号用户标签，可以为公众号用户设置所属的标签组。', 1, NULL, 'padding-left: 15px;', 'yhbq', 'yonghubiaoqian', 1769013664, 1769013664, 0, 'normal'),
(193, 'file', 192, 'weixin/user/tagadd', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1769013664, 1769013664, 0, 'normal'),
(194, 'file', 192, 'weixin/user/tagedit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1769013664, 1769013664, 0, 'normal'),
(195, 'file', 192, 'weixin/user/tagdel', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1769013664, 1769013664, 0, 'normal'),
(196, 'file', 161, 'weixin/fans/index', '粉丝用户', 'fa fa-angle-double-right', '', '', '粉丝用户是指关注微信公众号的微信用户与授权无关，需要手动同步。因接口限制目前拉去粉丝用户将不再输出头像、昵称等信息。', 1, NULL, 'padding-left: 15px;', 'fsyh', 'fensiyonghu', 1769013664, 1769013664, 0, 'normal'),
(197, 'file', 196, 'weixin/fans/syncwechatfans', '同步粉丝', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tbfs', 'tongbufensi', 1769013664, 1769013664, 0, 'normal'),
(198, 'file', 196, 'weixin/fans/sendmsg', '推送消息', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tsxx', 'tuisongxiaoxi', 1769013664, 1769013664, 0, 'normal'),
(217, 'file', 0, 'byhs', '数据中心', 'fa fa-dashboard', '', '', '', 1, NULL, '', '', '', NULL, NULL, 0, 'normal'),
(218, 'file', 217, 'byhs/dashboard', '数据仪表盘', 'fa fa-area-chart', '', '', '', 1, NULL, '', '', '', NULL, NULL, 0, 'normal'),
(272, 'file', 218, 'byhs/dashboard/index', '查看', '', '', '', '', 0, NULL, '', '', '', 1769043996, 1769043996, 0, 'normal'),
(274, 'file', 0, 'merchant', '商户管理', 'fa fa-building', '', '', '商户入驻与审核管理', 1, NULL, '', '', '', NULL, NULL, 100, 'normal'),
(275, 'file', 274, 'merchant/merchant', '商户列表', 'fa fa-list', '', '', '商户信息与状态管理', 1, NULL, '', '', '', NULL, NULL, 10, 'normal'),
(276, 'file', 274, 'merchant/audit', '审核管理', 'fa fa-check-square', '', '', '商户入驻审核', 1, NULL, '', '', '', NULL, NULL, 9, 'normal'),
(277, 'file', 0, 'task', '任务管理', 'fa fa-tasks', '', '', '互助任务与子任务管理', 1, NULL, '', '', '', NULL, NULL, 90, 'normal'),
(278, 'file', 277, 'task/mutualtask', '主任务列表', 'fa fa-list', '', '', '互助主任务管理', 1, NULL, '', '', '', NULL, NULL, 10, 'normal'),
(279, 'file', 277, 'task/subtask', '子任务列表', 'fa fa-list-alt', '', '', '子任务执行与监控', 1, NULL, '', '', '', NULL, NULL, 9, 'normal'),
(280, 'file', 0, 'wallet', '钱包管理', 'fa fa-money', '', '', '用户资金与流水管理', 1, NULL, '', '', '', NULL, NULL, 80, 'normal'),
(281, 'file', 280, 'wallet/wallet', '用户钱包', 'fa fa-credit-card', '', '', '钱包余额与保证金', 1, NULL, '', '', '', NULL, NULL, 10, 'normal'),
(282, 'file', 280, 'wallet/log', '流水查询', 'fa fa-history', '', '', '资金变动明细', 1, NULL, '', '', '', NULL, NULL, 9, 'normal'),
(283, 'file', 280, 'wallet/withdraw', '提现审核', 'fa fa-sign-out', '', '', '用户提现申请审核', 1, NULL, '', '', '', NULL, NULL, 8, 'normal'),
(284, 'file', 0, 'promo', '推广管理', 'fa fa-users', '', '', '推广分销与收益管理', 1, NULL, '', '', '', NULL, NULL, 70, 'normal'),
(285, 'file', 284, 'promo/level', '等级配置', 'fa fa-star', '', '', '用户等级体系配置', 1, NULL, '', '', '', NULL, NULL, 10, 'normal'),
(286, 'file', 284, 'promo/relation', '推广关系', 'fa fa-sitemap', '', '', '用户推广关系树', 1, NULL, '', '', '', NULL, NULL, 9, 'normal'),
(287, 'file', 284, 'promo/commission', '佣金记录', 'fa fa-dollar', '', '', '佣金发放明细', 1, NULL, '', '', '', NULL, NULL, 8, 'normal'),
(288, 'file', 284, 'promo/bonus', '分红管理', 'fa fa-gift', '', '', '月度分红统计与发放', 1, NULL, '', '', '', NULL, NULL, 7, 'normal'),
(289, 'file', 0, 'config_center', '配置中心', 'fa fa-cogs', '', '', '业务规则与系统配置', 1, NULL, '', '', '', NULL, NULL, 60, 'normal'),
(290, 'file', 289, 'config/reward', '奖励规则', 'fa fa-trophy', '', '', '佣金奖励规则配置', 1, NULL, '', '', '', NULL, NULL, 10, 'normal'),
(291, 'file', 289, 'config/profit', '分润规则', 'fa fa-percent', '', '', '等级差分润配置', 1, NULL, '', '', '', NULL, NULL, 9, 'normal'),
(292, 'file', 289, 'config/bonusconfig', '分红配置', 'fa fa-pie-chart', '', '', '月度分红档位配置', 1, NULL, '', '', '', NULL, NULL, 8, 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `fa_category`
--

CREATE TABLE `fa_category` (
  `id` int(10) UNSIGNED NOT NULL,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父ID',
  `type` varchar(30) DEFAULT '' COMMENT '栏目类型',
  `name` varchar(30) DEFAULT '',
  `nickname` varchar(50) DEFAULT '',
  `flag` set('hot','index','recommend') DEFAULT '',
  `image` varchar(100) DEFAULT '' COMMENT '图片',
  `keywords` varchar(255) DEFAULT '' COMMENT '关键字',
  `description` varchar(255) DEFAULT '' COMMENT '描述',
  `diyname` varchar(30) DEFAULT '' COMMENT '自定义名称',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) DEFAULT '' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类表';

--
-- 转存表中的数据 `fa_category`
--

INSERT INTO `fa_category` (`id`, `pid`, `type`, `name`, `nickname`, `flag`, `image`, `keywords`, `description`, `diyname`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
(1, 0, 'page', '官方新闻', 'news', 'recommend', '/assets/img/qrcode.png', '', '', 'news', 1491635035, 1491635035, 1, 'normal'),
(2, 0, 'page', '移动应用', 'mobileapp', 'hot', '/assets/img/qrcode.png', '', '', 'mobileapp', 1491635035, 1491635035, 2, 'normal'),
(3, 2, 'page', '微信公众号', 'wechatpublic', 'index', '/assets/img/qrcode.png', '', '', 'wechatpublic', 1491635035, 1491635035, 3, 'normal'),
(4, 2, 'page', 'Android开发', 'android', 'recommend', '/assets/img/qrcode.png', '', '', 'android', 1491635035, 1491635035, 4, 'normal'),
(5, 0, 'page', '软件产品', 'software', 'recommend', '/assets/img/qrcode.png', '', '', 'software', 1491635035, 1491635035, 5, 'normal'),
(6, 5, 'page', '网站建站', 'website', 'recommend', '/assets/img/qrcode.png', '', '', 'website', 1491635035, 1491635035, 6, 'normal'),
(7, 5, 'page', '企业管理软件', 'company', 'index', '/assets/img/qrcode.png', '', '', 'company', 1491635035, 1491635035, 7, 'normal'),
(8, 6, 'page', 'PC端', 'website-pc', 'recommend', '/assets/img/qrcode.png', '', '', 'website-pc', 1491635035, 1491635035, 8, 'normal'),
(9, 6, 'page', '移动端', 'website-mobile', 'recommend', '/assets/img/qrcode.png', '', '', 'website-mobile', 1491635035, 1491635035, 9, 'normal'),
(10, 7, 'page', 'CRM系统 ', 'company-crm', 'recommend', '/assets/img/qrcode.png', '', '', 'company-crm', 1491635035, 1491635035, 10, 'normal'),
(11, 7, 'page', 'SASS平台软件', 'company-sass', 'recommend', '/assets/img/qrcode.png', '', '', 'company-sass', 1491635035, 1491635035, 11, 'normal'),
(12, 0, 'test', '测试1', 'test1', 'recommend', '/assets/img/qrcode.png', '', '', 'test1', 1491635035, 1491635035, 12, 'normal'),
(13, 0, 'test', '测试2', 'test2', 'recommend', '/assets/img/qrcode.png', '', '', 'test2', 1491635035, 1491635035, 13, 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `fa_config`
--

CREATE TABLE `fa_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(30) DEFAULT '' COMMENT '变量名',
  `group` varchar(30) DEFAULT '' COMMENT '分组',
  `title` varchar(100) DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100) DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
  `visible` varchar(255) DEFAULT '' COMMENT '可见条件',
  `value` text COMMENT '变量值',
  `content` text COMMENT '变量字典数据',
  `rule` varchar(100) DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255) DEFAULT '' COMMENT '扩展属性',
  `setting` varchar(255) DEFAULT '' COMMENT '配置'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';

--
-- 转存表中的数据 `fa_config`
--

INSERT INTO `fa_config` (`id`, `name`, `group`, `title`, `tip`, `type`, `visible`, `value`, `content`, `rule`, `extend`, `setting`) VALUES
(1, 'name', 'basic', 'Site name', '请填写站点名称', 'string', '', '互助平台', '', 'required', '', NULL),
(2, 'beian', 'basic', 'Beian', '粤ICP备15000000号-1', 'string', '', '', '', '', '', NULL),
(3, 'cdnurl', 'basic', 'Cdn url', '如果全站静态资源使用第三方云储存请配置该值', 'string', '', '', '', '', '', ''),
(4, 'version', 'basic', 'Version', '如果静态资源有变动请重新配置该值', 'string', '', '1.0.4', '', 'required', '', NULL),
(5, 'timezone', 'basic', 'Timezone', '', 'string', '', 'Asia/Shanghai', '', 'required', '', NULL),
(6, 'forbiddenip', 'basic', 'Forbidden ip', '一行一条记录', 'text', '', '', '', '', '', NULL),
(7, 'languages', 'basic', 'Languages', '', 'array', '', '{\"backend\":\"zh-cn\",\"frontend\":\"zh-cn\"}', '', 'required', '', NULL),
(8, 'fixedpage', 'basic', 'Fixed page', '请输入左侧菜单栏存在的链接', 'string', '', 'dashboard', '', 'required', '', NULL),
(9, 'categorytype', 'dictionary', 'Category type', '', 'array', '', '{\"default\":\"Default\",\"page\":\"Page\",\"article\":\"Article\",\"test\":\"Test\"}', '', '', '', ''),
(10, 'configgroup', 'dictionary', 'Config group', '', 'array', '', '{\"basic\":\"Basic\",\"email\":\"Email\",\"dictionary\":\"Dictionary\",\"user\":\"User\",\"example\":\"Example\"}', '', '', '', ''),
(11, 'mail_type', 'email', 'Mail type', '选择邮件发送方式', 'select', '', '1', '[\"请选择\",\"SMTP\"]', '', '', ''),
(12, 'mail_smtp_host', 'email', 'Mail smtp host', '错误的配置发送邮件会导致服务器超时', 'string', '', 'smtp.qq.com', '', '', '', ''),
(13, 'mail_smtp_port', 'email', 'Mail smtp port', '(不加密默认25,SSL默认465,TLS默认587)', 'string', '', '465', '', '', '', ''),
(14, 'mail_smtp_user', 'email', 'Mail smtp user', '（填写完整用户名）', 'string', '', '', '', '', '', ''),
(15, 'mail_smtp_pass', 'email', 'Mail smtp password', '（填写您的密码或授权码）', 'password', '', '', '', '', '', ''),
(16, 'mail_verify_type', 'email', 'Mail vertify type', '（SMTP验证方式[推荐SSL]）', 'select', '', '2', '[\"无\",\"TLS\",\"SSL\"]', '', '', ''),
(17, 'mail_from', 'email', 'Mail from', '', 'string', '', '', '', '', '', ''),
(18, 'attachmentcategory', 'dictionary', 'Attachment category', '', 'array', '', '{\"category1\":\"Category1\",\"category2\":\"Category2\",\"custom\":\"Custom\"}', '', '', '', '');

-- --------------------------------------------------------

--
-- 表的结构 `fa_ems`
--

CREATE TABLE `fa_ems` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `event` varchar(30) DEFAULT '' COMMENT '事件',
  `email` varchar(100) DEFAULT '' COMMENT '邮箱',
  `code` varchar(10) DEFAULT '' COMMENT '验证码',
  `times` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '验证次数',
  `ip` varchar(30) DEFAULT '' COMMENT 'IP',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邮箱验证码表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_merchant`
--

CREATE TABLE `fa_merchant` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `merchant_no` varchar(32) NOT NULL DEFAULT '' COMMENT '商户编号',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '商户名称',
  `legal_name` varchar(50) NOT NULL DEFAULT '' COMMENT '法人姓名',
  `id_card` varchar(20) NOT NULL DEFAULT '' COMMENT '身份证号',
  `id_card_front` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `id_card_back` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证反面',
  `business_license` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `bank_name` varchar(100) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_account` varchar(30) NOT NULL DEFAULT '' COMMENT '银行账号',
  `bank_branch` varchar(200) NOT NULL DEFAULT '' COMMENT '开户支行',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `entry_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '入驻费',
  `entry_fee_paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '入驻费已支付',
  `status` enum('pending','approved','rejected','disabled') NOT NULL DEFAULT 'pending',
  `reject_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `approved_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户信息表';

--
-- 转存表中的数据 `fa_merchant`
--

INSERT INTO `fa_merchant` (`id`, `user_id`, `merchant_no`, `name`, `legal_name`, `id_card`, `id_card_front`, `id_card_back`, `business_license`, `bank_name`, `bank_account`, `bank_branch`, `contact_phone`, `entry_fee`, `entry_fee_paid`, `status`, `reject_reason`, `approved_time`, `createtime`, `updatetime`) VALUES
(1, 2, 'M202601220739445636', '测试商户', '测试商户', '110101199001011234', '', '', '', '中国银行', '6217000010001234567', '', '13800138000', 0.00, 0, 'approved', NULL, NULL, 1769038784, 1769038784),
(2, 4, 'M202601220810434925', '测试商户1', '张三', '110101199001011234', '', '', '', '中国银行', '6217000010001234567', '', '13800138001', 0.00, 1, 'approved', NULL, 1769040643, 1769040643, 1769040643),
(3, 7, 'M202601220815371913', '测试商户1', '张三', '110101199001011234', '', '', '', '中国银行', '6217000010001234567', '', '13800138001', 0.00, 1, 'approved', NULL, NULL, 1769040937, 1769040937);

-- --------------------------------------------------------

--
-- 表的结构 `fa_merchant_audit`
--

CREATE TABLE `fa_merchant_audit` (
  `id` int(10) UNSIGNED NOT NULL,
  `merchant_id` int(10) UNSIGNED NOT NULL,
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '审核人',
  `action` enum('submit','approve','reject') NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户审核记录表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_mutual_task`
--

CREATE TABLE `fa_mutual_task` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '发起用户',
  `task_no` varchar(32) NOT NULL COMMENT '任务编号',
  `total_amount` decimal(15,2) NOT NULL COMMENT '目标金额',
  `completed_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '已完成金额',
  `pending_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '待完成金额',
  `deposit_amount` decimal(15,2) NOT NULL COMMENT '保证金',
  `frozen_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '已冻结金额',
  `service_fee_rate` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '服务费率',
  `sub_task_min` decimal(10,2) NOT NULL DEFAULT '2000.00' COMMENT '子任务最小金额',
  `sub_task_max` decimal(10,2) NOT NULL DEFAULT '5000.00' COMMENT '子任务最大金额',
  `channel_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '支付通道',
  `start_time` int(10) UNSIGNED DEFAULT NULL,
  `end_time` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('pending','approved','rejected','running','paused','completed','cancelled') NOT NULL DEFAULT 'pending',
  `content` text COMMENT '详细说明',
  `reject_reason` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL,
  `receipt_type` enum('entry','collection') DEFAULT 'entry' COMMENT '收款类型',
  `entry_qrcode` varchar(255) DEFAULT NULL COMMENT '进件二维码',
  `collection_qrcode` varchar(255) DEFAULT NULL COMMENT '收款码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='互助主任务表';

--
-- 转存表中的数据 `fa_mutual_task`
--

INSERT INTO `fa_mutual_task` (`id`, `user_id`, `task_no`, `total_amount`, `completed_amount`, `pending_amount`, `deposit_amount`, `frozen_amount`, `service_fee_rate`, `sub_task_min`, `sub_task_max`, `channel_id`, `start_time`, `end_time`, `status`, `content`, `reject_reason`, `remark`, `createtime`, `updatetime`, `receipt_type`, `entry_qrcode`, `collection_qrcode`) VALUES
(3, 2, 'T202601220741297415', 10000.00, 0.00, 0.00, 2000.00, 0.00, 0.0000, 2000.00, 5000.00, 0, NULL, NULL, 'pending', NULL, NULL, NULL, 1769038889, 1769038889, 'entry', NULL, NULL),
(4, 4, 'T202601220810437282', 10000.00, 0.00, 0.00, 2000.00, 0.00, 0.0000, 2000.00, 5000.00, 0, NULL, NULL, 'approved', NULL, NULL, NULL, 1769040643, 1769040643, 'entry', NULL, NULL),
(5, 7, 'T202601220815372228', 10000.00, 0.00, 0.00, 2000.00, 0.00, 0.0000, 2000.00, 5000.00, 0, NULL, NULL, 'approved', NULL, NULL, NULL, 1769040937, 1769040937, 'entry', NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `fa_profit_rule`
--

CREATE TABLE `fa_profit_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '规则名称',
  `level_diff` int(10) NOT NULL COMMENT '等级差',
  `profit_rate` decimal(5,4) NOT NULL COMMENT '分润比例',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分润规则配置表';

--
-- 转存表中的数据 `fa_profit_rule`
--

INSERT INTO `fa_profit_rule` (`id`, `name`, `level_diff`, `profit_rate`, `growth_min`, `status`, `createtime`, `updatetime`) VALUES
(1, '一级差分润', 1, 0.0005, 0.00, 'normal', 1769014810, NULL),
(2, '二级差分润', 2, 0.0010, 0.00, 'normal', 1769014810, NULL),
(3, '三级差分润', 3, 0.0015, 0.00, 'normal', 1769014810, NULL),
(4, '四级差分润', 4, 0.0020, 0.00, 'normal', 1769014810, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `fa_promo_bonus`
--

CREATE TABLE `fa_promo_bonus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `config_id` int(10) UNSIGNED NOT NULL COMMENT '配置ID',
  `month` char(7) NOT NULL COMMENT '月份',
  `pool_amount` decimal(15,2) NOT NULL COMMENT '奖池金额',
  `qualified_count` int(10) NOT NULL COMMENT '达标人数',
  `amount` decimal(15,2) NOT NULL COMMENT '分红金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending',
  `settle_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红记录表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_promo_bonus_config`
--

CREATE TABLE `fa_promo_bonus_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '档位名称',
  `team_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '团队业绩门槛',
  `personal_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '个人业绩门槛',
  `qualified_count_min` int(10) NOT NULL DEFAULT '0' COMMENT '达标人数',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `pool_rate` decimal(5,4) NOT NULL COMMENT '奖池比例',
  `sort` int(10) NOT NULL DEFAULT '0',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红配置表';

--
-- 转存表中的数据 `fa_promo_bonus_config`
--

INSERT INTO `fa_promo_bonus_config` (`id`, `name`, `team_performance_min`, `personal_performance_min`, `qualified_count_min`, `growth_min`, `pool_rate`, `sort`, `status`, `createtime`, `updatetime`) VALUES
(1, '基础分红', 100000.00, 10000.00, 3, 0.00, 0.0100, 1, 'normal', 1769014810, NULL),
(2, '进阶分红', 500000.00, 50000.00, 10, 10000.00, 0.0150, 2, 'normal', 1769014810, NULL),
(3, '高级分红', 2000000.00, 200000.00, 30, 50000.00, 0.0200, 3, 'normal', 1769014810, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `fa_promo_commission`
--

CREATE TABLE `fa_promo_commission` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '获得者',
  `source_user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '来源用户',
  `scene` varchar(50) NOT NULL COMMENT '场景',
  `reward_type` varchar(50) NOT NULL COMMENT '奖励类型',
  `rule_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '规则ID',
  `base_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '基数',
  `amount` decimal(15,2) NOT NULL COMMENT '金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending',
  `settle_time` int(10) UNSIGNED DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金记录表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_promo_level`
--

CREATE TABLE `fa_promo_level` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '等级名称',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `upgrade_type` enum('purchase','performance','both') NOT NULL DEFAULT 'purchase' COMMENT '升级方式',
  `upgrade_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '购买价格',
  `personal_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '个人业绩要求',
  `team_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '团队业绩要求',
  `direct_invite_min` int(10) NOT NULL DEFAULT '0' COMMENT '直推人数要求',
  `commission_rate` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '佣金比例',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='等级配置表';

--
-- 转存表中的数据 `fa_promo_level`
--

INSERT INTO `fa_promo_level` (`id`, `name`, `sort`, `upgrade_type`, `upgrade_price`, `personal_performance_min`, `team_performance_min`, `direct_invite_min`, `commission_rate`, `status`, `createtime`, `updatetime`) VALUES
(1, '普通会员', 0, 'purchase', 0.00, 0.00, 0.00, 0, 0.0010, 'normal', 1769014810, NULL),
(2, '银卡会员', 1, 'both', 1000.00, 50000.00, 100000.00, 5, 0.0020, 'normal', 1769014810, NULL),
(3, '金卡会员', 2, 'both', 3000.00, 150000.00, 500000.00, 10, 0.0030, 'normal', 1769014810, NULL),
(4, '铂金会员', 3, 'performance', 10000.00, 500000.00, 2000000.00, 20, 0.0050, 'normal', 1769014810, NULL),
(5, '钻石会员', 4, 'performance', 30000.00, 1500000.00, 10000000.00, 50, 0.0080, 'normal', 1769014810, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `fa_promo_performance`
--

CREATE TABLE `fa_promo_performance` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `month` char(7) NOT NULL COMMENT '月份',
  `personal_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '个人业绩',
  `team_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '团队业绩',
  `growth_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量',
  `direct_count` int(10) NOT NULL DEFAULT '0' COMMENT '直推达标数',
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业绩统计表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_promo_relation`
--

CREATE TABLE `fa_promo_relation` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `level_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '等级ID',
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上级ID',
  `path` varchar(1000) NOT NULL DEFAULT '' COMMENT '路径',
  `depth` int(10) NOT NULL DEFAULT '0' COMMENT '深度',
  `invite_code` varchar(20) NOT NULL DEFAULT '' COMMENT '邀请码',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推广关系表';

--
-- 转存表中的数据 `fa_promo_relation`
--

INSERT INTO `fa_promo_relation` (`id`, `user_id`, `level_id`, `parent_id`, `path`, `depth`, `invite_code`, `createtime`, `updatetime`) VALUES
(1, 2, 1, 0, '', 0, '92D87F8A', 1769038749, 1769038749),
(2, 3, 0, 0, '', 0, '4713EEEC', 1769038837, 1769038837),
(3, 4, 1, 0, '', 0, '4AF9D45C', 1769040643, 1769040643),
(4, 5, 0, 0, '', 0, '4D7B47DD', 1769040643, 1769040643),
(5, 6, 0, 4, '0,4', 1, 'B813C8B4', 1769040643, 1769040643),
(6, 7, 1, 0, '', 0, '05A53611', 1769040937, 1769040937),
(7, 8, 0, 0, '', 0, '3ECD700C', 1769040937, 1769040937),
(8, 9, 0, 7, '', 1, '123C3FCA', 1769040937, 1769040937);

-- --------------------------------------------------------

--
-- 表的结构 `fa_recharge`
--

CREATE TABLE `fa_recharge` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `order_no` varchar(32) NOT NULL COMMENT '订单号',
  `amount` decimal(15,2) NOT NULL COMMENT '充值金额',
  `target` enum('balance','deposit') NOT NULL DEFAULT 'balance' COMMENT '充值目标',
  `pay_method` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式',
  `third_order_no` varchar(64) DEFAULT NULL COMMENT '第三方订单号',
  `status` enum('pending','paid','failed') NOT NULL DEFAULT 'pending',
  `paid_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='充值记录表';

--
-- 转存表中的数据 `fa_recharge`
--

INSERT INTO `fa_recharge` (`id`, `user_id`, `order_no`, `amount`, `target`, `pay_method`, `third_order_no`, `status`, `paid_time`, `createtime`, `updatetime`) VALUES
(1, 2, 'R202601220742233443', 1000.00, 'balance', '', NULL, 'paid', 1769038943, 1769038943, 1769038943),
(2, 4, 'R202601220810437926', 1000.00, 'balance', '', NULL, 'paid', 1769040643, 1769040643, 1769040643),
(3, 7, 'R202601220815371920', 1000.00, 'balance', '', NULL, 'paid', NULL, 1769040937, 1769040937);

-- --------------------------------------------------------

--
-- 表的结构 `fa_reward_rule`
--

CREATE TABLE `fa_reward_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '规则名称',
  `scene` enum('merchant_entry','order_complete','level_upgrade') NOT NULL COMMENT '触发场景',
  `reward_type` enum('direct','indirect','level_diff','peer','team') NOT NULL COMMENT '奖励类型',
  `target_depth` int(10) NOT NULL DEFAULT '1' COMMENT '目标层级',
  `level_require` varchar(255) DEFAULT NULL COMMENT '等级要求JSON',
  `amount_type` enum('fixed','percent') NOT NULL COMMENT '金额类型',
  `amount_value` decimal(10,4) NOT NULL COMMENT '金额值',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖励规则配置表';

--
-- 转存表中的数据 `fa_reward_rule`
--

INSERT INTO `fa_reward_rule` (`id`, `name`, `scene`, `reward_type`, `target_depth`, `level_require`, `amount_type`, `amount_value`, `growth_min`, `status`, `createtime`, `updatetime`) VALUES
(1, '商户入驻直推奖', 'merchant_entry', 'direct', 1, NULL, 'percent', 0.1000, 0.00, 'normal', 1769014810, NULL),
(2, '商户入驻间推奖', 'merchant_entry', 'indirect', 2, NULL, 'percent', 0.0500, 0.00, 'normal', 1769014810, NULL),
(3, '等级升级直推奖', 'level_upgrade', 'direct', 1, NULL, 'percent', 0.1000, 0.00, 'normal', 1769014810, NULL),
(4, '等级升级间推奖', 'level_upgrade', 'indirect', 2, NULL, 'percent', 0.0500, 0.00, 'normal', 1769014810, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `fa_sms`
--

CREATE TABLE `fa_sms` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `event` varchar(30) DEFAULT '' COMMENT '事件',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号',
  `code` varchar(10) DEFAULT '' COMMENT '验证码',
  `times` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '验证次数',
  `ip` varchar(30) DEFAULT '' COMMENT 'IP',
  `createtime` bigint(16) UNSIGNED DEFAULT '0' COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='短信验证码表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_sub_task`
--

CREATE TABLE `fa_sub_task` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `task_id` int(10) UNSIGNED NOT NULL COMMENT '主任务ID',
  `task_no` varchar(32) NOT NULL COMMENT '子任务编号',
  `from_user_id` int(10) UNSIGNED NOT NULL COMMENT '发起方',
  `to_user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '执行方',
  `amount` decimal(10,2) NOT NULL COMMENT '刷单金额',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '佣金',
  `service_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '服务费',
  `proof_image` varchar(500) DEFAULT NULL COMMENT '支付凭证',
  `third_order_no` varchar(64) DEFAULT NULL COMMENT '第三方订单号',
  `status` enum('pending','assigned','accepted','paid','verified','completed','failed','cancelled') NOT NULL DEFAULT 'pending',
  `assigned_time` int(10) UNSIGNED DEFAULT NULL,
  `accepted_time` int(10) UNSIGNED DEFAULT NULL,
  `paid_time` int(10) UNSIGNED DEFAULT NULL,
  `completed_time` int(10) UNSIGNED DEFAULT NULL,
  `fail_reason` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='子任务表';

--
-- 转存表中的数据 `fa_sub_task`
--

INSERT INTO `fa_sub_task` (`id`, `task_id`, `task_no`, `from_user_id`, `to_user_id`, `amount`, `commission`, `service_fee`, `proof_image`, `third_order_no`, `status`, `assigned_time`, `accepted_time`, `paid_time`, `completed_time`, `fail_reason`, `createtime`, `updatetime`) VALUES
(1, 3, 'ST2026012207412989640', 2, 0, 5000.00, 0.00, 0.00, NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, 1769038889, 1769038889),
(2, 3, 'ST2026012207412998171', 2, 0, 5000.00, 0.00, 0.00, NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, 1769038889, 1769038889),
(3, 4, 'ST2026012208104320170', 4, 5, 5000.00, 0.00, 0.00, '/uploads/proof_1769040643.jpg', 'ORD17690406439184', 'verified', 1769040643, 1769040643, 1769040643, NULL, NULL, 1769040643, 1769040643),
(4, 4, 'ST2026012208104345041', 4, 0, 5000.00, 0.00, 0.00, NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, 1769040643, 1769040643),
(5, 5, 'ST2026012208153738910', 7, 8, 5000.00, 0.00, 0.00, '/uploads/proof_1769040937.jpg', 'ORD17690409376387', 'paid', NULL, 1769040937, 1769040937, NULL, NULL, 1769040937, 1769040937),
(6, 5, 'ST2026012208153739701', 7, 0, 5000.00, 0.00, 0.00, NULL, NULL, 'assigned', NULL, NULL, NULL, NULL, NULL, 1769040937, 1769040937);

-- --------------------------------------------------------

--
-- 表的结构 `fa_test`
--

CREATE TABLE `fa_test` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `user_id` int(10) DEFAULT '0' COMMENT '会员ID',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员ID',
  `category_id` int(10) UNSIGNED DEFAULT '0' COMMENT '分类ID(单选)',
  `category_ids` varchar(100) DEFAULT NULL COMMENT '分类ID(多选)',
  `tags` varchar(255) DEFAULT '' COMMENT '标签',
  `week` enum('monday','tuesday','wednesday') DEFAULT NULL COMMENT '星期(单选):monday=星期一,tuesday=星期二,wednesday=星期三',
  `flag` set('hot','index','recommend') DEFAULT '' COMMENT '标志(多选):hot=热门,index=首页,recommend=推荐',
  `genderdata` enum('male','female') DEFAULT 'male' COMMENT '性别(单选):male=男,female=女',
  `hobbydata` set('music','reading','swimming') DEFAULT NULL COMMENT '爱好(多选):music=音乐,reading=读书,swimming=游泳',
  `title` varchar(100) DEFAULT '' COMMENT '标题',
  `content` text COMMENT '内容',
  `image` varchar(100) DEFAULT '' COMMENT '图片',
  `images` varchar(1500) DEFAULT '' COMMENT '图片组',
  `attachfile` varchar(100) DEFAULT '' COMMENT '附件',
  `keywords` varchar(255) DEFAULT '' COMMENT '关键字',
  `description` varchar(255) DEFAULT '' COMMENT '描述',
  `city` varchar(100) DEFAULT '' COMMENT '省市',
  `array` varchar(255) DEFAULT '' COMMENT '数组:value=值',
  `json` varchar(255) DEFAULT '' COMMENT '配置:key=名称,value=值',
  `multiplejson` varchar(1500) DEFAULT '' COMMENT '二维数组:title=标题,intro=介绍,author=作者,age=年龄',
  `price` decimal(10,2) UNSIGNED DEFAULT '0.00' COMMENT '价格',
  `views` int(10) UNSIGNED DEFAULT '0' COMMENT '点击',
  `workrange` varchar(100) DEFAULT '' COMMENT '时间区间',
  `startdate` date DEFAULT NULL COMMENT '开始日期',
  `activitytime` datetime DEFAULT NULL COMMENT '活动时间(datetime)',
  `year` year(4) DEFAULT NULL COMMENT '年',
  `times` time DEFAULT NULL COMMENT '时间',
  `refreshtime` bigint(16) DEFAULT NULL COMMENT '刷新时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  `weigh` int(10) DEFAULT '0' COMMENT '权重',
  `switch` tinyint(1) DEFAULT '0' COMMENT '开关',
  `status` enum('normal','hidden') DEFAULT 'normal' COMMENT '状态',
  `state` enum('0','1','2') DEFAULT '1' COMMENT '状态值:0=禁用,1=正常,2=推荐'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='测试表';

--
-- 转存表中的数据 `fa_test`
--

INSERT INTO `fa_test` (`id`, `user_id`, `admin_id`, `category_id`, `category_ids`, `tags`, `week`, `flag`, `genderdata`, `hobbydata`, `title`, `content`, `image`, `images`, `attachfile`, `keywords`, `description`, `city`, `array`, `json`, `multiplejson`, `price`, `views`, `workrange`, `startdate`, `activitytime`, `year`, `times`, `refreshtime`, `createtime`, `updatetime`, `deletetime`, `weigh`, `switch`, `status`, `state`) VALUES
(1, 1, 1, 12, '12,13', '互联网,计算机', 'monday', 'hot,index', 'male', 'music,reading', '我是一篇测试文章', '<p>我是测试内容</p>', '/assets/img/avatar.png', '/assets/img/avatar.png,/assets/img/qrcode.png', '/assets/img/avatar.png', '关键字', '我是一篇测试文章描述，内容过多时将自动隐藏', '广西壮族自治区/百色市/平果县', '[\"a\",\"b\"]', '{\"a\":\"1\",\"b\":\"2\"}', '[{\"title\":\"标题一\",\"intro\":\"介绍一\",\"author\":\"小明\",\"age\":\"21\"}]', 0.00, 0, '2020-10-01 00:00:00 - 2021-10-31 23:59:59', '2017-07-10', '2017-07-10 18:24:45', '2017', '18:24:45', 1491635035, 1491635035, 1491635035, NULL, 0, 1, 'normal', '1');

-- --------------------------------------------------------

--
-- 表的结构 `fa_user`
--

CREATE TABLE `fa_user` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `group_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '组别ID',
  `username` varchar(32) DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) DEFAULT '' COMMENT '昵称',
  `password` varchar(32) DEFAULT '' COMMENT '密码',
  `salt` varchar(30) DEFAULT '' COMMENT '密码盐',
  `email` varchar(100) DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `level` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '等级',
  `gender` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `bio` varchar(100) DEFAULT '' COMMENT '格言',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
  `successions` int(10) UNSIGNED NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `maxsuccessions` int(10) UNSIGNED NOT NULL DEFAULT '1' COMMENT '最大连续登录天数',
  `prevtime` bigint(16) DEFAULT NULL COMMENT '上次登录时间',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) DEFAULT '' COMMENT '登录IP',
  `loginfailure` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '失败次数',
  `loginfailuretime` bigint(16) DEFAULT NULL COMMENT '最后登录失败时间',
  `joinip` varchar(50) DEFAULT '' COMMENT '加入IP',
  `jointime` bigint(16) DEFAULT NULL COMMENT '加入时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(50) DEFAULT '' COMMENT 'Token',
  `status` varchar(30) DEFAULT '' COMMENT '状态',
  `verification` varchar(255) DEFAULT '' COMMENT '验证'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员表';

--
-- 转存表中的数据 `fa_user`
--

INSERT INTO `fa_user` (`id`, `group_id`, `username`, `nickname`, `password`, `salt`, `email`, `mobile`, `avatar`, `level`, `gender`, `birthday`, `bio`, `money`, `score`, `successions`, `maxsuccessions`, `prevtime`, `logintime`, `loginip`, `loginfailure`, `loginfailuretime`, `joinip`, `jointime`, `createtime`, `updatetime`, `token`, `status`, `verification`) VALUES
(1, 1, 'admin', 'admin', 'f131bd083a78d4f9a7c626284a3fc493', '62feb3', 'admin@163.com', '13000000000', '/assets/img/avatar.png', 0, 0, '2017-04-08', '', 0.00, 0, 1, 1, 1491635035, 1491635035, '127.0.0.1', 0, 1491635035, '127.0.0.1', 1491635035, 0, 1491635035, '', 'normal', ''),
(2, 0, 'testuser', '', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138000', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769038670, 1769038670, '', 'normal', ''),
(3, 0, 'acceptuser', '', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13900139000', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769038837, 1769038837, '', 'normal', ''),
(4, 0, 'testuser1', '测试昵称1', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138001', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769040643, 1769040643, '', 'normal', ''),
(5, 0, 'testuser2', '', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138002', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769040643, 1769040643, '', 'normal', ''),
(6, 0, 'testuser3', '', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138003', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769040643, 1769040643, '', 'normal', ''),
(7, 0, 'testuser1', '测试昵称1', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138001', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769040937, 1769040937, '', 'normal', ''),
(8, 0, 'testuser2', '', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138002', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769040937, 1769040937, '', 'normal', ''),
(9, 0, 'testuser3', '', '6f3b8ded65bd7a4db11625ac84e579bb', 'abcdef', '', '13800138003', '', 0, 0, NULL, '', 0.00, 0, 1, 1, NULL, NULL, '', 0, NULL, '', NULL, 1769040937, 1769040937, '', 'normal', '');

-- --------------------------------------------------------

--
-- 表的结构 `fa_user_group`
--

CREATE TABLE `fa_user_group` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) DEFAULT '' COMMENT '组名',
  `rules` text COMMENT '权限节点',
  `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `status` enum('normal','hidden') DEFAULT NULL COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员组表';

--
-- 转存表中的数据 `fa_user_group`
--

INSERT INTO `fa_user_group` (`id`, `name`, `rules`, `createtime`, `updatetime`, `status`) VALUES
(1, '默认组', '1,2,3,4,5,6,7,8,9,10,11,12', 1491635035, 1491635035, 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `fa_user_money_log`
--

CREATE TABLE `fa_user_money_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更余额',
  `before` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更前余额',
  `after` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更后余额',
  `memo` varchar(255) DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员余额变动表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_user_rule`
--

CREATE TABLE `fa_user_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `pid` int(10) DEFAULT NULL COMMENT '父ID',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `title` varchar(50) DEFAULT '' COMMENT '标题',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `ismenu` tinyint(1) DEFAULT NULL COMMENT '是否菜单',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) DEFAULT '0' COMMENT '权重',
  `status` enum('normal','hidden') DEFAULT NULL COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员规则表';

--
-- 转存表中的数据 `fa_user_rule`
--

INSERT INTO `fa_user_rule` (`id`, `pid`, `name`, `title`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`) VALUES
(1, 0, 'index', 'Frontend', '', 1, 1491635035, 1491635035, 1, 'normal'),
(2, 0, 'api', 'API Interface', '', 1, 1491635035, 1491635035, 2, 'normal'),
(3, 1, 'user', 'User Module', '', 1, 1491635035, 1491635035, 12, 'normal'),
(4, 2, 'user', 'User Module', '', 1, 1491635035, 1491635035, 11, 'normal'),
(5, 3, 'index/user/login', 'Login', '', 0, 1491635035, 1491635035, 5, 'normal'),
(6, 3, 'index/user/register', 'Register', '', 0, 1491635035, 1491635035, 7, 'normal'),
(7, 3, 'index/user/index', 'User Center', '', 0, 1491635035, 1491635035, 9, 'normal'),
(8, 3, 'index/user/profile', 'Profile', '', 0, 1491635035, 1491635035, 4, 'normal'),
(9, 4, 'api/user/login', 'Login', '', 0, 1491635035, 1491635035, 6, 'normal'),
(10, 4, 'api/user/register', 'Register', '', 0, 1491635035, 1491635035, 8, 'normal'),
(11, 4, 'api/user/index', 'User Center', '', 0, 1491635035, 1491635035, 10, 'normal'),
(12, 4, 'api/user/profile', 'Profile', '', 0, 1491635035, 1491635035, 3, 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `fa_user_score_log`
--

CREATE TABLE `fa_user_score_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '变更积分',
  `before` int(10) NOT NULL DEFAULT '0' COMMENT '变更前积分',
  `after` int(10) NOT NULL DEFAULT '0' COMMENT '变更后积分',
  `memo` varchar(255) DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员积分变动表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_user_token`
--

CREATE TABLE `fa_user_token` (
  `token` varchar(50) NOT NULL COMMENT 'Token',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `expiretime` bigint(16) DEFAULT NULL COMMENT '过期时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员Token表';

--
-- 转存表中的数据 `fa_user_token`
--

INSERT INTO `fa_user_token` (`token`, `user_id`, `createtime`, `expiretime`) VALUES
('18aae23e294b792da8263ab8e6065833', 9, 1769040937, 1771632937),
('9a2022ca85df2a49f4fb06a0953df217', 4, 1769040643, 1771632643),
('a397871d7e377124b48ea09cc21dba7f', 7, 1769040937, 1771632937),
('b2d89b1c5dfa87d927665e3b5172e4b5', 2, 1769038711, 1771630711),
('c74250e8d9dbbe01b08371c3aefced39', 6, 1769040643, 1771632643),
('cfc4a6ee74e881ecda4b2723a657149e', 8, 1769040937, 1771632937),
('ee5a96f6b1e42b9a5700bf782523ccbf', 5, 1769040643, 1771632643);

-- --------------------------------------------------------

--
-- 表的结构 `fa_version`
--

CREATE TABLE `fa_version` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `oldversion` varchar(30) DEFAULT '' COMMENT '旧版本号',
  `newversion` varchar(30) DEFAULT '' COMMENT '新版本号',
  `packagesize` varchar(30) DEFAULT '' COMMENT '包大小',
  `content` varchar(500) DEFAULT '' COMMENT '升级内容',
  `downloadurl` varchar(255) DEFAULT '' COMMENT '下载地址',
  `enforce` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '强制更新',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) DEFAULT '' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='版本表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_wallet`
--

CREATE TABLE `fa_wallet` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额',
  `deposit` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '保证金',
  `frozen` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '冻结金额',
  `mutual_balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '互助余额',
  `total_income` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '累计收入',
  `total_withdraw` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '累计提现',
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钱包表';

--
-- 转存表中的数据 `fa_wallet`
--

INSERT INTO `fa_wallet` (`id`, `user_id`, `balance`, `deposit`, `frozen`, `mutual_balance`, `total_income`, `total_withdraw`, `updatetime`) VALUES
(1, 2, 1000.00, 5000.00, 0.00, 0.00, 1000.00, 0.00, 1769038784),
(2, 3, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1769038837),
(3, 4, 1300.00, 5200.00, 5000.00, 0.00, 1000.00, 0.00, 1769040643),
(4, 5, 1000.00, 5000.00, 0.00, 0.00, 0.00, 0.00, 1769040643),
(5, 6, 1000.00, 5000.00, 0.00, 0.00, 0.00, 0.00, 1769040643),
(6, 7, 2300.00, 10200.00, 0.00, 0.00, 0.00, 0.00, 1769040937),
(7, 8, 2000.00, 10000.00, 0.00, 0.00, 0.00, 0.00, 1769040937),
(8, 9, 2000.00, 10000.00, 0.00, 0.00, 0.00, 0.00, 1769040937);

-- --------------------------------------------------------

--
-- 表的结构 `fa_wallet_log`
--

CREATE TABLE `fa_wallet_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `wallet_type` enum('balance','deposit','frozen','mutual') NOT NULL COMMENT '钱包类型',
  `change_type` enum('income','expense','freeze','unfreeze') NOT NULL COMMENT '变动类型',
  `amount` decimal(15,2) NOT NULL COMMENT '变动金额',
  `before_amount` decimal(15,2) NOT NULL COMMENT '变动前',
  `after_amount` decimal(15,2) NOT NULL COMMENT '变动后',
  `biz_type` varchar(50) NOT NULL COMMENT '业务类型',
  `biz_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '业务ID',
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钱包流水表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_weixin_config`
--

CREATE TABLE `fa_weixin_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '变量名',
  `group` varchar(30) NOT NULL DEFAULT '' COMMENT '分组',
  `value` text COMMENT '变量值'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';

-- --------------------------------------------------------

--
-- 表的结构 `fa_weixin_fans`
--

CREATE TABLE `fa_weixin_fans` (
  `fans_id` int(11) UNSIGNED NOT NULL COMMENT '粉丝ID',
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
  `subscribe_time` bigint(16) DEFAULT NULL COMMENT '关注时间',
  `subscribe_scene` varchar(100) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源',
  `unsubscribe_time` bigint(16) DEFAULT NULL COMMENT '取消关注时间',
  `update_date` bigint(16) DEFAULT NULL COMMENT '粉丝信息最后更新时间',
  `tagid_list` varchar(255) NOT NULL DEFAULT '' COMMENT '用户被打上的标签ID列表',
  `subscribe_scene_name` varchar(50) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源名称',
  `qr_scene` varchar(255) NOT NULL DEFAULT '' COMMENT 'qr_scene',
  `qr_scene_str` varchar(255) NOT NULL DEFAULT '' COMMENT 'qr_scene_str'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信粉丝列表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_weixin_news`
--

CREATE TABLE `fa_weixin_news` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '图文消息表',
  `title` varchar(255) NOT NULL COMMENT '图文标题',
  `description` varchar(255) NOT NULL COMMENT '图文简介',
  `pic` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'URL',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图文消息管理表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_weixin_reply`
--

CREATE TABLE `fa_weixin_reply` (
  `id` mediumint(8) UNSIGNED NOT NULL COMMENT '微信关键字回复id',
  `keyword` varchar(1000) NOT NULL DEFAULT '' COMMENT '关键字',
  `reply_type` enum('text','image','news','voice','video') NOT NULL DEFAULT 'text' COMMENT '回复类型:text=文本消息,image=图片消息,news=图文消息,voice=音频消息,video=视频消息',
  `matching_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT '匹配方式：1-全匹配；2-模糊匹配',
  `content` text COMMENT '回复数据',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信回复表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_weixin_template`
--

CREATE TABLE `fa_weixin_template` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '模板id',
  `tempkey` char(50) NOT NULL DEFAULT '' COMMENT '模板编号',
  `name` char(100) NOT NULL DEFAULT '' COMMENT '模板名',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '回复内容',
  `tempid` char(100) DEFAULT NULL COMMENT '模板ID',
  `open_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '跳转类型：0网址1小程序',
  `open_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转网址',
  `appid` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序appid',
  `pagepath` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序页面path',
  `add_time` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信模板';

-- --------------------------------------------------------

--
-- 表的结构 `fa_weixin_user`
--

CREATE TABLE `fa_weixin_user` (
  `id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `openid` varchar(128) NOT NULL COMMENT '微信openid',
  `unionid` varchar(128) DEFAULT '' COMMENT '微信unionid',
  `tagid_list` varchar(256) DEFAULT NULL COMMENT '用户被打上的标签ID列表',
  `user_type` varchar(32) DEFAULT 'wechat' COMMENT '用户类型',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户授权表';

-- --------------------------------------------------------

--
-- 表的结构 `fa_withdraw`
--

CREATE TABLE `fa_withdraw` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `withdraw_no` varchar(32) NOT NULL COMMENT '提现单号',
  `amount` decimal(15,2) NOT NULL COMMENT '提现金额',
  `fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '手续费',
  `actual_amount` decimal(15,2) NOT NULL COMMENT '实际到账',
  `bank_name` varchar(100) NOT NULL,
  `bank_account` varchar(30) NOT NULL,
  `bank_branch` varchar(200) DEFAULT NULL,
  `account_name` varchar(50) NOT NULL COMMENT '户名',
  `status` enum('pending','approved','rejected','paid','failed') NOT NULL DEFAULT 'pending',
  `reject_reason` varchar(255) DEFAULT NULL,
  `admin_id` int(10) UNSIGNED DEFAULT NULL,
  `audit_time` int(10) UNSIGNED DEFAULT NULL,
  `paid_time` int(10) UNSIGNED DEFAULT NULL,
  `createtime` int(10) UNSIGNED DEFAULT NULL,
  `updatetime` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现申请表';

--
-- 转存表中的数据 `fa_withdraw`
--

INSERT INTO `fa_withdraw` (`id`, `user_id`, `withdraw_no`, `amount`, `fee`, `actual_amount`, `bank_name`, `bank_account`, `bank_branch`, `account_name`, `status`, `reject_reason`, `admin_id`, `audit_time`, `paid_time`, `createtime`, `updatetime`) VALUES
(1, 4, 'W202601220810435055', 500.00, 0.00, 500.00, '中国银行', '6217****1234', NULL, '张三', 'pending', NULL, NULL, NULL, NULL, 1769040643, 1769040643),
(2, 7, 'W202601220815377781', 500.00, 0.00, 500.00, '中国银行', '6217****1234', NULL, '张三', 'pending', NULL, NULL, NULL, NULL, 1769040937, 1769040937);

--
-- 转储表的索引
--

--
-- 表的索引 `fa_admin`
--
ALTER TABLE `fa_admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`) USING BTREE;

--
-- 表的索引 `fa_admin_log`
--
ALTER TABLE `fa_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`username`);

--
-- 表的索引 `fa_area`
--
ALTER TABLE `fa_area`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid` (`pid`);

--
-- 表的索引 `fa_attachment`
--
ALTER TABLE `fa_attachment`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_auth_group`
--
ALTER TABLE `fa_auth_group`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_auth_group_access`
--
ALTER TABLE `fa_auth_group_access`
  ADD UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  ADD KEY `uid` (`uid`),
  ADD KEY `group_id` (`group_id`);

--
-- 表的索引 `fa_auth_rule`
--
ALTER TABLE `fa_auth_rule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`) USING BTREE,
  ADD KEY `pid` (`pid`),
  ADD KEY `weigh` (`weigh`);

--
-- 表的索引 `fa_category`
--
ALTER TABLE `fa_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `weigh` (`weigh`,`id`),
  ADD KEY `pid` (`pid`);

--
-- 表的索引 `fa_config`
--
ALTER TABLE `fa_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 表的索引 `fa_ems`
--
ALTER TABLE `fa_ems`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 表的索引 `fa_merchant`
--
ALTER TABLE `fa_merchant`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_id` (`user_id`),
  ADD UNIQUE KEY `uk_merchant_no` (`merchant_no`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `fa_merchant_audit`
--
ALTER TABLE `fa_merchant_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_merchant_id` (`merchant_id`);

--
-- 表的索引 `fa_mutual_task`
--
ALTER TABLE `fa_mutual_task`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_task_no` (`task_no`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `fa_profit_rule`
--
ALTER TABLE `fa_profit_rule`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_level_diff` (`level_diff`);

--
-- 表的索引 `fa_promo_bonus`
--
ALTER TABLE `fa_promo_bonus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_month` (`user_id`,`month`);

--
-- 表的索引 `fa_promo_bonus_config`
--
ALTER TABLE `fa_promo_bonus_config`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_promo_commission`
--
ALTER TABLE `fa_promo_commission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_source_user_id` (`source_user_id`),
  ADD KEY `idx_scene` (`scene`);

--
-- 表的索引 `fa_promo_level`
--
ALTER TABLE `fa_promo_level`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sort` (`sort`);

--
-- 表的索引 `fa_promo_performance`
--
ALTER TABLE `fa_promo_performance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_month` (`user_id`,`month`);

--
-- 表的索引 `fa_promo_relation`
--
ALTER TABLE `fa_promo_relation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_id` (`user_id`),
  ADD UNIQUE KEY `uk_invite_code` (`invite_code`),
  ADD KEY `idx_parent_id` (`parent_id`);

--
-- 表的索引 `fa_recharge`
--
ALTER TABLE `fa_recharge`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_order_no` (`order_no`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- 表的索引 `fa_reward_rule`
--
ALTER TABLE `fa_reward_rule`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_scene` (`scene`),
  ADD KEY `idx_reward_type` (`reward_type`);

--
-- 表的索引 `fa_sms`
--
ALTER TABLE `fa_sms`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_sub_task`
--
ALTER TABLE `fa_sub_task`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_task_no` (`task_no`),
  ADD KEY `idx_task_id` (`task_id`),
  ADD KEY `idx_from_user_id` (`from_user_id`),
  ADD KEY `idx_to_user_id` (`to_user_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `fa_test`
--
ALTER TABLE `fa_test`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_user`
--
ALTER TABLE `fa_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `email` (`email`),
  ADD KEY `mobile` (`mobile`);

--
-- 表的索引 `fa_user_group`
--
ALTER TABLE `fa_user_group`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_user_money_log`
--
ALTER TABLE `fa_user_money_log`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_user_rule`
--
ALTER TABLE `fa_user_rule`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_user_score_log`
--
ALTER TABLE `fa_user_score_log`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `fa_user_token`
--
ALTER TABLE `fa_user_token`
  ADD PRIMARY KEY (`token`);

--
-- 表的索引 `fa_version`
--
ALTER TABLE `fa_version`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 表的索引 `fa_wallet`
--
ALTER TABLE `fa_wallet`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_id` (`user_id`);

--
-- 表的索引 `fa_wallet_log`
--
ALTER TABLE `fa_wallet_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_biz` (`biz_type`,`biz_id`);

--
-- 表的索引 `fa_weixin_config`
--
ALTER TABLE `fa_weixin_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 表的索引 `fa_weixin_fans`
--
ALTER TABLE `fa_weixin_fans`
  ADD PRIMARY KEY (`fans_id`) USING BTREE,
  ADD KEY `idx_wxfans` (`unionid`,`openid`) USING BTREE;

--
-- 表的索引 `fa_weixin_news`
--
ALTER TABLE `fa_weixin_news`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 表的索引 `fa_weixin_reply`
--
ALTER TABLE `fa_weixin_reply`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `reply_type` (`reply_type`) USING BTREE;

--
-- 表的索引 `fa_weixin_template`
--
ALTER TABLE `fa_weixin_template`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `tempkey` (`tempkey`) USING BTREE;

--
-- 表的索引 `fa_weixin_user`
--
ALTER TABLE `fa_weixin_user`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `openid` (`openid`) USING BTREE;

--
-- 表的索引 `fa_withdraw`
--
ALTER TABLE `fa_withdraw`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_withdraw_no` (`withdraw_no`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `fa_admin`
--
ALTER TABLE `fa_admin`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `fa_admin_log`
--
ALTER TABLE `fa_admin_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=44;

--
-- 使用表AUTO_INCREMENT `fa_area`
--
ALTER TABLE `fa_area`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `fa_attachment`
--
ALTER TABLE `fa_attachment`
  MODIFY `id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `fa_auth_group`
--
ALTER TABLE `fa_auth_group`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `fa_auth_rule`
--
ALTER TABLE `fa_auth_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;

--
-- 使用表AUTO_INCREMENT `fa_category`
--
ALTER TABLE `fa_category`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- 使用表AUTO_INCREMENT `fa_config`
--
ALTER TABLE `fa_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- 使用表AUTO_INCREMENT `fa_ems`
--
ALTER TABLE `fa_ems`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `fa_merchant`
--
ALTER TABLE `fa_merchant`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `fa_merchant_audit`
--
ALTER TABLE `fa_merchant_audit`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_mutual_task`
--
ALTER TABLE `fa_mutual_task`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `fa_profit_rule`
--
ALTER TABLE `fa_profit_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `fa_promo_bonus`
--
ALTER TABLE `fa_promo_bonus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_promo_bonus_config`
--
ALTER TABLE `fa_promo_bonus_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `fa_promo_commission`
--
ALTER TABLE `fa_promo_commission`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_promo_level`
--
ALTER TABLE `fa_promo_level`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `fa_promo_performance`
--
ALTER TABLE `fa_promo_performance`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_promo_relation`
--
ALTER TABLE `fa_promo_relation`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `fa_recharge`
--
ALTER TABLE `fa_recharge`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `fa_reward_rule`
--
ALTER TABLE `fa_reward_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `fa_sms`
--
ALTER TABLE `fa_sms`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `fa_sub_task`
--
ALTER TABLE `fa_sub_task`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `fa_test`
--
ALTER TABLE `fa_test`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `fa_user`
--
ALTER TABLE `fa_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=10;

--
-- 使用表AUTO_INCREMENT `fa_user_group`
--
ALTER TABLE `fa_user_group`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `fa_user_money_log`
--
ALTER TABLE `fa_user_money_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_user_rule`
--
ALTER TABLE `fa_user_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- 使用表AUTO_INCREMENT `fa_user_score_log`
--
ALTER TABLE `fa_user_score_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_version`
--
ALTER TABLE `fa_version`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `fa_wallet`
--
ALTER TABLE `fa_wallet`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `fa_wallet_log`
--
ALTER TABLE `fa_wallet_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_weixin_config`
--
ALTER TABLE `fa_weixin_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- 使用表AUTO_INCREMENT `fa_weixin_fans`
--
ALTER TABLE `fa_weixin_fans`
  MODIFY `fans_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '粉丝ID';

--
-- 使用表AUTO_INCREMENT `fa_weixin_news`
--
ALTER TABLE `fa_weixin_news`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '图文消息表';

--
-- 使用表AUTO_INCREMENT `fa_weixin_reply`
--
ALTER TABLE `fa_weixin_reply`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '微信关键字回复id';

--
-- 使用表AUTO_INCREMENT `fa_weixin_template`
--
ALTER TABLE `fa_weixin_template`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '模板id', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `fa_weixin_user`
--
ALTER TABLE `fa_weixin_user`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `fa_withdraw`
--
ALTER TABLE `fa_withdraw`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
