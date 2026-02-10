-- MySQL dump 10.13  Distrib 5.7.43, for Linux (x86_64)
--
-- Host: localhost    Database: byhs_gynhc_com
-- ------------------------------------------------------
-- Server version	5.7.43-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `fa_admin`
--

DROP TABLE IF EXISTS `fa_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(20) DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) DEFAULT '' COMMENT '昵称',
  `password` varchar(32) DEFAULT '' COMMENT '密码',
  `salt` varchar(30) DEFAULT '' COMMENT '密码盐',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `email` varchar(100) DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) DEFAULT '' COMMENT '手机号码',
  `loginfailure` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) DEFAULT NULL COMMENT '登录IP',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(59) DEFAULT '' COMMENT 'Session标识',
  `status` varchar(30) NOT NULL DEFAULT 'normal' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_admin`
--

LOCK TABLES `fa_admin` WRITE;
/*!40000 ALTER TABLE `fa_admin` DISABLE KEYS */;
INSERT INTO `fa_admin` VALUES (1,'admin','Admin','ad03dc7ab8330457346e9421c56433cc','2cbc73','/uploads/20260122/3c6dc05388bec4a18110fb88563936eb.jpeg','admin@admin.com','',0,1770719364,'182.88.27.180',1491635035,1770719364,'6b655f75-26fc-49e8-94d9-ea10aa56b2be','normal');
/*!40000 ALTER TABLE `fa_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_admin_log`
--

DROP TABLE IF EXISTS `fa_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_admin_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `username` varchar(30) DEFAULT '' COMMENT '管理员名字',
  `url` varchar(1500) DEFAULT '' COMMENT '操作页面',
  `title` varchar(100) DEFAULT '' COMMENT '日志标题',
  `content` longtext NOT NULL COMMENT '内容',
  `ip` varchar(50) DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) DEFAULT '' COMMENT 'User-Agent',
  `createtime` bigint(16) DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `name` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COMMENT='管理员日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_admin_log`
--

LOCK TABLES `fa_admin_log` WRITE;
/*!40000 ALTER TABLE `fa_admin_log` DISABLE KEYS */;
INSERT INTO `fa_admin_log` VALUES (1,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013586),(2,1,'admin','/a.php/addon/install','插件管理','{\"name\":\"epay\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"1.3.15\",\"faversion\":\"1.6.1.20250430\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013615),(3,1,'admin','/a.php/addon/state','插件管理 / 禁用启用','{\"name\":\"epay\",\"action\":\"enable\",\"force\":\"0\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013615),(4,1,'admin','/a.php/addon/install','插件管理','{\"name\":\"weixin\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"3.0.6\",\"faversion\":\"1.6.1.20250430\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013663),(5,1,'admin','/a.php/addon/state','插件管理 / 禁用启用','{\"name\":\"weixin\",\"action\":\"enable\",\"force\":\"0\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013664),(6,1,'admin','/a.php/addon/install','插件管理','{\"name\":\"summernote\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"1.2.2\",\"faversion\":\"1.6.1.20250430\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013678),(7,1,'admin','/a.php/addon/state','插件管理 / 禁用启用','{\"name\":\"summernote\",\"action\":\"enable\",\"force\":\"0\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769013678),(8,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769043479),(9,1,'admin','/a.php/task/mutualtask/dispatchAll','任务管理 / 主任务列表','','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769043553),(10,1,'admin','/a.php/task/mutualtask/approve','任务管理 / 主任务列表','{\"ids\":\"3\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769043567),(11,1,'admin','/a.php/task/mutualtask/approve','任务管理 / 主任务列表','{\"ids\":\"3\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769043584),(12,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769067909),(13,1,'admin','/a.php/addon/install','插件管理','{\"name\":\"sdtheme\",\"force\":\"0\",\"uid\":\"26425\",\"token\":\"***\",\"version\":\"1.0.0\",\"faversion\":\"1.6.1.20250430\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769068019),(14,1,'admin','/a.php/addon/state','插件管理 / 禁用启用','{\"name\":\"sdtheme\",\"action\":\"enable\",\"force\":\"0\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769068019),(15,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769069754),(16,1,'admin','/a.php/index/login?url=/a.php/promo/performance?ref=addtabs','登录','{\"url\":\"\\/a.php\\/promo\\/performance?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.206','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769069810),(17,1,'admin','/a.php/general.config/edit','常规管理 / 系统配置 / 编辑','{\"__token__\":\"***\",\"row\":{\"name\":\"互助平台\",\"beian\":\"\",\"version\":\"1.0.3\",\"timezone\":\"Asia\\/Shanghai\",\"forbiddenip\":\"\",\"languages\":\"{&quot;backend&quot;:&quot;zh-cn&quot;,&quot;frontend&quot;:&quot;zh-cn&quot;}\",\"fixedpage\":\"dashboard\"}}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769070336),(18,1,'admin','/a.php/auth/rule/multi','权限管理 / 菜单规则','{\"action\":\"\",\"ids\":\"4\",\"params\":\"ismenu=0\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769070378),(19,1,'admin','/a.php/auth/rule/edit/ids/161?dialog=1','权限管理 / 菜单规则 / 编辑','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"weixin\",\"title\":\"公众号管理\",\"url\":\"\",\"icon\":\"fa fa-weixin\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"161\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769070387),(20,1,'admin','/a.php/task/mutualtask/approve/ids/3','任务管理 / 主任务列表 / 审核通过','{\"ids\":\"3\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769070731),(21,1,'admin','/a.php/ajax/upload','','{\"category\":\"\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071473),(22,1,'admin','/a.php/ajax/upload','','{\"category\":\"\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071479),(23,1,'admin','/a.php/general.profile/update','常规管理 / 个人资料 / 更新个人信息','{\"__token__\":\"***\",\"row\":{\"avatar\":\"\\/uploads\\/20260122\\/fa7bee50fc7af6fdf31694cee4b9972b.png\",\"email\":\"admin@admin.com\",\"nickname\":\"Admin\",\"password\":\"***\"}}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071482),(24,1,'admin','/a.php/ajax/upload','','{\"category\":\"\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071507),(25,1,'admin','/a.php/general.profile/update','常规管理 / 个人资料 / 更新个人信息','{\"__token__\":\"***\",\"row\":{\"avatar\":\"\\/uploads\\/20260122\\/3c6dc05388bec4a18110fb88563936eb.jpeg\",\"email\":\"admin@admin.com\",\"nickname\":\"Admin\",\"password\":\"***\"}}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071509),(26,1,'admin','/a.php/ajax/upload','','{\"category\":\"\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071545),(27,1,'admin','/a.php/ajax/upload','','{\"category\":\"\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071585),(28,1,'admin','/a.php/ajax/upload','','{\"category\":\"\"}','111.85.26.206','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769071608),(29,1,'admin','/a.php/index/login?url=/a.php/wallet/wallet?ref=addtabs','登录','{\"url\":\"\\/a.php\\/wallet\\/wallet?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166348),(30,1,'admin','/a.php/task/mutualtask/approve/ids/3','任务管理 / 主任务列表','{\"ids\":\"3\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166413),(31,1,'admin','/a.php/merchant/merchant/disable/ids/1','商户管理 / 商户列表','{\"ids\":\"1\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166594),(32,1,'admin','/a.php/merchant/merchant/disable/ids/1','商户管理 / 商户列表','{\"ids\":\"1\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166597),(33,1,'admin','/a.php/task/mutualtask/approve/ids/3','任务管理 / 主任务列表','{\"ids\":\"3\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166618),(34,1,'admin','/a.php/promo/level/edit/ids/5?dialog=1','推广管理 / 等级配置','{\"dialog\":\"1\",\"row\":{\"name\":\"钻石会员\",\"sort\":\"4\",\"upgrade_type\":\"performance\",\"upgrade_price\":\"30000.00\",\"personal_performance_min\":\"1500000.00\",\"team_performance_min\":\"10000000.00\",\"direct_invite_min\":\"50\",\"commission_rate\":\"0.0080\",\"status\":\"normal\"},\"ids\":\"5\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166738),(35,1,'admin','/a.php/promo/level/edit/ids/4?dialog=1','推广管理 / 等级配置','{\"dialog\":\"1\",\"row\":{\"name\":\"铂金会员\",\"sort\":\"3\",\"upgrade_type\":\"performance\",\"upgrade_price\":\"10000.00\",\"personal_performance_min\":\"500000.00\",\"team_performance_min\":\"2000000.00\",\"direct_invite_min\":\"20\",\"commission_rate\":\"0.0050\",\"status\":\"normal\"},\"ids\":\"4\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769166745),(36,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.196','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769237072),(37,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','111.85.26.195','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769362181),(38,1,'admin','/a.php/promo/level/edit/ids/5?dialog=1','推广管理 / 等级配置','{\"dialog\":\"1\",\"row\":{\"name\":\"钻石会员\",\"sort\":\"4\",\"upgrade_type\":\"performance\",\"upgrade_price\":\"30000.00\",\"personal_performance_min\":\"1500000.00\",\"team_performance_min\":\"10000000.00\",\"direct_invite_min\":\"50\",\"commission_rate\":\"0.0080\",\"status\":\"normal\"},\"ids\":\"5\"}','111.85.26.195','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769362209),(39,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','117.188.14.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769484928),(40,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','142.91.99.238','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1769484946),(41,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770008303),(42,1,'admin','/a.php/index/login?url=/a.php/merchant/merchant?addtabs=1','登录','{\"url\":\"\\/a.php\\/merchant\\/merchant?addtabs=1\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770036987),(43,1,'admin','/a.php/index/login?url=/a.php/merchant/merchant/detail/ids/3?addtabs=1','登录','{\"url\":\"\\/a.php\\/merchant\\/merchant\\/detail\\/ids\\/3?addtabs=1\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770085095),(44,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','171.36.79.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770310682),(45,1,'admin','/a.php/user/user/edit/ids/2?dialog=1','会员管理 / 会员管理 / 编辑','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"2\",\"group_id\":\"1\",\"username\":\"testuser\",\"nickname\":\"测试\",\"password\":\"***\",\"email\":\"\",\"mobile\":\"13800138000\",\"avatar\":\"\",\"level\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"0.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"1970-01-01 08:00:00\",\"logintime\":\"1970-01-01 08:00:00\",\"loginip\":\"0\",\"loginfailure\":\"0\",\"joinip\":\"0\",\"jointime\":\"1970-01-01 08:00:00\",\"status\":\"normal\"},\"ids\":\"2\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770365528),(46,1,'admin','/a.php/index/login?url=/a.php/user/user?ref=addtabs','登录','{\"url\":\"\\/a.php\\/user\\/user?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770521609),(47,1,'admin','/a.php/auth/rule/add?dialog=1','权限管理 / 菜单规则 / 添加','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"wallet\\/Bankcard\",\"title\":\"银行卡管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"}}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770522194),(48,1,'admin','/a.php/auth/rule/edit/ids/293?dialog=1','权限管理 / 菜单规则 / 编辑','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"280\",\"name\":\"wallet\\/Bankcard\",\"title\":\"银行卡管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"293\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770522284),(49,1,'admin','/a.php/auth/rule/del','权限管理 / 菜单规则 / 删除','{\"action\":\"del\",\"ids\":\"293\",\"params\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770522385),(50,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"row\":{\"type\":\"system\",\"title\":\"系统上线\",\"content\":\"测试一下\"},\"send_all\":\"1\",\"user_ids\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770523550),(51,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"row\":{\"type\":\"system\",\"title\":\"系统上线\",\"content\":\"测试一下\"},\"send_all\":\"1\",\"user_ids\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770523560),(52,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770525920),(53,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770525942),(54,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"测试一下\",\"content\":\"测试指定用户发送消息\"},\"send_all\":\"0\",\"user_ids_text\":\"\",\"user_ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770525973),(55,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"测试一下\",\"content\":\"测试指定用户发送消息\"},\"send_all\":\"0\",\"user_ids_text\":\"\",\"user_ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770525999),(56,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"测试一下\",\"content\":\"测试指定用户发送消息\"},\"send_all\":\"0\",\"user_ids_text\":\"\",\"user_ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526084),(57,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"测试一下\",\"content\":\"测试指定用户发送消息\"},\"send_all\":\"0\",\"user_ids_text\":\"\",\"user_ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526127),(58,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"测试一下\",\"content\":\"测试指定用户发送消息\"},\"send_all\":\"0\",\"user_ids_text\":\"\",\"user_ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526301),(59,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526531),(60,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"138\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"138\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526533),(61,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"13800\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"13800\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526538),(62,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"1380013800\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"1380013800\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526541),(63,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"1\",\"content\":\"1\"},\"send_all\":\"0\",\"user_ids_text\":\"1380013800\",\"user_ids\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526544),(64,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526558),(65,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"1380013800\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"1380013800\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526559),(66,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"1380013800\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"1380013800\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526561),(67,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"13800138000\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"13800138000\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526575),(68,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"13800138000\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"13800138000\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526581),(69,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"1\",\"content\":\"1\"},\"send_all\":\"0\",\"user_ids_text\":\"13800138000\",\"user_ids\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526627),(70,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526796),(71,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"138\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"138\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526797),(72,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"1380013800\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"1380013800\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526801),(73,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"13800138000\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"13800138000\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526802),(74,1,'admin','/a.php/message/searchuser','消息管理','{\"q_word\":[\"\"],\"pageNumber\":\"1\",\"pageSize\":\"10\",\"andOr\":\"OR \",\"orderBy\":[[\"name\",\"ASC\"]],\"searchTable\":\"tbl\",\"showField\":\"name\",\"keyField\":\"id\",\"searchField\":[\"name\"],\"name\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526804),(75,1,'admin','/a.php/message/add?dialog=1','消息管理 / 发送消息','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"type\":\"system\",\"title\":\"1\",\"content\":\"1\"},\"send_all\":\"0\",\"user_ids_text\":\"\",\"user_ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770526806),(76,1,'admin','/a.php/auth/rule/edit/ids/307?dialog=1','权限管理 / 菜单规则 / 编辑','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"289\",\"name\":\"config\\/bank_config\",\"title\":\"银行配置\",\"url\":\"\",\"icon\":\"fa fa-bank\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"管理系统支持的银行列表\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"307\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770532440),(77,1,'admin','/a.php/auth/rule/del','权限管理 / 菜单规则 / 删除','{\"action\":\"del\",\"ids\":\"306\",\"params\":\"\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770532449),(78,1,'admin','/a.php/merchant/application/approve','商户管理 / 进件管理 / 审核通过','{\"ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541735),(79,1,'admin','/a.php/merchant/application/approve','商户管理 / 进件管理 / 审核通过','{\"ids\":\"2\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541735),(80,1,'admin','/a.php/merchant/application/approve','商户管理 / 进件管理 / 审核通过','{\"ids\":\"1\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541744),(81,1,'admin','/a.php/merchant/application/approve','商户管理 / 进件管理 / 审核通过','{\"ids\":\"1\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541870),(82,1,'admin','/a.php/merchant/application/approve','商户管理 / 进件管理 / 审核通过','{\"ids\":\"1\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541871),(83,1,'admin','/a.php/merchant/application/approve','商户管理 / 进件管理 / 审核通过','{\"ids\":\"1\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541915),(84,1,'admin','/a.php/merchant/application/reject','商户管理 / 进件管理 / 审核驳回','{\"ids\":\"1\",\"reason\":\"资料不完整\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770541957),(85,1,'admin','/a.php/task/tasktype/edit/ids/1?dialog=1','任务管理 / 任务类型 / 编辑','{\"dialog\":\"1\",\"row\":{\"name\":\"电商推广\",\"code\":\"ecommerce\",\"icon\":\"\",\"description\":\"电商平台推广任务\",\"sort\":\"1\",\"status\":\"normal\"},\"ids\":\"1\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770543250),(86,1,'admin','/a.php/task/mutualtask/approve','任务管理 / 主任务列表','{\"ids\":\"6\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770547206),(87,1,'admin','/a.php/auth/rule/multi','权限管理 / 菜单规则','{\"action\":\"\",\"ids\":\"4\",\"params\":\"ismenu=1\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770550765),(88,1,'admin','/a.php/auth/rule/multi','权限管理 / 菜单规则','{\"action\":\"\",\"ids\":\"4\",\"params\":\"ismenu=0\"}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770550797),(89,1,'admin','/a.php/wallet/recharge/confirm','钱包管理 / 充值管理 / 确认到账','{\"ids\":\"11\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770551824),(90,1,'admin','/a.php/wallet/recharge/confirm','钱包管理 / 充值管理 / 确认到账','{\"ids\":\"11\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770551833),(91,1,'admin','/a.php/user/user/edit/ids/3?dialog=1','会员管理 / 会员管理 / 编辑','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"3\",\"group_id\":\"1\",\"username\":\"acceptuser\",\"nickname\":\"测试2\",\"password\":\"***\",\"email\":\"\",\"mobile\":\"13900139000\",\"avatar\":\"\",\"level\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"0.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"1970-01-01 08:00:00\",\"logintime\":\"1970-01-01 08:00:00\",\"loginip\":\"0\",\"loginfailure\":\"2\",\"joinip\":\"0\",\"jointime\":\"1970-01-01 08:00:00\",\"status\":\"normal\"},\"ids\":\"3\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770552017),(92,1,'admin','/a.php/wallet/recharge/confirm','钱包管理 / 充值管理 / 确认到账','{\"ids\":\"12\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770552794),(93,1,'admin','/a.php/wallet/recharge/confirm','钱包管理 / 充值管理 / 确认到账','{\"ids\":\"12\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770552805),(94,1,'admin','/a.php/wallet/recharge/confirm','钱包管理 / 充值管理 / 确认到账','{\"ids\":\"13\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770552817),(95,1,'admin','/a.php/wallet/recharge/confirm','钱包管理 / 充值管理 / 确认到账','{\"ids\":\"14\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770553221),(96,1,'admin','/a.php/general/config/check','常规管理 / 系统配置','{\"row\":{\"name\":\"logo\"}}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770595004),(97,1,'admin','/a.php/general.config/add','常规管理 / 系统配置 / 添加','{\"__token__\":\"***\",\"row\":{\"group\":\"basic\",\"type\":\"image\",\"name\":\"logo\",\"title\":\"LOGO\",\"setting\":{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"},\"value\":\"\",\"content\":\"value1|title1\\r\\nvalue2|title2\",\"tip\":\"\",\"rule\":\"\",\"visible\":\"\",\"extend\":\"\"}}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770595034),(98,1,'admin','/a.php/wallet/withdraw/approve','钱包管理 / 提现审核','{\"ids\":\"3\"}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770599820),(99,1,'admin','/a.php/wallet/withdraw/approve','钱包管理 / 提现审核','{\"ids\":\"4\"}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770600776),(100,1,'admin','/a.php/user/feedback/reply/ids/1?dialog=1','会员管理 / 工单反馈 / 回复','{\"dialog\":\"1\",\"__token__\":\"***\",\"ids\":\"1\",\"reply\":\"22222222\"}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770601101),(101,1,'admin','/a.php/general.config/edit','常规管理 / 系统配置 / 编辑','{\"__token__\":\"***\",\"row\":{\"categorytype\":\"{&quot;default&quot;:&quot;默认&quot;,&quot;page&quot;:&quot;单页&quot;,&quot;article&quot;:&quot;文章&quot;,&quot;test&quot;:&quot;Test&quot;}\",\"configgroup\":\"{&quot;basic&quot;:&quot;基础配置&quot;,&quot;email&quot;:&quot;邮件配置&quot;,&quot;dictionary&quot;:&quot;字典配置&quot;,&quot;user&quot;:&quot;会员配置&quot;,&quot;promo&quot;:&quot;推广配置&quot;}\",\"attachmentcategory\":\"{&quot;category1&quot;:&quot;分类一&quot;,&quot;category2&quot;:&quot;分类二&quot;,&quot;custom&quot;:&quot;自定义&quot;}\"}}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770604187),(102,1,'admin','/a.php/general.config/edit','常规管理 / 系统配置 / 编辑','{\"__token__\":\"***\",\"row\":{\"bonus_calculate_day\":\"1\",\"bonus_settle_day\":\"3\"}}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770604210),(103,1,'admin','/a.php/promo/level/add?dialog=1','推广管理 / 等级配置','{\"dialog\":\"1\",\"row\":{\"name\":\"省级代理\",\"sort\":\"0\",\"upgrade_type\":\"purchase\",\"upgrade_price\":\"1000000.00\",\"personal_performance_min\":\"0.00\",\"team_performance_min\":\"0.00\",\"direct_invite_min\":\"0\",\"commission_rate\":\"0.0100\",\"status\":\"normal\"}}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770605338),(104,1,'admin','/a.php/config/reward/add?dialog=1','奖励规则','{\"dialog\":\"1\",\"row\":{\"name\":\"省级奖励\",\"scene\":\"merchant_entry\",\"reward_type\":\"peer\",\"target_depth\":\"1\",\"amount_type\":\"fixed\",\"amount_value\":\"0.0000\",\"level_require\":\"6\",\"growth_min\":\"0.00\",\"status\":\"normal\"}}','89.185.27.147','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770605447),(105,1,'admin','/a.php/user/certification/approve','会员管理 / 实名认证 / 审核通过','{\"ids\":\"1\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770619394),(106,1,'admin','/a.php/user/certification/approve','会员管理 / 实名认证 / 审核通过','{\"ids\":\"1\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770619640),(107,1,'admin','/a.php/user/certification/approve/ids/1','会员管理 / 实名认证 / 审核通过','{\"ids\":\"1\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770619644),(108,1,'admin','/a.php/addon/install','插件管理','{\"name\":\"qcloudsms\",\"force\":\"0\",\"uid\":\"41587\",\"token\":\"***\",\"version\":\"1.0.4\",\"faversion\":\"1.6.1.20250430\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770620089),(109,1,'admin','/a.php/addon/state','插件管理 / 禁用启用','{\"name\":\"qcloudsms\",\"action\":\"enable\",\"force\":\"0\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770620089),(110,1,'admin','/a.php/addon/config?name=qcloudsms&dialog=1','插件管理 / 配置','{\"name\":\"qcloudsms\",\"dialog\":\"1\",\"row\":{\"appid\":\"1\",\"appkey\":\"2\",\"voiceAppid\":\"3\",\"voiceAppkey\":\"4\",\"sign\":\"your sign\",\"isVoice\":\"0\",\"isTemplateSender\":\"1\",\"template\":\"{&quot;register&quot;:&quot;1&quot;,&quot;resetpwd&quot;:&quot;1&quot;,&quot;changepwd&quot;:&quot;1&quot;,&quot;changemobile&quot;:&quot;1&quot;,&quot;profile&quot;:&quot;1&quot;,&quot;notice&quot;:&quot;1&quot;,&quot;mobilelogin&quot;:&quot;1&quot;,&quot;bind&quot;:&quot;1&quot;}\",\"voiceTemplate\":\"{&quot;register&quot;:&quot;&quot;,&quot;resetpwd&quot;:&quot;&quot;,&quot;changepwd&quot;:&quot;&quot;,&quot;changemobile&quot;:&quot;&quot;,&quot;profile&quot;:&quot;&quot;,&quot;notice&quot;:&quot;&quot;,&quot;mobilelogin&quot;:&quot;&quot;,&quot;bind&quot;:&quot;&quot;}\"}}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770620145),(111,1,'admin','/a.php/addon/install','插件管理','{\"name\":\"third\",\"force\":\"0\",\"uid\":\"41587\",\"token\":\"***\",\"version\":\"1.4.7\",\"faversion\":\"1.6.1.20250430\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770620336),(112,1,'admin','/a.php/addon/state','插件管理 / 禁用启用','{\"name\":\"third\",\"action\":\"enable\",\"force\":\"0\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770620336),(113,1,'admin','/a.php/index/login?url=/a.php/third?addtabs=1','登录','{\"url\":\"\\/a.php\\/third?addtabs=1\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770628843),(114,1,'admin','/a.php/addon/config?name=third&dialog=1','插件管理 / 配置','{\"name\":\"third\",\"dialog\":\"1\",\"row\":{\"qq\":\"{&quot;app_id&quot;:&quot;100000000&quot;,&quot;app_secret&quot;:&quot;123456&quot;,&quot;scope&quot;:&quot;get_user_info&quot;}\",\"wechat\":\"{&quot;app_id&quot;:&quot;100000000&quot;,&quot;app_secret&quot;:&quot;123456&quot;,&quot;scope&quot;:&quot;snsapi_userinfo&quot;}\",\"wechatweb\":\"{&quot;app_id&quot;:&quot;100000000&quot;,&quot;app_secret&quot;:&quot;123456&quot;,&quot;scope&quot;:&quot;snsapi_login&quot;}\",\"weibo\":\"{&quot;app_id&quot;:&quot;100000000&quot;,&quot;app_secret&quot;:&quot;123456&quot;,&quot;scope&quot;:&quot;get_user_info&quot;}\",\"wechatmini\":\"{&quot;app_id&quot;:&quot;wxfc84dc92f28575c8&quot;,&quot;app_secret&quot;:&quot;xxxx&quot;}\",\"wechatapp\":\"{&quot;app_id&quot;:&quot;&quot;,&quot;app_secret&quot;:&quot;&quot;}\",\"bindaccount\":\"1\",\"status\":[\"qq\",\"wechat\",\"weibo\"],\"rewrite\":\"{&quot;index\\\\\\/index&quot;:&quot;\\\\\\/third$&quot;,&quot;index\\\\\\/connect&quot;:&quot;\\\\\\/third\\\\\\/connect\\\\\\/[:platform]&quot;,&quot;index\\\\\\/callback&quot;:&quot;\\\\\\/third\\\\\\/callback\\\\\\/[:platform]&quot;,&quot;index\\\\\\/bind&quot;:&quot;\\\\\\/third\\\\\\/bind\\\\\\/[:platform]&quot;,&quot;index\\\\\\/unbind&quot;:&quot;\\\\\\/third\\\\\\/unbind\\\\\\/[:platform]&quot;}\"}}','23.106.44.146','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770629792),(115,0,'Unknown','/a.php/index/logout','','{\"__token__\":\"***\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770630782),(116,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"keeplogin\":\"1\"}','1.204.115.220','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.68(0x18004433) NetType/WIFI Language/zh_CN',1770630915),(117,0,'Unknown','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admib\",\"password\":\"***\",\"keeplogin\":\"1\"}','116.171.6.178','Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 SP-engine/3.55.0 main/1.0 baiduboxapp/15.47.1.11 (Baidu; P2 18.6.2) NABar/1.0 themeUA=Theme/default',1770640443),(118,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"keeplogin\":\"1\"}','116.171.6.178','Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 SP-engine/3.55.0 main/1.0 baiduboxapp/15.47.1.11 (Baidu; P2 18.6.2) NABar/1.0 themeUA=Theme/default',1770640451),(119,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770642941),(120,1,'admin','/a.php/merchant/merchant/approve','商户管理 / 商户列表','{\"ids\":\"4\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770645134),(121,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"keeplogin\":\"1\"}','1.49.149.218','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770701176),(122,1,'admin','/a.php/index/login','登录','{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770719364),(123,1,'admin','/a.php/user/user/edit/ids/5?dialog=1','会员管理 / 会员管理 / 编辑','{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"5\",\"group_id\":\"1\",\"username\":\"testuser2\",\"nickname\":\"测试用户2\",\"password\":\"***\",\"email\":\"\",\"mobile\":\"13800138002\",\"avatar\":\"\",\"level\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"0.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"1970-01-01 08:00:00\",\"logintime\":\"1970-01-01 08:00:00\",\"loginip\":\"0\",\"loginfailure\":\"0\",\"joinip\":\"0\",\"jointime\":\"1970-01-01 08:00:00\",\"status\":\"normal\"},\"ids\":\"5\"}','182.88.27.180','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1770719426);
/*!40000 ALTER TABLE `fa_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_area`
--

DROP TABLE IF EXISTS `fa_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_area` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
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
  `lat` varchar(100) DEFAULT NULL COMMENT '纬度',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='地区表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_area`
--

LOCK TABLES `fa_area` WRITE;
/*!40000 ALTER TABLE `fa_area` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_attachment`
--

DROP TABLE IF EXISTS `fa_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_attachment` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category` varchar(50) DEFAULT '' COMMENT '类别',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `url` varchar(255) DEFAULT '' COMMENT '物理路径',
  `imagewidth` int(10) unsigned DEFAULT '0' COMMENT '宽度',
  `imageheight` int(10) unsigned DEFAULT '0' COMMENT '高度',
  `imagetype` varchar(30) DEFAULT '' COMMENT '图片类型',
  `imageframes` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '图片帧数',
  `filename` varchar(100) DEFAULT '' COMMENT '文件名称',
  `filesize` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文件大小',
  `mimetype` varchar(100) DEFAULT '' COMMENT 'mime类型',
  `extparam` varchar(255) DEFAULT '' COMMENT '透传数据',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建日期',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `uploadtime` bigint(16) DEFAULT NULL COMMENT '上传时间',
  `storage` varchar(100) NOT NULL DEFAULT 'local' COMMENT '存储位置',
  `sha1` varchar(40) DEFAULT '' COMMENT '文件 sha1编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COMMENT='附件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_attachment`
--

LOCK TABLES `fa_attachment` WRITE;
/*!40000 ALTER TABLE `fa_attachment` DISABLE KEYS */;
INSERT INTO `fa_attachment` VALUES (1,'',1,0,'/assets/img/qrcode.png',150,150,'png',0,'qrcode.png',21859,'image/png','',1491635035,1491635035,1491635035,'local','17163603d0263e4838b9387ff2cd4877e8b018f6'),(2,'',1,0,'/uploads/20260122/e01d83ec44f5b6bb9791babf17ff7d13.png',3068,16385,'png',0,'电商平台.png',3529808,'image/png','',1769071473,1769071473,1769071473,'local','aa701c561e567038ef1772d3c03464b3960fb4f1'),(3,'',1,0,'/uploads/20260122/fa7bee50fc7af6fdf31694cee4b9972b.png',200,200,'png',0,'啤酒.png',2892,'image/png','',1769071479,1769071479,1769071479,'local','0ae706fe828d332efb1d7f362937f9cfa21e71c7'),(4,'',1,0,'/uploads/20260122/3c6dc05388bec4a18110fb88563936eb.jpeg',500,500,'jpeg',0,'ecf8f4ea1fc93d19b5e53afdcf1be041.jpeg',19954,'image/jpeg','',1769071507,1769071507,1769071507,'local','b2fae927eaab292007230c8c5827f0f640695dfb'),(5,'',1,0,'/uploads/20260122/f5641c49313e077c0f9380a8e8e2a3bd.jpg',430,430,'jpg',0,'202577.jpg',29692,'image/jpeg','',1769071545,1769071545,1769071545,'local','56fcd91d41c76118af00b852ea64c057d76e74d1'),(6,'',1,0,'/uploads/20260122/d5483c86eabfdce11d988a144e0fb557.png',1533,752,'png',0,'blank-view.png',47560,'image/png','',1769071585,1769071585,1769071585,'local','039674621765021ceca62aa3c538442313ce4c44'),(7,'',1,0,'/uploads/20260122/88bbbe2e6045bf23eaa2acca639e6e7f.png',1861,1090,'png',0,'微信截图_20240822140711.png',419771,'image/png','',1769071608,1769071608,1769071608,'local','053cd42a34c1a9b3200656aa28dccc7d1d34be71'),(8,'',0,2,'/uploads/20260208/c27e294a3aedd96d5b864f93dcf780d5.png',300,300,'png',0,'234.png',101507,'image/png','',1770535535,1770535535,1770535535,'local','a2b07816ccc73c1a04d76927c19be65513b83166'),(9,'',0,2,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png',300,300,'png',0,'234.png',101507,'image/png','',1770601779,1770601779,1770601779,'local','a2b07816ccc73c1a04d76927c19be65513b83166'),(10,'',0,11,'/uploads/20260209/3ff4883ec234501b06261f0844be4688.jpeg',2160,2880,'jpeg',0,'IMG_9688.jpeg',766600,'image/jpeg','',1770639719,1770639719,1770639719,'local','ce20818417b511f8c6b3f216c19d94c2f0eb68c4'),(11,'',0,11,'/uploads/20260209/6993876000bec9b8ac4004d0be049680.jpeg',2736,3648,'jpeg',0,'IMG_3508.jpeg',1633041,'image/jpeg','',1770639740,1770639740,1770639740,'local','d519be1ff674eb68ae18258c371189e602b19cbc'),(12,'',0,11,'/uploads/20260209/89565dcbde40947a0d7ea51c35c8f373.jpg',3072,4096,'jpg',0,'1770642142526.jpg',1994275,'image/jpeg','',1770642153,1770642153,1770642153,'local','75fb08c74991ffb34e2d7b3ecf815e5dbeec8091'),(13,'',0,11,'/uploads/20260209/04f6837430d1f6d1d767aadef6228a65.jpeg',2160,2880,'jpeg',0,'IMG_9687.jpeg',781560,'image/jpeg','',1770643871,1770643871,1770643871,'local','c92e469fe37aa41acdda3da7bd5865d4ff750993'),(14,'',0,11,'/uploads/20260209/5419a19daca08d6abcfcb22838db3b1c.jpeg',2160,2880,'jpeg',0,'IMG_9913.jpeg',781667,'image/jpeg','',1770644005,1770644005,1770644005,'local','b408ee803bf04ee094e1b92a1e7409ada0f9e9be');
/*!40000 ALTER TABLE `fa_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_auth_group`
--

DROP TABLE IF EXISTS `fa_auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_auth_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父组别',
  `name` varchar(100) DEFAULT '' COMMENT '组名',
  `rules` text NOT NULL COMMENT '规则ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `status` varchar(30) DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='分组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_auth_group`
--

LOCK TABLES `fa_auth_group` WRITE;
/*!40000 ALTER TABLE `fa_auth_group` DISABLE KEYS */;
INSERT INTO `fa_auth_group` VALUES (1,0,'Admin group','*',1491635035,1491635035,'normal'),(2,1,'Second group','13,14,16,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,40,41,42,43,44,45,46,47,48,49,50,55,56,57,58,59,60,61,62,63,64,65,1,9,10,11,7,6,8,2,4,5',1491635035,1491635035,'normal'),(3,2,'Third group','1,4,9,10,11,13,14,15,16,17,40,41,42,43,44,45,46,47,48,49,50,55,56,57,58,59,60,61,62,63,64,65,5',1491635035,1491635035,'normal'),(4,1,'Second group 2','1,4,13,14,15,16,17,55,56,57,58,59,60,61,62,63,64,65',1491635035,1491635035,'normal'),(5,2,'Third group 2','1,2,6,7,8,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34',1491635035,1491635035,'normal');
/*!40000 ALTER TABLE `fa_auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_auth_group_access`
--

DROP TABLE IF EXISTS `fa_auth_group_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_auth_group_access` (
  `uid` int(10) unsigned NOT NULL COMMENT '会员ID',
  `group_id` int(10) unsigned NOT NULL COMMENT '级别ID',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限分组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_auth_group_access`
--

LOCK TABLES `fa_auth_group_access` WRITE;
/*!40000 ALTER TABLE `fa_auth_group_access` DISABLE KEYS */;
INSERT INTO `fa_auth_group_access` VALUES (1,1);
/*!40000 ALTER TABLE `fa_auth_group_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_auth_rule`
--

DROP TABLE IF EXISTS `fa_auth_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_auth_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('menu','file') NOT NULL DEFAULT 'file' COMMENT 'menu为菜单,file为权限节点',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父ID',
  `name` varchar(100) DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) DEFAULT '' COMMENT '规则名称',
  `icon` varchar(50) DEFAULT '' COMMENT '图标',
  `url` varchar(255) DEFAULT '' COMMENT '规则URL',
  `condition` varchar(255) DEFAULT '' COMMENT '条件',
  `remark` varchar(255) DEFAULT '' COMMENT '备注',
  `ismenu` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否为菜单',
  `menutype` enum('addtabs','blank','dialog','ajax') DEFAULT NULL COMMENT '菜单类型',
  `extend` varchar(255) DEFAULT '' COMMENT '扩展属性',
  `py` varchar(30) DEFAULT '' COMMENT '拼音首字母',
  `pinyin` varchar(100) DEFAULT '' COMMENT '拼音',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `pid` (`pid`),
  KEY `weigh` (`weigh`)
) ENGINE=InnoDB AUTO_INCREMENT=349 DEFAULT CHARSET=utf8mb4 COMMENT='节点表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_auth_rule`
--

LOCK TABLES `fa_auth_rule` WRITE;
/*!40000 ALTER TABLE `fa_auth_rule` DISABLE KEYS */;
INSERT INTO `fa_auth_rule` VALUES (1,'file',0,'dashboard','Dashboard','fa fa-dashboard','','','Dashboard tips',1,NULL,'','kzt','kongzhitai',1491635035,1491635035,143,'normal'),(2,'file',0,'general','General','fa fa-cogs','','','',1,NULL,'','cggl','changguiguanli',1491635035,1491635035,137,'normal'),(3,'file',0,'category','Category','fa fa-leaf','','','Category tips',0,NULL,'','flgl','fenleiguanli',1491635035,1491635035,119,'normal'),(4,'file',0,'addon','Addon','fa fa-rocket','','','Addon tips',0,NULL,'','cjgl','chajianguanli',1491635035,1770550797,0,'normal'),(5,'file',0,'auth','Auth','fa fa-group','','','',1,NULL,'','qxgl','quanxianguanli',1491635035,1491635035,99,'normal'),(6,'file',2,'general/config','Config','fa fa-cog','','','Config tips',1,NULL,'','xtpz','xitongpeizhi',1491635035,1491635035,60,'normal'),(7,'file',2,'general/attachment','Attachment','fa fa-file-image-o','','','Attachment tips',1,NULL,'','fjgl','fujianguanli',1491635035,1491635035,53,'normal'),(8,'file',2,'general/profile','Profile','fa fa-user','','','',1,NULL,'','grzl','gerenziliao',1491635035,1491635035,34,'normal'),(9,'file',5,'auth/admin','Admin','fa fa-user','','','Admin tips',1,NULL,'','glygl','guanliyuanguanli',1491635035,1491635035,118,'normal'),(10,'file',5,'auth/adminlog','Admin log','fa fa-list-alt','','','Admin log tips',1,NULL,'','glyrz','guanliyuanrizhi',1491635035,1491635035,113,'normal'),(11,'file',5,'auth/group','Group','fa fa-group','','','Group tips',1,NULL,'','jsz','juesezu',1491635035,1491635035,109,'normal'),(12,'file',5,'auth/rule','Rule','fa fa-bars','','','Rule tips',1,NULL,'','cdgz','caidanguize',1491635035,1491635035,104,'normal'),(13,'file',1,'dashboard/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,136,'normal'),(14,'file',1,'dashboard/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,135,'normal'),(15,'file',1,'dashboard/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,133,'normal'),(16,'file',1,'dashboard/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,134,'normal'),(17,'file',1,'dashboard/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,132,'normal'),(18,'file',6,'general/config/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,52,'normal'),(19,'file',6,'general/config/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,51,'normal'),(20,'file',6,'general/config/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,50,'normal'),(21,'file',6,'general/config/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,49,'normal'),(22,'file',6,'general/config/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,48,'normal'),(23,'file',7,'general/attachment/index','View','fa fa-circle-o','','','Attachment tips',0,NULL,'','','',1491635035,1491635035,59,'normal'),(24,'file',7,'general/attachment/select','Select attachment','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,58,'normal'),(25,'file',7,'general/attachment/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,57,'normal'),(26,'file',7,'general/attachment/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,56,'normal'),(27,'file',7,'general/attachment/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,55,'normal'),(28,'file',7,'general/attachment/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,54,'normal'),(29,'file',8,'general/profile/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,33,'normal'),(30,'file',8,'general/profile/update','Update profile','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,32,'normal'),(31,'file',8,'general/profile/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,31,'normal'),(32,'file',8,'general/profile/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,30,'normal'),(33,'file',8,'general/profile/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,29,'normal'),(34,'file',8,'general/profile/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,28,'normal'),(35,'file',3,'category/index','View','fa fa-circle-o','','','Category tips',0,NULL,'','','',1491635035,1491635035,142,'normal'),(36,'file',3,'category/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,141,'normal'),(37,'file',3,'category/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,140,'normal'),(38,'file',3,'category/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,139,'normal'),(39,'file',3,'category/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,138,'normal'),(40,'file',9,'auth/admin/index','View','fa fa-circle-o','','','Admin tips',0,NULL,'','','',1491635035,1491635035,117,'normal'),(41,'file',9,'auth/admin/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,116,'normal'),(42,'file',9,'auth/admin/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,115,'normal'),(43,'file',9,'auth/admin/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,114,'normal'),(44,'file',10,'auth/adminlog/index','View','fa fa-circle-o','','','Admin log tips',0,NULL,'','','',1491635035,1491635035,112,'normal'),(45,'file',10,'auth/adminlog/detail','Detail','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,111,'normal'),(46,'file',10,'auth/adminlog/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,110,'normal'),(47,'file',11,'auth/group/index','View','fa fa-circle-o','','','Group tips',0,NULL,'','','',1491635035,1491635035,108,'normal'),(48,'file',11,'auth/group/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,107,'normal'),(49,'file',11,'auth/group/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,106,'normal'),(50,'file',11,'auth/group/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,105,'normal'),(51,'file',12,'auth/rule/index','View','fa fa-circle-o','','','Rule tips',0,NULL,'','','',1491635035,1491635035,103,'normal'),(52,'file',12,'auth/rule/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,102,'normal'),(53,'file',12,'auth/rule/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,101,'normal'),(54,'file',12,'auth/rule/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,100,'normal'),(55,'file',4,'addon/index','View','fa fa-circle-o','','','Addon tips',0,NULL,'','','',1491635035,1491635035,0,'normal'),(56,'file',4,'addon/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(57,'file',4,'addon/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(58,'file',4,'addon/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(59,'file',4,'addon/downloaded','Local addon','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(60,'file',4,'addon/state','Update state','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(63,'file',4,'addon/config','Setting','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(64,'file',4,'addon/refresh','Refresh','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(65,'file',4,'addon/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(66,'file',0,'user','User','fa fa-user-circle','','','',1,NULL,'','hygl','huiyuanguanli',1491635035,1491635035,0,'normal'),(67,'file',66,'user/user','User','fa fa-user','','','',1,NULL,'','hygl','huiyuanguanli',1491635035,1491635035,0,'normal'),(68,'file',67,'user/user/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(69,'file',67,'user/user/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(70,'file',67,'user/user/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(71,'file',67,'user/user/del','Del','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(72,'file',67,'user/user/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(73,'file',66,'user/group','User group','fa fa-users','','','',1,NULL,'','hyfz','huiyuanfenzu',1491635035,1491635035,0,'normal'),(74,'file',73,'user/group/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(75,'file',73,'user/group/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(76,'file',73,'user/group/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(77,'file',73,'user/group/del','Del','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(78,'file',73,'user/group/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(79,'file',66,'user/rule','User rule','fa fa-circle-o','','','',1,NULL,'','hygz','huiyuanguize',1491635035,1491635035,0,'normal'),(80,'file',79,'user/rule/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(81,'file',79,'user/rule/del','Del','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(82,'file',79,'user/rule/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(83,'file',79,'user/rule/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(84,'file',79,'user/rule/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),(161,'file',0,'weixin','公众号管理','fa fa-weixin','','','',1,'addtabs','','gzhgl','gongzhonghaoguanli',1769013664,1769070387,0,'normal'),(162,'file',161,'weixin/config','应用配置','fa fa-angle-double-right','','','填写微信公众号开发配置，请前往微信公众平台申请服务号并完成认证，请使用已认证的公众号服务号，否则可能缺少接口权限。',1,NULL,'padding-left: 15px;','yypz','yingyongpeizhi',1769013664,1769013664,0,'normal'),(163,'file',162,'weixin/config/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1769013664,1769013664,0,'normal'),(164,'file',162,'weixin/config/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1769013664,1769013664,0,'normal'),(165,'file',161,'weixin/menus','菜单管理','fa fa-angle-double-right','','','',1,NULL,'padding-left: 15px;','cdgl','caidanguanli',1769013664,1769013664,0,'normal'),(166,'file',165,'weixin/menus/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1769013664,1769013664,0,'normal'),(167,'file',165,'weixin/menus/save','保存','fa fa-circle-o','','','',0,NULL,'','bc','baocun',1769013664,1769013664,0,'normal'),(168,'file',165,'weixin/menus/sync','保存与同步','fa fa-circle-o','','','',0,NULL,'','bcytb','baocunyutongbu',1769013664,1769013664,0,'normal'),(169,'file',161,'weixin/template','模板消息','fa fa-angle-double-right','','','模板消息仅用于公众号向用户发送重要的服务通知，只能用于符合其要求的服务场景中，如信用卡刷卡通知，商品购买成功通知等。',1,NULL,'padding-left: 15px;','mbxx','mubanxiaoxi',1769013664,1769013664,0,'normal'),(170,'file',169,'weixin/template/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1769013664,1769013664,0,'normal'),(171,'file',169,'weixin/template/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1769013664,1769013664,0,'normal'),(172,'file',169,'weixin/template/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1769013664,1769013664,0,'normal'),(173,'file',169,'weixin/template/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1769013664,1769013664,0,'normal'),(174,'file',169,'weixin/template/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1769013664,1769013664,0,'normal'),(175,'file',161,'weixin/reply','回复管理','fa fa-angle-double-right','','','',1,NULL,'padding-left: 15px;','hfgl','huifuguanli',1769013664,1769013664,0,'normal'),(176,'file',175,'weixin/reply/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1769013664,1769013664,0,'normal'),(177,'file',175,'weixin/reply/add','新增','fa fa-circle-o','','','',0,NULL,'','xz','xinzeng',1769013664,1769013664,0,'normal'),(178,'file',175,'weixin/reply/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1769013664,1769013664,0,'normal'),(179,'file',175,'weixin/reply/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1769013664,1769013664,0,'normal'),(180,'file',175,'weixin/reply/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1769013664,1769013664,0,'normal'),(181,'file',161,'weixin/news','图文消息','fa fa-angle-double-right','','','图文消息可以通过关键词或者主动推送等方式发送到用户端的公众号中显示。',1,NULL,'padding-left: 15px;','twxx','tuwenxiaoxi',1769013664,1769013664,0,'normal'),(182,'file',181,'weixin/news/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1769013664,1769013664,0,'normal'),(183,'file',181,'weixin/news/add','新增','fa fa-circle-o','','','',0,NULL,'','xz','xinzeng',1769013664,1769013664,0,'normal'),(184,'file',181,'weixin/news/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1769013664,1769013664,0,'normal'),(185,'file',181,'weixin/news/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1769013664,1769013664,0,'normal'),(186,'file',181,'weixin/news/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1769013664,1769013664,0,'normal'),(187,'file',161,'weixin/user','微信用户','fa fa-angle-double-right','','','该微信用户数据列表是用户在微信端通过登录接口主动授权登录后获得。',1,NULL,'padding-left: 15px;','wxyh','weixinyonghu',1769013664,1769013664,0,'normal'),(188,'file',187,'weixin/user/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1769013664,1769013664,0,'normal'),(189,'file',187,'weixin/user/sendmsg','推送消息','fa fa-circle-o','','','',0,NULL,'','tsxx','tuisongxiaoxi',1769013664,1769013664,0,'normal'),(190,'file',187,'weixin/user/edit_user_tag','修改用户标签','fa fa-circle-o','','','',0,NULL,'','xgyhbq','xiugaiyonghubiaoqian',1769013664,1769013664,0,'normal'),(191,'file',187,'weixin/user/edit_user_group','修改用户分组','fa fa-circle-o','','','',0,NULL,'','xgyhfz','xiugaiyonghufenzu',1769013664,1769013664,0,'normal'),(192,'file',161,'weixin/user/tag','用户标签','fa fa-angle-double-right','','','维护和管理微信公众号用户标签，可以为公众号用户设置所属的标签组。',1,NULL,'padding-left: 15px;','yhbq','yonghubiaoqian',1769013664,1769013664,0,'normal'),(193,'file',192,'weixin/user/tagadd','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1769013664,1769013664,0,'normal'),(194,'file',192,'weixin/user/tagedit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1769013664,1769013664,0,'normal'),(195,'file',192,'weixin/user/tagdel','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1769013664,1769013664,0,'normal'),(196,'file',161,'weixin/fans/index','粉丝用户','fa fa-angle-double-right','','','粉丝用户是指关注微信公众号的微信用户与授权无关，需要手动同步。因接口限制目前拉去粉丝用户将不再输出头像、昵称等信息。',1,NULL,'padding-left: 15px;','fsyh','fensiyonghu',1769013664,1769013664,0,'normal'),(197,'file',196,'weixin/fans/syncwechatfans','同步粉丝','fa fa-circle-o','','','',0,NULL,'','tbfs','tongbufensi',1769013664,1769013664,0,'normal'),(198,'file',196,'weixin/fans/sendmsg','推送消息','fa fa-circle-o','','','',0,NULL,'','tsxx','tuisongxiaoxi',1769013664,1769013664,0,'normal'),(217,'file',0,'byhs','数据中心','fa fa-dashboard','','','',1,NULL,'','','',NULL,NULL,0,'normal'),(218,'file',217,'byhs/dashboard','数据仪表盘','fa fa-area-chart','','','',1,NULL,'','','',NULL,NULL,0,'normal'),(272,'file',218,'byhs/dashboard/index','查看','','','','',0,NULL,'','','',1769043996,1769043996,0,'normal'),(274,'file',0,'merchant','商户管理','fa fa-building','','','商户入驻与审核管理',1,NULL,'','','',NULL,NULL,100,'normal'),(275,'file',274,'merchant/merchant','商户列表','fa fa-list','','','商户信息与状态管理',1,NULL,'','','',NULL,NULL,10,'normal'),(276,'file',274,'merchant/audit','审核管理','fa fa-check-square','','','商户入驻审核',1,NULL,'','','',NULL,NULL,9,'normal'),(277,'file',0,'task','任务管理','fa fa-tasks','','','互助任务与子任务管理',1,NULL,'','','',NULL,NULL,90,'normal'),(278,'file',277,'task/mutualtask','主任务列表','fa fa-list','','','互助主任务管理',1,NULL,'','','',NULL,NULL,10,'normal'),(279,'file',277,'task/subtask','子任务列表','fa fa-list-alt','','','子任务执行与监控',1,NULL,'','','',NULL,NULL,9,'normal'),(280,'file',0,'wallet','钱包管理','fa fa-money','','','用户资金与流水管理',1,NULL,'','','',NULL,NULL,80,'normal'),(281,'file',280,'wallet/wallet','用户钱包','fa fa-credit-card','','','钱包余额与保证金',1,NULL,'','','',NULL,NULL,10,'normal'),(282,'file',280,'wallet/log','流水查询','fa fa-history','','','资金变动明细',1,NULL,'','','',NULL,NULL,9,'normal'),(283,'file',280,'wallet/withdraw','提现审核','fa fa-sign-out','','','用户提现申请审核',1,NULL,'','','',NULL,NULL,8,'normal'),(284,'file',0,'promo','推广管理','fa fa-users','','','推广分销与收益管理',1,NULL,'','','',NULL,NULL,70,'normal'),(285,'file',284,'promo/level','等级配置','fa fa-star','','','用户等级体系配置',1,NULL,'','','',NULL,NULL,10,'normal'),(286,'file',284,'promo/relation','推广关系','fa fa-sitemap','','','用户推广关系树',1,NULL,'','','',NULL,NULL,9,'normal'),(287,'file',284,'promo/commission','佣金记录','fa fa-dollar','','','佣金发放明细',1,NULL,'','','',NULL,NULL,8,'normal'),(288,'file',284,'promo/bonus','分红管理','fa fa-gift','','','月度分红统计与发放',1,NULL,'','','',NULL,NULL,7,'normal'),(289,'file',0,'config_center','配置中心','fa fa-cogs','','','业务规则与系统配置',1,NULL,'','','',NULL,NULL,60,'normal'),(290,'file',289,'config/reward','奖励规则','fa fa-trophy','','','佣金奖励规则配置',1,NULL,'','','',NULL,NULL,10,'normal'),(291,'file',289,'config/profit','分润规则','fa fa-percent','','','等级差分润配置',1,NULL,'','','',NULL,NULL,9,'normal'),(292,'file',289,'config/bonusconfig','分红配置','fa fa-pie-chart','','','月度分红档位配置',1,NULL,'','','',NULL,NULL,8,'normal'),(294,'file',0,'message','消息管理','fa fa-envelope','','','消息管理',1,NULL,'','','',1770522404,1770522404,85,'normal'),(295,'file',294,'message/index','消息列表','fa fa-list','','','',1,NULL,'','','',1770522404,1770522404,0,'normal'),(296,'file',294,'message/add','发送消息','fa fa-plus','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(297,'file',294,'message/detail','消息详情','fa fa-eye','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(298,'file',294,'message/del','删除消息','fa fa-trash','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(299,'file',294,'message/markread','标记已读','fa fa-check','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(300,'file',280,'wallet/bankcard','银行卡管理','fa fa-credit-card','','','',1,NULL,'','','',1770522404,1770522404,0,'normal'),(301,'file',300,'wallet/bankcard/index','银行卡列表','fa fa-list','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(302,'file',300,'wallet/bankcard/detail','银行卡详情','fa fa-eye','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(303,'file',300,'wallet/bankcard/enable','启用银行卡','fa fa-check','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(304,'file',300,'wallet/bankcard/disable','禁用银行卡','fa fa-ban','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(305,'file',300,'wallet/bankcard/del','删除银行卡','fa fa-trash','','','',0,NULL,'','','',1770522404,1770522404,0,'normal'),(307,'file',289,'config/bank_config','银行配置','fa fa-bank','','','管理系统支持的银行列表',1,'addtabs','','yhpz','yinhangpeizhi',1770532310,1770532440,0,'normal'),(308,'file',307,'config/bank_config/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(309,'file',307,'config/bank_config/add','添加','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(310,'file',307,'config/bank_config/edit','编辑','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(311,'file',307,'config/bank_config/del','删除','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(313,'file',274,'merchant/merchant_category','经营类目','fa fa-list','','','管理商户经营类目',1,NULL,'','','',1770532310,1770532310,0,'normal'),(314,'file',313,'merchant/merchant_category/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(315,'file',313,'merchant/merchant_category/add','添加','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(316,'file',313,'merchant/merchant_category/edit','编辑','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(317,'file',313,'merchant/merchant_category/del','删除','fa fa-circle-o','','','',0,NULL,'','','',1770532310,1770532310,0,'normal'),(318,'menu',274,'merchant/application','进件管理','fa fa-file-text-o','','','商户进件申请管理',1,NULL,'','','',1770536879,1770536879,0,'normal'),(319,'file',318,'merchant/application/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770536879,1770536879,0,'normal'),(320,'file',318,'merchant/application/detail','详情','fa fa-circle-o','','','',0,NULL,'','','',1770536879,1770536879,0,'normal'),(321,'file',318,'merchant/application/approve','审核通过','fa fa-circle-o','','','',0,NULL,'','','',1770536879,1770536879,0,'normal'),(322,'file',318,'merchant/application/reject','审核驳回','fa fa-circle-o','','','',0,NULL,'','','',1770536879,1770536879,0,'normal'),(323,'menu',277,'task/tasktype','任务类型','fa fa-list','task/tasktype','','',1,NULL,'','','',1770542877,1770542877,0,'normal'),(324,'file',323,'task/tasktype/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770542877,1770542877,0,'normal'),(325,'file',323,'task/tasktype/add','添加','fa fa-circle-o','','','',0,NULL,'','','',1770542877,1770542877,0,'normal'),(326,'file',323,'task/tasktype/edit','编辑','fa fa-circle-o','','','',0,NULL,'','','',1770542877,1770542877,0,'normal'),(327,'file',323,'task/tasktype/del','删除','fa fa-circle-o','','','',0,NULL,'','','',1770542877,1770542877,0,'normal'),(328,'file',280,'wallet/recharge','充值管理','fa fa-plus-circle','','','充值订单管理',1,NULL,'','','',1770551806,1770551806,11,'normal'),(329,'file',328,'wallet/recharge/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770551806,1770551806,0,'normal'),(330,'file',328,'wallet/recharge/detail','详情','fa fa-circle-o','','','',0,NULL,'','','',1770551806,1770551806,0,'normal'),(331,'file',328,'wallet/recharge/confirm','确认到账','fa fa-circle-o','','','',0,NULL,'','','',1770551807,1770551807,0,'normal'),(332,'file',328,'wallet/recharge/refund','退款','fa fa-circle-o','','','',0,NULL,'','','',1770551807,1770551807,0,'normal'),(333,'file',328,'wallet/recharge/batchConfirm','批量确认','fa fa-circle-o','','','',0,NULL,'','','',1770551807,1770551807,0,'normal'),(334,'file',66,'user/certification','实名认证','fa fa-id-card','','','实名认证管理',1,NULL,'','smrz','shimingrenzheng',1770598740,1770598740,85,'normal'),(335,'file',334,'user/certification/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(336,'file',334,'user/certification/detail','详情','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(337,'file',334,'user/certification/approve','审核通过','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(338,'file',334,'user/certification/reject','审核拒绝','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(339,'file',66,'user/feedback','工单反馈','fa fa-comments','','','工单反馈管理',1,NULL,'','gdfk','gongdanfankui',1770598740,1770598740,80,'normal'),(340,'file',339,'user/feedback/index','查看','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(341,'file',339,'user/feedback/detail','详情','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(342,'file',339,'user/feedback/reply','回复','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(343,'file',339,'user/feedback/close','关闭','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(344,'file',339,'user/feedback/processing','设为处理中','fa fa-circle-o','','','',0,NULL,'','','',1770598740,1770598740,0,'normal'),(346,'file',0,'third','第三方登录管理','fa fa-users','','','',1,NULL,'','dsfdlgl','disanfangdengluguanli',1770620336,1770620336,0,'normal'),(347,'file',346,'third/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1770620336,1770620336,0,'normal'),(348,'file',346,'third/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1770620336,1770620336,0,'normal');
/*!40000 ALTER TABLE `fa_auth_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_bank_config`
--

DROP TABLE IF EXISTS `fa_bank_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_bank_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(100) NOT NULL COMMENT '银行名称',
  `bank_code` varchar(20) NOT NULL COMMENT '银行代码',
  `bank_logo` varchar(255) DEFAULT '' COMMENT '银行Logo',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','disabled') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bank_code` (`bank_code`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COMMENT='银行配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_bank_config`
--

LOCK TABLES `fa_bank_config` WRITE;
/*!40000 ALTER TABLE `fa_bank_config` DISABLE KEYS */;
INSERT INTO `fa_bank_config` VALUES (1,'中国工商银行','ICBC','',1,'normal',1770530537,1770530537),(2,'中国农业银行','ABC','',2,'normal',1770530537,1770530537),(3,'中国银行','BOC','',3,'normal',1770530537,1770530537),(4,'中国建设银行','CCB','',4,'normal',1770530537,1770530537),(5,'交通银行','COMM','',5,'normal',1770530537,1770530537),(6,'招商银行','CMB','',6,'normal',1770530537,1770530537),(7,'中国邮政储蓄银行','PSBC','',7,'normal',1770530537,1770530537),(8,'中信银行','CITIC','',8,'normal',1770530537,1770530537),(9,'中国光大银行','CEB','',9,'normal',1770530537,1770530537),(10,'华夏银行','HXB','',10,'normal',1770530537,1770530537),(11,'中国民生银行','CMBC','',11,'normal',1770530537,1770530537),(12,'广发银行','GDB','',12,'normal',1770530537,1770530537),(13,'平安银行','PAB','',13,'normal',1770530537,1770530537),(14,'兴业银行','CIB','',14,'normal',1770530537,1770530537),(15,'浦发银行','SPDB','',15,'normal',1770530537,1770530537);
/*!40000 ALTER TABLE `fa_bank_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_category`
--

DROP TABLE IF EXISTS `fa_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父ID',
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
  `status` varchar(30) DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `weigh` (`weigh`,`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_category`
--

LOCK TABLES `fa_category` WRITE;
/*!40000 ALTER TABLE `fa_category` DISABLE KEYS */;
INSERT INTO `fa_category` VALUES (1,0,'page','官方新闻','news','recommend','/assets/img/qrcode.png','','','news',1491635035,1491635035,1,'normal'),(2,0,'page','移动应用','mobileapp','hot','/assets/img/qrcode.png','','','mobileapp',1491635035,1491635035,2,'normal'),(3,2,'page','微信公众号','wechatpublic','index','/assets/img/qrcode.png','','','wechatpublic',1491635035,1491635035,3,'normal'),(4,2,'page','Android开发','android','recommend','/assets/img/qrcode.png','','','android',1491635035,1491635035,4,'normal'),(5,0,'page','软件产品','software','recommend','/assets/img/qrcode.png','','','software',1491635035,1491635035,5,'normal'),(6,5,'page','网站建站','website','recommend','/assets/img/qrcode.png','','','website',1491635035,1491635035,6,'normal'),(7,5,'page','企业管理软件','company','index','/assets/img/qrcode.png','','','company',1491635035,1491635035,7,'normal'),(8,6,'page','PC端','website-pc','recommend','/assets/img/qrcode.png','','','website-pc',1491635035,1491635035,8,'normal'),(9,6,'page','移动端','website-mobile','recommend','/assets/img/qrcode.png','','','website-mobile',1491635035,1491635035,9,'normal'),(10,7,'page','CRM系统 ','company-crm','recommend','/assets/img/qrcode.png','','','company-crm',1491635035,1491635035,10,'normal'),(11,7,'page','SASS平台软件','company-sass','recommend','/assets/img/qrcode.png','','','company-sass',1491635035,1491635035,11,'normal'),(12,0,'test','测试1','test1','recommend','/assets/img/qrcode.png','','','test1',1491635035,1491635035,12,'normal'),(13,0,'test','测试2','test2','recommend','/assets/img/qrcode.png','','','test2',1491635035,1491635035,13,'normal');
/*!40000 ALTER TABLE `fa_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_certification`
--

DROP TABLE IF EXISTS `fa_certification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_certification` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `type` enum('personal','enterprise') NOT NULL DEFAULT 'personal' COMMENT '认证类型:personal=个人认证,enterprise=企业认证',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '真实姓名/法人姓名',
  `id_card` varchar(20) NOT NULL DEFAULT '' COMMENT '身份证号',
  `id_card_front` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `id_card_back` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证反面',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `enterprise_name` varchar(100) NOT NULL DEFAULT '' COMMENT '企业名称',
  `credit_code` varchar(20) NOT NULL DEFAULT '' COMMENT '统一社会信用代码',
  `business_license` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending' COMMENT '状态:pending=待审核,approved=已通过,rejected=已拒绝',
  `reject_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核管理员ID',
  `audit_time` int(10) unsigned DEFAULT NULL COMMENT '审核时间',
  `createtime` int(10) unsigned DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) unsigned DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_createtime` (`createtime`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='实名认证表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_certification`
--

LOCK TABLES `fa_certification` WRITE;
/*!40000 ALTER TABLE `fa_certification` DISABLE KEYS */;
INSERT INTO `fa_certification` VALUES (1,3,'personal','标准','450923198002030533','/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','13888888888','','','','approved',NULL,1,1770619394,1770618910,1770619394),(2,11,'personal','王治乾','522127199212016056','/uploads/20260209/3ff4883ec234501b06261f0844be4688.jpeg','/uploads/20260209/04f6837430d1f6d1d767aadef6228a65.jpeg','13888888888','','','','pending',NULL,0,NULL,1770643871,1770643871);
/*!40000 ALTER TABLE `fa_certification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_config`
--

DROP TABLE IF EXISTS `fa_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `setting` varchar(255) DEFAULT '' COMMENT '配置',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_config`
--

LOCK TABLES `fa_config` WRITE;
/*!40000 ALTER TABLE `fa_config` DISABLE KEYS */;
INSERT INTO `fa_config` VALUES (1,'name','basic','Site name','请填写站点名称','string','','互助平台','','required','',NULL),(2,'beian','basic','Beian','粤ICP备15000000号-1','string','','','','','',NULL),(3,'cdnurl','basic','Cdn url','如果全站静态资源使用第三方云储存请配置该值','string','','','','','',''),(4,'version','basic','Version','如果静态资源有变动请重新配置该值','string','','1.0.4','','required','',NULL),(5,'timezone','basic','Timezone','','string','','Asia/Shanghai','','required','',NULL),(6,'forbiddenip','basic','Forbidden ip','一行一条记录','text','','','','','',NULL),(7,'languages','basic','Languages','','array','','{\"backend\":\"zh-cn\",\"frontend\":\"zh-cn\"}','','required','',NULL),(8,'fixedpage','basic','Fixed page','请输入左侧菜单栏存在的链接','string','','dashboard','','required','',NULL),(9,'categorytype','dictionary','Category type','','array','','{\"default\":\"默认\",\"page\":\"单页\",\"article\":\"文章\",\"test\":\"Test\"}','','','',NULL),(10,'configgroup','dictionary','Config group','','array','','{\"basic\":\"基础配置\",\"email\":\"邮件配置\",\"dictionary\":\"字典配置\",\"user\":\"会员配置\",\"promo\":\"推广配置\"}','','','',NULL),(11,'mail_type','email','Mail type','选择邮件发送方式','select','','1','[\"请选择\",\"SMTP\"]','','',''),(12,'mail_smtp_host','email','Mail smtp host','错误的配置发送邮件会导致服务器超时','string','','smtp.qq.com','','','',''),(13,'mail_smtp_port','email','Mail smtp port','(不加密默认25,SSL默认465,TLS默认587)','string','','465','','','',''),(14,'mail_smtp_user','email','Mail smtp user','（填写完整用户名）','string','','','','','',''),(15,'mail_smtp_pass','email','Mail smtp password','（填写您的密码或授权码）','password','','','','','',''),(16,'mail_verify_type','email','Mail vertify type','（SMTP验证方式[推荐SSL]）','select','','2','[\"无\",\"TLS\",\"SSL\"]','','',''),(17,'mail_from','email','Mail from','','string','','','','','',''),(18,'attachmentcategory','dictionary','Attachment category','','array','','{\"category1\":\"分类一\",\"category2\":\"分类二\",\"custom\":\"自定义\"}','','','',NULL),(19,'logo','basic','LOGO','','image','','','','','','{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}'),(20,'bonus_calculate_day','promo','分红统计日','每月几号统计分红（1-28）','number','','1','','required','',NULL),(21,'bonus_settle_day','promo','分红发放日','每月几号发放分红（1-28）','number','','3','','required','',NULL);
/*!40000 ALTER TABLE `fa_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_ems`
--

DROP TABLE IF EXISTS `fa_ems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_ems` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `event` varchar(30) DEFAULT '' COMMENT '事件',
  `email` varchar(100) DEFAULT '' COMMENT '邮箱',
  `code` varchar(10) DEFAULT '' COMMENT '验证码',
  `times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证次数',
  `ip` varchar(30) DEFAULT '' COMMENT 'IP',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邮箱验证码表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_ems`
--

LOCK TABLES `fa_ems` WRITE;
/*!40000 ALTER TABLE `fa_ems` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_ems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_feedback`
--

DROP TABLE IF EXISTS `fa_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_feedback` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `type` varchar(20) NOT NULL DEFAULT 'other' COMMENT '反馈类型:suggestion=功能建议,bug=系统故障,complaint=投诉举报,question=咨询问题,other=其他',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `content` text NOT NULL COMMENT '反馈内容',
  `images` varchar(1000) NOT NULL DEFAULT '' COMMENT '图片附件(逗号分隔)',
  `contact` varchar(100) NOT NULL DEFAULT '' COMMENT '联系方式',
  `status` enum('pending','processing','replied','closed') NOT NULL DEFAULT 'pending' COMMENT '状态:pending=待处理,processing=处理中,replied=已回复,closed=已关闭',
  `reply` text COMMENT '回复内容',
  `reply_time` int(10) unsigned DEFAULT NULL COMMENT '回复时间',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '处理管理员ID',
  `createtime` int(10) unsigned DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) unsigned DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_type` (`type`),
  KEY `idx_createtime` (`createtime`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='工单反馈表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_feedback`
--

LOCK TABLES `fa_feedback` WRITE;
/*!40000 ALTER TABLE `fa_feedback` DISABLE KEYS */;
INSERT INTO `fa_feedback` VALUES (1,2,'suggestion','','111111111111','','','replied','22222222',1770601101,1,1770601029,1770601101);
/*!40000 ALTER TABLE `fa_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_merchant`
--

DROP TABLE IF EXISTS `fa_merchant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_merchant` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `merchant_no` varchar(32) NOT NULL DEFAULT '' COMMENT '商户编号',
  `type` enum('personal','individual','enterprise') NOT NULL DEFAULT 'personal' COMMENT '商户类型:personal=个人,individual=个体,enterprise=企业',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '商户名称',
  `legal_name` varchar(50) NOT NULL DEFAULT '' COMMENT '法人姓名',
  `id_card` varchar(20) NOT NULL DEFAULT '' COMMENT '身份证号',
  `id_card_front` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `id_card_back` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证反面',
  `business_license` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `shop_front` varchar(255) NOT NULL DEFAULT '' COMMENT '门头照',
  `other_files` varchar(255) NOT NULL DEFAULT '' COMMENT '其他附件',
  `business_license_no` varchar(50) NOT NULL DEFAULT '' COMMENT '统一社会信用代码',
  `bank_name` varchar(100) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_account` varchar(30) NOT NULL DEFAULT '' COMMENT '银行账号',
  `bank_branch` varchar(200) NOT NULL DEFAULT '' COMMENT '开户支行',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `contact_address` varchar(255) NOT NULL DEFAULT '' COMMENT '联系地址',
  `category` varchar(50) NOT NULL DEFAULT '' COMMENT '经营类目',
  `category_code` varchar(50) NOT NULL DEFAULT '' COMMENT '经营类目代码',
  `entry_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '入驻费',
  `entry_fee_paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '入驻费已支付',
  `status` enum('pending','approved','rejected','disabled') NOT NULL DEFAULT 'pending',
  `reject_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `approved_time` int(10) unsigned DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_merchant_no` (`merchant_no`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='商户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_merchant`
--

LOCK TABLES `fa_merchant` WRITE;
/*!40000 ALTER TABLE `fa_merchant` DISABLE KEYS */;
INSERT INTO `fa_merchant` VALUES (1,2,'M202601220739445636','personal','测试商户','测试商户','110101199001011234','','','','','','','中国银行','6217000010001234567','','13800138000','','','',0.00,0,'approved',NULL,NULL,1769038784,1769038784),(2,4,'M202601220810434925','personal','测试商户1','张三','110101199001011234','','','','','','','中国银行','6217000010001234567','','13800138001','','','',0.00,1,'approved',NULL,1769040643,1769040643,1769040643),(3,7,'M202601220815371913','personal','测试商户1','张三','110101199001011234','','','','','','','中国银行','6217000010001234567','','13800138001','','','',0.00,1,'approved',NULL,NULL,1769040937,1769040937),(4,11,'M2026020927038','personal','老王家的店','王治乾','522127199212016056','/uploads/20260209/3ff4883ec234501b06261f0844be4688.jpeg','/uploads/20260209/5419a19daca08d6abcfcb22838db3b1c.jpeg','','','','','中国农业银行','6228481198675032578','','13888888888','','','',0.00,0,'approved',NULL,1770645134,1770644006,1770645134);
/*!40000 ALTER TABLE `fa_merchant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_merchant_application`
--

DROP TABLE IF EXISTS `fa_merchant_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='商户进件申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_merchant_application`
--

LOCK TABLES `fa_merchant_application` WRITE;
/*!40000 ALTER TABLE `fa_merchant_application` DISABLE KEYS */;
INSERT INTO `fa_merchant_application` VALUES (1,1,2,'JJ2026020807052','','individual','吃大亏','459023198002030533','亏大吃','13800000000','服装零售 / 女装','womens_wear','安徽省 安庆市 安徽安庆经济开发区','/uploads/20260208/c27e294a3aedd96d5b864f93dcf780d5.png','','','/uploads/20260208/c27e294a3aedd96d5b864f93dcf780d5.png','','rejected','资料不完整',1770541915,1,1770540356,1770541957),(2,1,2,'JJ2026020841408','','individual','吃大亏','459023198002030533','亏大吃','13800000000','服装零售 / 女装','womens_wear','安徽省 安庆市 安徽安庆经济开发区','/uploads/20260208/c27e294a3aedd96d5b864f93dcf780d5.png','','','/uploads/20260208/c27e294a3aedd96d5b864f93dcf780d5.png','','approved','',1770541735,1,1770540513,1770541735);
/*!40000 ALTER TABLE `fa_merchant_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_merchant_audit`
--

DROP TABLE IF EXISTS `fa_merchant_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_merchant_audit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `merchant_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `operator_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作员ID',
  `operator_name` varchar(50) NOT NULL DEFAULT '' COMMENT '操作员姓名',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核人',
  `action` enum('submit','approve','reject') NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='商户审核记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_merchant_audit`
--

LOCK TABLES `fa_merchant_audit` WRITE;
/*!40000 ALTER TABLE `fa_merchant_audit` DISABLE KEYS */;
INSERT INTO `fa_merchant_audit` VALUES (1,4,0,0,'',1,'approve','审核通过',1770645134,1770645134);
/*!40000 ALTER TABLE `fa_merchant_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_merchant_category`
--

DROP TABLE IF EXISTS `fa_merchant_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_merchant_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '类目名称',
  `code` varchar(50) NOT NULL COMMENT '类目代码',
  `parent_id` int(10) unsigned DEFAULT '0' COMMENT '父级ID',
  `level` tinyint(1) NOT NULL DEFAULT '1' COMMENT '层级',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','disabled') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COMMENT='商户经营类目配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_merchant_category`
--

LOCK TABLES `fa_merchant_category` WRITE;
/*!40000 ALTER TABLE `fa_merchant_category` DISABLE KEYS */;
INSERT INTO `fa_merchant_category` VALUES (1,'餐饮美食','food',0,1,1,'normal',1770531327,1770531327),(2,'中餐','chinese_food',1,2,1,'normal',1770531327,1770531327),(3,'西餐','western_food',1,2,2,'normal',1770531327,1770531327),(4,'快餐','fast_food',1,2,3,'normal',1770531327,1770531327),(5,'饮品店','beverage',1,2,4,'normal',1770531327,1770531327),(6,'服装零售','clothing',0,1,2,'normal',1770531327,1770531327),(7,'男装','mens_wear',6,2,1,'normal',1770531327,1770531327),(8,'女装','womens_wear',6,2,2,'normal',1770531327,1770531327),(9,'童装','kids_wear',6,2,3,'normal',1770531327,1770531327),(10,'鞋包配饰','accessories',6,2,4,'normal',1770531327,1770531327),(11,'生活服务','service',0,1,3,'normal',1770531327,1770531327),(12,'美容美发','beauty',11,2,1,'normal',1770531327,1770531327),(13,'休闲娱乐','entertainment',11,2,2,'normal',1770531327,1770531327),(14,'教育培训','education',11,2,3,'normal',1770531327,1770531327),(15,'家政服务','housekeeping',11,2,4,'normal',1770531327,1770531327),(16,'数码电器','electronics',0,1,4,'normal',1770531327,1770531327),(17,'手机通讯','mobile',16,2,1,'normal',1770531327,1770531327),(18,'电脑办公','computer',16,2,2,'normal',1770531327,1770531327),(19,'家用电器','appliance',16,2,3,'normal',1770531327,1770531327),(20,'其他','other',0,1,99,'normal',1770531327,1770531327);
/*!40000 ALTER TABLE `fa_merchant_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_message`
--

DROP TABLE IF EXISTS `fa_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_message` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `type` varchar(50) NOT NULL COMMENT '消息类型',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读',
  `extra` text COMMENT '扩展数据JSON',
  `createtime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_read` (`is_read`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COMMENT='消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_message`
--

LOCK TABLES `fa_message` WRITE;
/*!40000 ALTER TABLE `fa_message` DISABLE KEYS */;
INSERT INTO `fa_message` VALUES (1,1,'system','系统上线','测试一下',0,NULL,1770523550),(2,2,'system','系统上线','测试一下',1,NULL,1770523550),(3,3,'system','系统上线','测试一下',0,NULL,1770523550),(4,4,'system','系统上线','测试一下',0,NULL,1770523550),(5,5,'system','系统上线','测试一下',0,NULL,1770523550),(6,6,'system','系统上线','测试一下',0,NULL,1770523550),(7,7,'system','系统上线','测试一下',0,NULL,1770523550),(8,8,'system','系统上线','测试一下',0,NULL,1770523550),(9,9,'system','系统上线','测试一下',0,NULL,1770523550),(10,10,'system','系统上线','测试一下',0,NULL,1770523550),(11,1,'system','系统上线','测试一下',0,NULL,1770523560),(12,2,'system','系统上线','测试一下',0,NULL,1770523560),(13,3,'system','系统上线','测试一下',0,NULL,1770523560),(14,4,'system','系统上线','测试一下',0,NULL,1770523560),(15,5,'system','系统上线','测试一下',0,NULL,1770523560),(16,6,'system','系统上线','测试一下',0,NULL,1770523560),(17,7,'system','系统上线','测试一下',0,NULL,1770523560),(18,8,'system','系统上线','测试一下',0,NULL,1770523560),(19,9,'system','系统上线','测试一下',0,NULL,1770523560),(20,10,'system','系统上线','测试一下',0,NULL,1770523560),(21,2,'system','测试一下','测试指定用户发送消息',0,NULL,1770525973),(22,2,'system','测试一下','测试指定用户发送消息',0,NULL,1770525999),(23,2,'system','测试一下','测试指定用户发送消息',0,NULL,1770526084),(24,2,'system','测试一下','测试指定用户发送消息',0,NULL,1770526127),(25,2,'system','测试一下','测试指定用户发送消息',0,NULL,1770526300),(26,2,'system','1','1',0,NULL,1770526806);
/*!40000 ALTER TABLE `fa_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_mutual_task`
--

DROP TABLE IF EXISTS `fa_mutual_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_mutual_task` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '发起用户',
  `task_no` varchar(32) NOT NULL COMMENT '任务编号',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '任务标题',
  `category` varchar(50) NOT NULL DEFAULT '' COMMENT '任务类目',
  `platform` varchar(50) NOT NULL DEFAULT '' COMMENT '平台类型',
  `total_amount` decimal(15,2) NOT NULL COMMENT '目标金额',
  `completed_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '已完成金额',
  `pending_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '待完成金额',
  `deposit_amount` decimal(15,2) NOT NULL COMMENT '保证金',
  `frozen_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '已冻结金额',
  `service_fee_rate` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '服务费率',
  `sub_task_min` decimal(10,2) NOT NULL DEFAULT '2000.00' COMMENT '子任务最小金额',
  `sub_task_max` decimal(10,2) NOT NULL DEFAULT '5000.00' COMMENT '子任务最大金额',
  `channel_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支付通道',
  `start_time` int(10) unsigned DEFAULT NULL,
  `end_time` int(10) unsigned DEFAULT NULL,
  `time_limit` int(10) unsigned NOT NULL DEFAULT '3600' COMMENT '完成时限(秒)',
  `proof_type` varchar(50) NOT NULL DEFAULT 'image' COMMENT '凭证类型',
  `requirements` text COMMENT '任务要求',
  `status` enum('pending','approved','rejected','running','paused','completed','cancelled') NOT NULL DEFAULT 'pending',
  `content` text COMMENT '详细说明',
  `reject_reason` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  `receipt_type` enum('entry','collection') DEFAULT 'entry' COMMENT '收款类型',
  `entry_qrcode` varchar(255) DEFAULT NULL COMMENT '进件二维码',
  `collection_qrcode` varchar(255) DEFAULT NULL COMMENT '收款码',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_no` (`task_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='互助主任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_mutual_task`
--

LOCK TABLES `fa_mutual_task` WRITE;
/*!40000 ALTER TABLE `fa_mutual_task` DISABLE KEYS */;
INSERT INTO `fa_mutual_task` VALUES (3,2,'T202601220741297415','','','',10000.00,0.00,0.00,2000.00,0.00,0.0000,2000.00,5000.00,0,NULL,NULL,3600,'image',NULL,'pending',NULL,NULL,NULL,1769038889,1769038889,'entry',NULL,NULL),(4,4,'T202601220810437282','','','',10000.00,0.00,0.00,2000.00,0.00,0.0000,2000.00,5000.00,0,NULL,NULL,3600,'image',NULL,'approved',NULL,NULL,NULL,1769040643,1769040643,'entry',NULL,NULL),(5,7,'T202601220815372228','','','',10000.00,0.00,0.00,2000.00,0.00,0.0000,2000.00,5000.00,0,NULL,NULL,3600,'image',NULL,'approved',NULL,NULL,NULL,1769040937,1769040937,'entry',NULL,NULL),(6,2,'T202602081807396898','支付宝流水互刷','ecommerce','',600000.00,24604.80,575395.20,44000.00,281.85,0.0100,2000.00,5000.00,2,1770480000,1772899200,3600,'image',NULL,'running',NULL,NULL,'支付宝流水互刷',1770545259,1770622532,'entry',NULL,''),(7,2,'T202602081908523413','微信流水互刷','ecommerce','',100000.00,0.00,0.00,0.00,0.00,0.0100,2000.00,5000.00,2,1770480000,1775577600,3600,'image',NULL,'pending',NULL,NULL,'微信流水互刷',1770548932,1770548932,'entry',NULL,''),(8,11,'T202602092156007074','开卡奖励','other','',10000.00,0.00,0.00,0.00,0.00,0.0100,2000.00,5000.00,0,1770566400,1770739200,3600,'image',NULL,'pending',NULL,NULL,'两路口',1770645360,1770645360,'collection',NULL,'blob:https://byhs.gynhc.com/254de686-a6d8-46f3-9c28-a70d65dd2a2c');
/*!40000 ALTER TABLE `fa_mutual_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_profit_rule`
--

DROP TABLE IF EXISTS `fa_profit_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_profit_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '规则名称',
  `level_diff` int(10) NOT NULL COMMENT '等级差',
  `profit_rate` decimal(5,4) NOT NULL COMMENT '分润比例',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_level_diff` (`level_diff`),
  KEY `level_diff` (`level_diff`),
  KEY `status` (`status`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='分润规则配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_profit_rule`
--

LOCK TABLES `fa_profit_rule` WRITE;
/*!40000 ALTER TABLE `fa_profit_rule` DISABLE KEYS */;
INSERT INTO `fa_profit_rule` VALUES (1,'一级差分润',1,0.0005,0.00,0,'normal',1769014810,NULL),(2,'二级差分润',2,0.0010,0.00,0,'normal',1769014810,NULL),(3,'三级差分润',3,0.0015,0.00,0,'normal',1769014810,NULL),(4,'四级差分润',4,0.0020,0.00,0,'normal',1769014810,NULL);
/*!40000 ALTER TABLE `fa_profit_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_promo_bonus`
--

DROP TABLE IF EXISTS `fa_promo_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_promo_bonus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `config_id` int(10) unsigned NOT NULL COMMENT '配置ID',
  `period` varchar(20) NOT NULL DEFAULT '' COMMENT '期数,如:202501',
  `pool_amount` decimal(15,2) NOT NULL COMMENT '奖池金额',
  `qualified_count` int(10) NOT NULL COMMENT '达标人数',
  `amount` decimal(15,2) NOT NULL COMMENT '分红金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending',
  `settle_time` int(10) unsigned DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_month` (`user_id`,`period`),
  KEY `user_id` (`user_id`),
  KEY `period` (`period`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分红记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_promo_bonus`
--

LOCK TABLES `fa_promo_bonus` WRITE;
/*!40000 ALTER TABLE `fa_promo_bonus` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_promo_bonus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_promo_bonus_config`
--

DROP TABLE IF EXISTS `fa_promo_bonus_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_promo_bonus_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '档位名称',
  `team_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '团队业绩门槛',
  `personal_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '个人业绩门槛',
  `qualified_count_min` int(10) NOT NULL DEFAULT '0' COMMENT '达标人数',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `pool_rate` decimal(5,4) NOT NULL COMMENT '奖池比例',
  `sort` int(10) NOT NULL DEFAULT '0',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='分红配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_promo_bonus_config`
--

LOCK TABLES `fa_promo_bonus_config` WRITE;
/*!40000 ALTER TABLE `fa_promo_bonus_config` DISABLE KEYS */;
INSERT INTO `fa_promo_bonus_config` VALUES (1,'基础分红',100000.00,10000.00,3,0.00,0.0100,1,'normal',1769014810,NULL),(2,'进阶分红',500000.00,50000.00,10,10000.00,0.0150,2,'normal',1769014810,NULL),(3,'高级分红',2000000.00,200000.00,30,50000.00,0.0200,3,'normal',1769014810,NULL);
/*!40000 ALTER TABLE `fa_promo_bonus_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_promo_commission`
--

DROP TABLE IF EXISTS `fa_promo_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_promo_commission` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '获得者',
  `source_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '来源用户',
  `scene` varchar(50) NOT NULL COMMENT '场景',
  `reward_type` varchar(50) NOT NULL COMMENT '奖励类型',
  `rule_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规则ID',
  `base_amount` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '基数',
  `amount` decimal(15,2) NOT NULL COMMENT '金额',
  `status` enum('pending','settled','cancelled') NOT NULL DEFAULT 'pending',
  `settle_time` int(10) unsigned DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_source_user_id` (`source_user_id`),
  KEY `idx_scene` (`scene`),
  KEY `user_id` (`user_id`),
  KEY `source_user_id` (`source_user_id`),
  KEY `scene` (`scene`),
  KEY `status` (`status`),
  KEY `createtime` (`createtime`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='佣金记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_promo_commission`
--

LOCK TABLES `fa_promo_commission` WRITE;
/*!40000 ALTER TABLE `fa_promo_commission` DISABLE KEYS */;
INSERT INTO `fa_promo_commission` VALUES (1,2,3,'order_complete','direct',6,2194.81,21.94,'settled',1770622532,'直推奖励',1770622532);
/*!40000 ALTER TABLE `fa_promo_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_promo_level`
--

DROP TABLE IF EXISTS `fa_promo_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_promo_level` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '等级名称',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `upgrade_type` enum('purchase','performance','both') NOT NULL DEFAULT 'purchase' COMMENT '升级方式',
  `upgrade_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '购买价格',
  `personal_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '个人业绩要求',
  `team_performance_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '团队业绩要求',
  `direct_invite_min` int(10) NOT NULL DEFAULT '0' COMMENT '直推人数要求',
  `commission_rate` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '佣金比例',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='等级配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_promo_level`
--

LOCK TABLES `fa_promo_level` WRITE;
/*!40000 ALTER TABLE `fa_promo_level` DISABLE KEYS */;
INSERT INTO `fa_promo_level` VALUES (1,'普通会员',0,'purchase',0.00,0.00,0.00,0,0.0010,'normal',1769014810,NULL),(2,'银卡会员',1,'both',1000.00,50000.00,100000.00,5,0.0020,'normal',1769014810,NULL),(3,'金卡会员',2,'both',3000.00,150000.00,500000.00,10,0.0030,'normal',1769014810,NULL),(4,'铂金会员',3,'performance',10000.00,500000.00,2000000.00,20,0.0050,'normal',1769014810,NULL),(5,'钻石会员',4,'performance',30000.00,1500000.00,10000000.00,50,0.0080,'normal',1769014810,NULL),(6,'省级代理',0,'purchase',1000000.00,0.00,0.00,0,0.0100,'normal',1770605338,1770605338);
/*!40000 ALTER TABLE `fa_promo_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_promo_performance`
--

DROP TABLE IF EXISTS `fa_promo_performance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_promo_performance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `period` varchar(20) NOT NULL DEFAULT '' COMMENT '期数,如:202501',
  `personal_performance` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '个人业绩',
  `team_performance` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '团队业绩',
  `growth` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '业绩增量',
  `direct_invite_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '直推人数',
  `team_member_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '团队人数',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_month` (`user_id`,`period`),
  UNIQUE KEY `user_period` (`user_id`,`period`),
  KEY `period` (`period`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='业绩统计表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_promo_performance`
--

LOCK TABLES `fa_promo_performance` WRITE;
/*!40000 ALTER TABLE `fa_promo_performance` DISABLE KEYS */;
INSERT INTO `fa_promo_performance` VALUES (2,3,'2026-02',24604.80,0.00,0.00,0,0,1770559828,1770622532),(3,2,'2026-02',0.00,20068.28,0.00,0,0,1770606612,1770622532);
/*!40000 ALTER TABLE `fa_promo_performance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_promo_relation`
--

DROP TABLE IF EXISTS `fa_promo_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_promo_relation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `level_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '等级ID',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级ID',
  `path` varchar(1000) NOT NULL DEFAULT '' COMMENT '路径',
  `depth` int(10) NOT NULL DEFAULT '0' COMMENT '深度',
  `invite_code` varchar(20) NOT NULL DEFAULT '' COMMENT '邀请码',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_invite_code` (`invite_code`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='推广关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_promo_relation`
--

LOCK TABLES `fa_promo_relation` WRITE;
/*!40000 ALTER TABLE `fa_promo_relation` DISABLE KEYS */;
INSERT INTO `fa_promo_relation` VALUES (1,2,1,0,'',0,'92D87F8A',1769038749,1769038749),(2,3,0,2,'2',1,'4713EEEC',1769038837,1770602605),(3,4,1,0,'',0,'4AF9D45C',1769040643,1769040643),(4,5,0,0,'',0,'4D7B47DD',1769040643,1769040643),(5,6,0,4,'0,4',1,'B813C8B4',1769040643,1769040643),(6,7,1,0,'',0,'05A53611',1769040937,1769040937),(7,8,0,0,'',0,'3ECD700C',1769040937,1769040937),(8,9,0,7,'',1,'123C3FCA',1769040937,1769040937),(9,11,0,0,'',0,'37546F42',1770638695,1770638695);
/*!40000 ALTER TABLE `fa_promo_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_recharge`
--

DROP TABLE IF EXISTS `fa_recharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_recharge` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `order_no` varchar(32) NOT NULL COMMENT '订单号',
  `amount` decimal(15,2) NOT NULL COMMENT '充值金额',
  `target` enum('balance','deposit') NOT NULL DEFAULT 'balance' COMMENT '充值目标',
  `pay_method` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式',
  `third_order_no` varchar(64) DEFAULT NULL COMMENT '第三方订单号',
  `status` enum('pending','paid','failed') NOT NULL DEFAULT 'pending',
  `paid_time` int(10) unsigned DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COMMENT='充值记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_recharge`
--

LOCK TABLES `fa_recharge` WRITE;
/*!40000 ALTER TABLE `fa_recharge` DISABLE KEYS */;
INSERT INTO `fa_recharge` VALUES (1,2,'R202601220742233443',1000.00,'balance','',NULL,'paid',1769038943,1769038943,1769038943),(2,4,'R202601220810437926',1000.00,'balance','',NULL,'paid',1769040643,1769040643,1769040643),(3,7,'R202601220815371920',1000.00,'balance','',NULL,'paid',NULL,1769040937,1769040937),(4,2,'R202602081921049519',10000.00,'balance','',NULL,'pending',NULL,1770549664,1770549664),(5,2,'R202602081921516850',10000.00,'balance','',NULL,'pending',NULL,1770549711,1770549711),(6,2,'R202602081928492451',10000.00,'balance','',NULL,'pending',NULL,1770550129,1770550129),(7,2,'R202602081929091668',10000.00,'balance','',NULL,'pending',NULL,1770550149,1770550149),(8,2,'R202602081929173164',10000.00,'balance','',NULL,'pending',NULL,1770550157,1770550157),(9,2,'R202602081945425131',10000.00,'balance','',NULL,'pending',NULL,1770551142,1770551142),(10,2,'R202602081946111900',10000.00,'balance','',NULL,'pending',NULL,1770551171,1770551171),(11,2,'R202602081950140248',10000.00,'balance','',NULL,'pending',NULL,1770551414,1770551414),(12,2,'R202602082013067277',100000.00,'balance','',NULL,'paid',1770552794,1770552786,1770552794),(13,2,'R202602082013334764',10000.00,'balance','',NULL,'paid',1770552817,1770552813,1770552817),(14,2,'R202602082020094362',1000.00,'balance','',NULL,'paid',1770553221,1770553209,1770553221),(15,11,'R202602092007215231',1000.00,'balance','',NULL,'pending',NULL,1770638841,1770638841),(16,11,'R202602101046595949',100.00,'balance','',NULL,'pending',NULL,1770691619,1770691619);
/*!40000 ALTER TABLE `fa_recharge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_reward_rule`
--

DROP TABLE IF EXISTS `fa_reward_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_reward_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '规则名称',
  `scene` enum('merchant_entry','order_complete','level_upgrade') NOT NULL COMMENT '触发场景',
  `reward_type` enum('direct','indirect','level_diff','peer','team') NOT NULL COMMENT '奖励类型',
  `target_depth` int(10) NOT NULL DEFAULT '1' COMMENT '目标层级',
  `level_require` varchar(255) DEFAULT NULL COMMENT '等级要求JSON',
  `amount_type` enum('fixed','percent') NOT NULL COMMENT '金额类型',
  `amount_value` decimal(10,4) NOT NULL COMMENT '金额值',
  `growth_min` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '增量门槛',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_scene` (`scene`),
  KEY `idx_reward_type` (`reward_type`),
  KEY `scene` (`scene`),
  KEY `reward_type` (`reward_type`),
  KEY `status` (`status`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='奖励规则配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_reward_rule`
--

LOCK TABLES `fa_reward_rule` WRITE;
/*!40000 ALTER TABLE `fa_reward_rule` DISABLE KEYS */;
INSERT INTO `fa_reward_rule` VALUES (1,'商户入驻直推奖','merchant_entry','direct',1,NULL,'percent',0.1000,0.00,0,'normal',1769014810,NULL),(2,'商户入驻间推奖','merchant_entry','indirect',2,NULL,'percent',0.0500,0.00,0,'normal',1769014810,NULL),(3,'等级升级直推奖','level_upgrade','direct',1,NULL,'percent',0.1000,0.00,0,'normal',1769014810,NULL),(4,'等级升级间推奖','level_upgrade','indirect',2,NULL,'percent',0.0500,0.00,0,'normal',1769014810,NULL),(5,'省级奖励','merchant_entry','peer',1,'6','fixed',0.0000,0.00,0,'normal',1770605447,1770605447),(6,'刷单完成直推奖（测试用）','order_complete','direct',1,NULL,'percent',0.0100,0.00,0,'normal',1770606896,NULL);
/*!40000 ALTER TABLE `fa_reward_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_sms`
--

DROP TABLE IF EXISTS `fa_sms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `event` varchar(30) DEFAULT '' COMMENT '事件',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号',
  `code` varchar(10) DEFAULT '' COMMENT '验证码',
  `times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证次数',
  `ip` varchar(30) DEFAULT '' COMMENT 'IP',
  `createtime` bigint(16) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='短信验证码表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_sms`
--

LOCK TABLES `fa_sms` WRITE;
/*!40000 ALTER TABLE `fa_sms` DISABLE KEYS */;
INSERT INTO `fa_sms` VALUES (3,'register','13888888888','1920',0,'182.88.27.180',1770620230);
/*!40000 ALTER TABLE `fa_sms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_sub_task`
--

DROP TABLE IF EXISTS `fa_sub_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_sub_task` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(10) unsigned NOT NULL COMMENT '主任务ID',
  `task_no` varchar(32) NOT NULL COMMENT '子任务编号',
  `from_user_id` int(10) unsigned NOT NULL COMMENT '发起方',
  `to_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行方',
  `amount` decimal(10,2) NOT NULL COMMENT '刷单金额',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '佣金',
  `service_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '服务费',
  `proof_image` varchar(500) DEFAULT NULL COMMENT '支付凭证',
  `proof_desc` varchar(500) NOT NULL DEFAULT '' COMMENT '凭证说明',
  `third_order_no` varchar(64) DEFAULT NULL COMMENT '第三方订单号',
  `status` enum('pending','assigned','accepted','paid','verified','completed','failed','cancelled') NOT NULL DEFAULT 'pending',
  `assigned_time` int(10) unsigned DEFAULT NULL,
  `accepted_time` int(10) unsigned DEFAULT NULL,
  `paid_time` int(10) unsigned DEFAULT NULL,
  `completed_time` int(10) unsigned DEFAULT NULL,
  `fail_reason` varchar(255) DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_no` (`task_no`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_from_user_id` (`from_user_id`),
  KEY `idx_to_user_id` (`to_user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8mb4 COMMENT='子任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_sub_task`
--

LOCK TABLES `fa_sub_task` WRITE;
/*!40000 ALTER TABLE `fa_sub_task` DISABLE KEYS */;
INSERT INTO `fa_sub_task` VALUES (1,3,'ST2026012207412989640',2,0,5000.00,0.00,0.00,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1769038889,1769038889),(2,3,'ST2026012207412998171',2,0,5000.00,0.00,0.00,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1769038889,1769038889),(3,4,'ST2026012208104320170',4,5,5000.00,0.00,0.00,'/uploads/proof_1769040643.jpg','','ORD17690406439184','verified',1769040643,1769040643,1769040643,NULL,NULL,1769040643,1769040643),(4,4,'ST2026012208104345041',4,0,5000.00,0.00,0.00,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1769040643,1769040643),(5,5,'ST2026012208153738910',7,8,5000.00,0.00,0.00,'/uploads/proof_1769040937.jpg','','ORD17690409376387','paid',NULL,1769040937,1769040937,NULL,NULL,1769040937,1769040937),(6,5,'ST2026012208153739701',7,0,5000.00,0.00,0.00,NULL,'',NULL,'assigned',NULL,NULL,NULL,NULL,NULL,1769040937,1769040937),(154,6,'ST2026020818400606082430',2,3,2384.52,4.76,23.84,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770553522,1770555768,1770622206,1770622216,NULL,1770547206,1770622216),(155,6,'ST2026020818400606090849',2,3,4536.52,9.07,45.36,'/uploads/20260208/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770553649,1770556189,1770556531,1770559828,NULL,1770547206,1770559828),(156,6,'ST2026020818400606091195',2,3,3822.35,7.64,38.22,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770553669,1770605518,1770605741,1770606612,NULL,1770547206,1770606612),(157,6,'ST2026020818400606091538',2,3,4023.72,8.04,40.23,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770553709,1770611555,1770611562,1770612219,NULL,1770547206,1770612219),(158,6,'ST2026020818400606091840',2,3,3324.43,6.64,33.24,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770612269,1770612460,1770612809,1770612991,NULL,1770547206,1770612991),(159,6,'ST2026020818400606092296',2,3,4318.45,8.63,43.18,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770612269,1770613013,1770622378,1770622387,NULL,1770547206,1770622387),(160,6,'ST2026020818400606092536',2,3,2194.81,4.38,21.94,'/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png','','','completed',1770612269,1770622483,1770622489,1770622532,NULL,1770547206,1770622532),(161,6,'ST2026020818400606092822',2,0,4861.18,9.72,48.61,NULL,'',NULL,'assigned',1770613036,NULL,NULL,NULL,NULL,1770547206,1770613036),(162,6,'ST2026020818400606093210',2,0,4821.40,9.64,48.21,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(163,6,'ST2026020818400606093559',2,0,2732.25,5.46,27.32,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(164,6,'ST2026020818400606093822',2,0,4031.13,8.06,40.31,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(165,6,'ST2026020818400606094201',2,0,4144.07,8.28,41.44,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(166,6,'ST2026020818400606094533',2,0,2621.91,5.24,26.21,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(167,6,'ST2026020818400606094858',2,0,2046.02,4.09,20.46,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(168,6,'ST2026020818400606095148',2,0,3517.18,7.03,35.17,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(169,6,'ST2026020818400606095436',2,0,4708.05,9.41,47.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(170,6,'ST2026020818400606095756',2,0,2586.47,5.17,25.86,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(171,6,'ST2026020818400620609617',2,0,4928.36,9.85,49.28,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(172,6,'ST2026020818400606096391',2,0,4087.07,8.17,40.87,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(173,6,'ST2026020818400606096716',2,0,3699.20,7.39,36.99,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(174,6,'ST2026020818400620609799',2,0,3267.11,6.53,32.67,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(175,6,'ST2026020818400606097314',2,0,4053.85,8.10,40.53,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(176,6,'ST2026020818400606097637',2,0,3774.95,7.54,37.74,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(177,6,'ST2026020818400606097992',2,0,3507.52,7.01,35.07,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(178,6,'ST2026020818400606098236',2,0,3480.66,6.96,34.80,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(179,6,'ST2026020818400606098662',2,0,4069.21,8.13,40.69,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(180,6,'ST2026020818400606098986',2,0,3639.06,7.27,36.39,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(181,6,'ST2026020818400606099232',2,0,4262.84,8.52,42.62,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(182,6,'ST2026020818400606099533',2,0,4426.21,8.85,44.26,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(183,6,'ST2026020818400606099839',2,0,3693.28,7.38,36.93,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(184,6,'ST2026020818400606100213',2,0,3871.51,7.74,38.71,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(185,6,'ST2026020818400606100541',2,0,2715.77,5.43,27.15,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(186,6,'ST2026020818400606100937',2,0,2738.47,5.47,27.38,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(187,6,'ST2026020818400606101278',2,0,2761.21,5.52,27.61,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(188,6,'ST2026020818400606101508',2,0,4156.06,8.31,41.56,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(189,6,'ST2026020818400606101842',2,0,2291.63,4.58,22.91,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(190,6,'ST2026020818400606102139',2,0,2296.73,4.59,22.96,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(191,6,'ST2026020818400606102425',2,0,3390.15,6.78,33.90,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(192,6,'ST2026020818400606102710',2,0,4759.57,9.51,47.59,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(193,6,'ST2026020818400620610371',2,0,2468.50,4.93,24.68,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(194,6,'ST2026020818400606103364',2,0,4243.00,8.48,42.43,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(195,6,'ST2026020818400606103687',2,0,4277.09,8.55,42.77,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(196,6,'ST2026020818400606103907',2,0,3821.89,7.64,38.21,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(197,6,'ST2026020818400606104279',2,0,3165.75,6.33,31.65,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(198,6,'ST2026020818400606104554',2,0,4614.33,9.22,46.14,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(199,6,'ST2026020818400606104834',2,0,3494.93,6.98,34.94,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(200,6,'ST2026020818400606105173',2,0,2169.57,4.33,21.69,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(201,6,'ST2026020818400606105496',2,0,4760.35,9.52,47.60,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(202,6,'ST2026020818400606105790',2,0,2326.21,4.65,23.26,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(203,6,'ST2026020818400620610698',2,0,3825.90,7.65,38.25,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(204,6,'ST2026020818400606106324',2,0,3531.75,7.06,35.31,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(205,6,'ST2026020818400606106651',2,0,3070.63,6.14,30.70,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(206,6,'ST2026020818400606106969',2,0,3902.47,7.80,39.02,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(207,6,'ST2026020818400606107296',2,0,4139.29,8.27,41.39,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(208,6,'ST2026020818400606107517',2,0,3873.47,7.74,38.73,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(209,6,'ST2026020818400606107888',2,0,3408.07,6.81,34.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(210,6,'ST2026020818400606108109',2,0,4965.20,9.93,49.65,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(211,6,'ST2026020818400606108464',2,0,2771.65,5.54,27.71,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(212,6,'ST2026020818400606108777',2,0,3461.85,6.92,34.61,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(213,6,'ST2026020818400606109149',2,0,2945.58,5.89,29.45,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(214,6,'ST2026020818400606109436',2,0,4683.25,9.36,46.83,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(215,6,'ST2026020818400606109710',2,0,2072.16,4.14,20.72,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(216,6,'ST2026020818400672061179',2,0,3430.05,6.86,34.30,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(217,6,'ST2026020818400606110387',2,0,4876.32,9.75,48.76,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(218,6,'ST2026020818400606110646',2,0,2174.02,4.34,21.74,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(219,6,'ST2026020818400606110981',2,0,2406.82,4.81,24.06,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(220,6,'ST2026020818400606111247',2,0,4722.90,9.44,47.22,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(221,6,'ST2026020818400606111553',2,0,3431.73,6.86,34.31,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(222,6,'ST2026020818400606111870',2,0,4167.58,8.33,41.67,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(223,6,'ST2026020818400606112172',2,0,2894.15,5.78,28.94,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(224,6,'ST2026020818400606112495',2,0,3864.83,7.72,38.64,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(225,6,'ST2026020818400606112799',2,0,2586.74,5.17,25.86,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(226,6,'ST2026020818400620611343',2,0,4460.42,8.92,44.60,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(227,6,'ST2026020818400606113363',2,0,3277.91,6.55,32.77,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(228,6,'ST2026020818400606113610',2,0,4234.29,8.46,42.34,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(229,6,'ST2026020818400606113976',2,0,3450.21,6.90,34.50,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(230,6,'ST2026020818400606114211',2,0,3508.57,7.01,35.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(231,6,'ST2026020818400606114534',2,0,4349.02,8.69,43.49,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(232,6,'ST2026020818400606114803',2,0,4941.66,9.88,49.41,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(233,6,'ST2026020818400606115172',2,0,4521.39,9.04,45.21,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(234,6,'ST2026020818400606115418',2,0,4258.69,8.51,42.58,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(235,6,'ST2026020818400606115788',2,0,4253.85,8.50,42.53,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(236,6,'ST2026020818400606116113',2,0,2108.84,4.21,21.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(237,6,'ST2026020818400606116418',2,0,3026.05,6.05,30.26,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(238,6,'ST2026020818400606116754',2,0,4306.05,8.61,43.06,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(239,6,'ST2026020818400620611715',2,0,3759.12,7.51,37.59,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(240,6,'ST2026020818400606117395',2,0,2809.28,5.61,28.09,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(241,6,'ST2026020818400606117623',2,0,3368.12,6.73,33.68,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(242,6,'ST2026020818400606117936',2,0,4383.73,8.76,43.83,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(243,6,'ST2026020818400606118263',2,0,3320.86,6.64,33.20,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(244,6,'ST2026020818400606118541',2,0,2753.90,5.50,27.53,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(245,6,'ST2026020818400606118839',2,0,2581.46,5.16,25.81,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(246,6,'ST2026020818400606119107',2,0,3946.48,7.89,39.46,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(247,6,'ST2026020818400606119488',2,0,2343.50,4.68,23.43,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(248,6,'ST2026020818400606119766',2,0,2701.70,5.40,27.01,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(249,6,'ST2026020818400672061260',2,0,3230.62,6.46,32.30,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(250,6,'ST2026020818400606120374',2,0,2308.01,4.61,23.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(251,6,'ST2026020818400606120611',2,0,4378.69,8.75,43.78,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(252,6,'ST2026020818400606120978',2,0,4853.50,9.70,48.53,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(253,6,'ST2026020818400606121265',2,0,3021.34,6.04,30.21,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(254,6,'ST2026020818400606121540',2,0,4518.35,9.03,45.18,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(255,6,'ST2026020818400606121893',2,0,2448.83,4.89,24.48,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(256,6,'ST2026020818400606122119',2,0,2398.22,4.79,23.98,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(257,6,'ST2026020818400606122490',2,0,3429.92,6.85,34.29,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(258,6,'ST2026020818400606122769',2,0,4551.18,9.10,45.51,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(259,6,'ST2026020818400620612323',2,0,2510.93,5.02,25.10,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(260,6,'ST2026020818400606123337',2,0,3356.12,6.71,33.56,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(261,6,'ST2026020818400606123663',2,0,4860.21,9.72,48.60,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(262,6,'ST2026020818400606123917',2,0,4214.29,8.42,42.14,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(263,6,'ST2026020818400606124205',2,0,2649.53,5.29,26.49,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(264,6,'ST2026020818400606124643',2,0,4366.23,8.73,43.66,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(265,6,'ST2026020818400606124964',2,0,3908.22,7.81,39.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(266,6,'ST2026020818400606125274',2,0,2479.30,4.95,24.79,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(267,6,'ST2026020818400606125560',2,0,4391.09,8.78,43.91,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(268,6,'ST2026020818400606125890',2,0,2891.27,5.78,28.91,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(269,6,'ST2026020818400606126173',2,0,3627.80,7.25,36.27,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(270,6,'ST2026020818400606126484',2,0,3279.68,6.55,32.79,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(271,6,'ST2026020818400606126769',2,0,2106.84,4.21,21.06,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(272,6,'ST2026020818400620612761',2,0,4294.77,8.58,42.94,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(273,6,'ST2026020818400606127381',2,0,3410.53,6.82,34.10,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(274,6,'ST2026020818400606127636',2,0,3825.75,7.65,38.25,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(275,6,'ST2026020818400606127911',2,0,4166.60,8.33,41.66,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(276,6,'ST2026020818400606128264',2,0,4561.61,9.12,45.61,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(277,6,'ST2026020818400606128586',2,0,3254.89,6.50,32.54,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(278,6,'ST2026020818400606128888',2,0,3554.38,7.10,35.54,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(279,6,'ST2026020818400606129119',2,0,3708.85,7.41,37.08,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(280,6,'ST2026020818400606129423',2,0,3182.43,6.36,31.82,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(281,6,'ST2026020818400606129765',2,0,4736.23,9.47,47.36,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(282,6,'ST2026020818400672061374',2,0,3139.42,6.27,31.39,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(283,6,'ST2026020818400606130351',2,0,2745.67,5.49,27.45,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(284,6,'ST2026020818400606130604',2,0,3296.95,6.59,32.96,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(285,6,'ST2026020818400606130937',2,0,3580.07,7.16,35.80,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(286,6,'ST2026020818400606131284',2,0,2536.94,5.07,25.36,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(287,6,'ST2026020818400606131523',2,0,2415.99,4.83,24.15,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(288,6,'ST2026020818400606131840',2,0,3056.03,6.11,30.56,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(289,6,'ST2026020818400606132101',2,0,3300.10,6.60,33.00,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(290,6,'ST2026020818400606132495',2,0,3277.92,6.55,32.77,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(291,6,'ST2026020818400606132784',2,0,4005.92,8.01,40.05,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(292,6,'ST2026020818400606133179',2,0,4644.43,9.28,46.44,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(293,6,'ST2026020818400606133433',2,0,3791.08,7.58,37.91,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(294,6,'ST2026020818400606133729',2,0,3214.40,6.42,32.14,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(295,6,'ST2026020818400620613415',2,0,2211.08,4.42,22.11,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(296,6,'ST2026020818400606134310',2,0,3070.15,6.14,30.70,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(297,6,'ST2026020818400606134615',2,0,4409.02,8.81,44.09,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(298,6,'ST2026020818400606134947',2,0,4595.36,9.19,45.95,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(299,6,'ST2026020818400606135273',2,0,2956.45,5.91,29.56,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(300,6,'ST2026020818400606135551',2,0,2577.93,5.15,25.77,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(301,6,'ST2026020818400606135873',2,0,3909.87,7.81,39.09,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(302,6,'ST2026020818400606136186',2,0,4628.43,9.25,46.28,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(303,6,'ST2026020818400606136541',2,0,4714.34,9.42,47.14,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(304,6,'ST2026020818400606136870',2,0,3282.43,6.56,32.82,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(305,6,'ST2026020818400606137238',2,0,4003.50,8.00,40.03,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(306,6,'ST2026020818400606137555',2,0,2950.39,5.90,29.50,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(307,6,'ST2026020818400606137822',2,0,3980.44,7.96,39.80,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(308,6,'ST2026020818400606138188',2,0,3733.63,7.46,37.33,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(309,6,'ST2026020818400606138461',2,0,2257.31,4.51,22.57,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(310,6,'ST2026020818400606138744',2,0,3587.61,7.17,35.87,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(311,6,'ST2026020818400620613977',2,0,2048.86,4.09,20.48,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(312,6,'ST2026020818400606139314',2,0,2210.23,4.42,22.10,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(313,6,'ST2026020818400606139608',2,0,2721.45,5.44,27.21,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(314,6,'ST2026020818400606139929',2,0,3677.42,7.35,36.77,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(315,6,'ST2026020818400606140259',2,0,4913.80,9.82,49.13,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(316,6,'ST2026020818400606140670',2,0,2488.59,4.97,24.88,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(317,6,'ST2026020818400606140984',2,0,4151.33,8.30,41.51,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(318,6,'ST2026020818400606141277',2,0,2724.14,5.44,27.24,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(319,6,'ST2026020818400606141609',2,0,2791.33,5.58,27.91,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(320,6,'ST2026020818400606141910',2,0,3070.96,6.14,30.70,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(321,6,'ST2026020818400606142238',2,0,2592.64,5.18,25.92,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(322,6,'ST2026020818400606142552',2,0,3136.39,6.27,31.36,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(323,6,'ST2026020818400606142891',2,0,3577.05,7.15,35.77,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206),(324,6,'ST2026020818400606143113',2,0,1788.73,3.57,17.88,NULL,'',NULL,'pending',NULL,NULL,NULL,NULL,NULL,1770547206,1770547206);
/*!40000 ALTER TABLE `fa_sub_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_system_config_ext`
--

DROP TABLE IF EXISTS `fa_system_config_ext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_system_config_ext` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group` varchar(50) NOT NULL DEFAULT '' COMMENT '配置分组',
  `key` varchar(50) NOT NULL DEFAULT '' COMMENT '配置键',
  `value` text COMMENT '配置值',
  `type` varchar(20) NOT NULL DEFAULT 'string' COMMENT '类型:string,number,boolean,json',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '配置标题',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_key` (`group`,`key`),
  KEY `group` (`group`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置扩展表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_system_config_ext`
--

LOCK TABLES `fa_system_config_ext` WRITE;
/*!40000 ALTER TABLE `fa_system_config_ext` DISABLE KEYS */;
INSERT INTO `fa_system_config_ext` VALUES (1,'task','sub_task_min_amount','2000','number','子任务最小金额','单位：元',1,1770087650,1770087650),(2,'task','sub_task_max_amount','5000','number','子任务最大金额','单位：元',2,1770087650,1770087650),(3,'task','service_fee_rate','0.05','number','服务费率','默认5%',3,1770087650,1770087650),(4,'task','mutual_balance_min','-50000','number','互助余额最小值','低于此值暂停派发',4,1770087650,1770087650),(5,'task','mutual_balance_resume','-20000','number','互助余额恢复值','高于此值恢复派发',5,1770087650,1770087650),(6,'wallet','withdraw_fee_rate','0.006','number','提现手续费率','默认0.6%',6,1770087650,1770087650),(7,'wallet','withdraw_fee_min','2','number','提现最低手续费','单位：元',7,1770087650,1770087650),(8,'wallet','withdraw_min_amount','100','number','最低提现金额','单位：元',8,1770087650,1770087650),(9,'wallet','withdraw_max_amount','50000','number','单次最高提现金额','单位：元',9,1770087650,1770087650),(10,'bonus','calculate_day','1','number','分红计算日','每月几号计算',10,1770087650,1770087650),(11,'bonus','settle_day','3','number','分红发放日','每月几号发放',11,1770087650,1770087650);
/*!40000 ALTER TABLE `fa_system_config_ext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_task_deposit_log`
--

DROP TABLE IF EXISTS `fa_task_deposit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_task_deposit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL COMMENT '任务ID',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `amount` decimal(15,2) NOT NULL COMMENT '金额',
  `type` enum('pay','topup','refund') NOT NULL COMMENT '类型:首次缴纳/补缴/退还',
  `before_deposit` decimal(15,2) NOT NULL COMMENT '变动前保证金',
  `after_deposit` decimal(15,2) NOT NULL COMMENT '变动后保证金',
  `remark` varchar(255) DEFAULT '' COMMENT '备注',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='任务保证金缴纳日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_task_deposit_log`
--

LOCK TABLES `fa_task_deposit_log` WRITE;
/*!40000 ALTER TABLE `fa_task_deposit_log` DISABLE KEYS */;
INSERT INTO `fa_task_deposit_log` VALUES (4,6,2,5000.00,'pay',0.00,5000.00,'任务保证金',1770553522),(5,6,2,5000.00,'topup',5000.00,10000.00,'任务保证金补缴',1770553649),(6,6,2,5000.00,'topup',10000.00,15000.00,'任务保证金补缴',1770553669),(7,6,2,3000.00,'topup',15000.00,18000.00,'任务保证金补缴',1770553678),(8,6,2,3000.00,'topup',18000.00,21000.00,'任务保证金补缴',1770553686),(9,6,2,3000.00,'topup',21000.00,24000.00,'任务保证金补缴',1770553695),(10,6,2,5000.00,'topup',24000.00,29000.00,'任务保证金补缴',1770553709),(11,6,2,10000.00,'topup',29000.00,39000.00,'任务保证金补缴',1770612269),(12,6,2,5000.00,'topup',39000.00,44000.00,'任务保证金补缴',1770613036);
/*!40000 ALTER TABLE `fa_task_deposit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_task_type`
--

DROP TABLE IF EXISTS `fa_task_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_task_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '类型名称',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '类型编码',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '描述',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='任务类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_task_type`
--

LOCK TABLES `fa_task_type` WRITE;
/*!40000 ALTER TABLE `fa_task_type` DISABLE KEYS */;
INSERT INTO `fa_task_type` VALUES (1,'电商推广','ecommerce','','电商平台推广任务',1,'normal',1770542694,1770542694),(2,'应用下载','app_download','','应用下载安装任务',2,'normal',1770542694,1770542694),(3,'实名认证','real_name','','实名认证任务',3,'normal',1770542694,1770542694),(4,'问卷调查','survey','','问卷调查任务',4,'normal',1770542694,1770542694),(5,'其他','other','','其他类型任务',99,'normal',1770542694,1770542694);
/*!40000 ALTER TABLE `fa_task_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_test`
--

DROP TABLE IF EXISTS `fa_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_test` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) DEFAULT '0' COMMENT '会员ID',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员ID',
  `category_id` int(10) unsigned DEFAULT '0' COMMENT '分类ID(单选)',
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
  `price` decimal(10,2) unsigned DEFAULT '0.00' COMMENT '价格',
  `views` int(10) unsigned DEFAULT '0' COMMENT '点击',
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
  `state` enum('0','1','2') DEFAULT '1' COMMENT '状态值:0=禁用,1=正常,2=推荐',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='测试表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_test`
--

LOCK TABLES `fa_test` WRITE;
/*!40000 ALTER TABLE `fa_test` DISABLE KEYS */;
INSERT INTO `fa_test` VALUES (1,1,1,12,'12,13','互联网,计算机','monday','hot,index','male','music,reading','我是一篇测试文章','<p>我是测试内容</p>','/assets/img/avatar.png','/assets/img/avatar.png,/assets/img/qrcode.png','/assets/img/avatar.png','关键字','我是一篇测试文章描述，内容过多时将自动隐藏','广西壮族自治区/百色市/平果县','[\"a\",\"b\"]','{\"a\":\"1\",\"b\":\"2\"}','[{\"title\":\"标题一\",\"intro\":\"介绍一\",\"author\":\"小明\",\"age\":\"21\"}]',0.00,0,'2020-10-01 00:00:00 - 2021-10-31 23:59:59','2017-07-10','2017-07-10 18:24:45',2017,'18:24:45',1491635035,1491635035,1491635035,NULL,0,1,'normal','1');
/*!40000 ALTER TABLE `fa_test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_third`
--

DROP TABLE IF EXISTS `fa_third`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_third` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '会员ID',
  `platform` varchar(30) DEFAULT '' COMMENT '第三方应用',
  `apptype` varchar(50) DEFAULT '' COMMENT '应用类型',
  `unionid` varchar(100) DEFAULT '' COMMENT '第三方UNIONID',
  `openname` varchar(100) NOT NULL DEFAULT '' COMMENT '第三方会员昵称',
  `openid` varchar(100) DEFAULT '' COMMENT '第三方OPENID',
  `access_token` varchar(255) DEFAULT '' COMMENT 'AccessToken',
  `refresh_token` varchar(255) DEFAULT 'RefreshToken',
  `expires_in` int(10) unsigned DEFAULT '0' COMMENT '有效期',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `expiretime` bigint(16) DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `platform` (`platform`,`openid`),
  KEY `user_id` (`user_id`,`platform`),
  KEY `unionid` (`platform`,`unionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方登录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_third`
--

LOCK TABLES `fa_third` WRITE;
/*!40000 ALTER TABLE `fa_third` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_third` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user`
--

DROP TABLE IF EXISTS `fa_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '组别ID',
  `username` varchar(32) DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) DEFAULT '' COMMENT '昵称',
  `password` varchar(32) DEFAULT '' COMMENT '密码',
  `salt` varchar(30) DEFAULT '' COMMENT '密码盐',
  `email` varchar(100) DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `level` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `bio` varchar(100) DEFAULT '' COMMENT '格言',
  `province` varchar(50) DEFAULT '' COMMENT '省份',
  `city` varchar(50) DEFAULT '' COMMENT '城市',
  `district` varchar(50) DEFAULT '' COMMENT '区县',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
  `successions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `maxsuccessions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '最大连续登录天数',
  `prevtime` bigint(16) DEFAULT NULL COMMENT '上次登录时间',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) DEFAULT '' COMMENT '登录IP',
  `loginfailure` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `loginfailuretime` bigint(16) DEFAULT NULL COMMENT '最后登录失败时间',
  `joinip` varchar(50) DEFAULT '' COMMENT '加入IP',
  `jointime` bigint(16) DEFAULT NULL COMMENT '加入时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(50) DEFAULT '' COMMENT 'Token',
  `status` varchar(30) DEFAULT '' COMMENT '状态',
  `verification` varchar(255) DEFAULT '' COMMENT '验证',
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `email` (`email`),
  KEY `mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='会员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user`
--

LOCK TABLES `fa_user` WRITE;
/*!40000 ALTER TABLE `fa_user` DISABLE KEYS */;
INSERT INTO `fa_user` VALUES (1,1,'admin','admin','f131bd083a78d4f9a7c626284a3fc493','62feb3','admin@163.com','13000000000','/assets/img/avatar.png',0,0,'2017-04-08','','','','',0.00,0,1,1,1491635035,1491635035,'127.0.0.1',0,1491635035,'127.0.0.1',1491635035,0,1491635035,'','normal',''),(2,1,'testuser','张三','f76dfde9d12564f7dfc896872b5b6862','ub6Yw1','','13800138000','https://byhs.gynhc.com/uploads/20260209/c27e294a3aedd96d5b864f93dcf780d5.png',0,1,'2026-02-09','11111','安徽省','安庆市','安徽安庆经济开发区',0.00,0,4,4,1770630820,1770638658,'223.160.192.40',0,1770631128,'0',0,1769038670,1770638658,'','normal',''),(3,1,'acceptuser','测试2','945adda4766b6e8330f1216057b42494','1YNBjP','','13900139000','',0,0,NULL,'','','','',0.00,0,2,2,1770552029,1770622189,'182.88.27.180',0,1770552022,'0',0,1769038837,1770622189,'','normal','{\"email\":0,\"mobile\":0,\"realname\":1}'),(4,0,'testuser1','测试昵称1','6f3b8ded65bd7a4db11625ac84e579bb','abcdef','','13800138001','',0,0,NULL,'','','','',0.00,0,1,1,NULL,NULL,'',0,NULL,'',NULL,1769040643,1769040643,'','normal',''),(5,1,'testuser2','测试用户2','7cd4cdfc096d80d24886c03f314a2d57','E8ATgo','','13800138002','',0,0,NULL,'','','','',0.00,0,1,1,0,1770719451,'182.88.27.180',0,NULL,'0',0,1769040643,1770719451,'','normal',''),(6,0,'testuser3','','6f3b8ded65bd7a4db11625ac84e579bb','abcdef','','13800138003','',0,0,NULL,'','','','',0.00,0,1,1,NULL,NULL,'',0,NULL,'',NULL,1769040643,1769040643,'','normal',''),(7,0,'testuser1','测试昵称1','6f3b8ded65bd7a4db11625ac84e579bb','abcdef','','13800138001','',0,0,NULL,'','','','',0.00,0,1,1,NULL,NULL,'',0,NULL,'',NULL,1769040937,1769040937,'','normal',''),(8,0,'testuser2','','6f3b8ded65bd7a4db11625ac84e579bb','abcdef','','13800138002','',0,0,NULL,'','','','',0.00,0,1,1,NULL,NULL,'',0,NULL,'',NULL,1769040937,1769040937,'','normal',''),(9,0,'testuser3','','6f3b8ded65bd7a4db11625ac84e579bb','abcdef','','13800138003','',0,0,NULL,'','','','',0.00,0,1,1,NULL,NULL,'',0,NULL,'',NULL,1769040937,1769040937,'','normal',''),(10,0,'18000000000','180****0000','e6f46f0f7f376380ee24a6d909bbe6fc','9Y7UsF','','18000000000','',1,0,NULL,'','','','',0.00,0,2,2,1770309243,1770309523,'171.36.79.31',2,1770365076,'171.36.79.31',1770279661,1770279661,1770365076,'','normal',''),(11,0,'李四','李四','b5a28fad7b20f5dbbc47ce85f8d868c5','HzM48y',NULL,'13888888888','',1,0,NULL,'','安徽省','亳州市','谯城区',0.00,0,2,2,1770691556,1770702468,'1.49.149.218',0,1770702463,'182.88.27.180',1770620244,1770620244,1770702468,'','normal','');
/*!40000 ALTER TABLE `fa_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user_bankcard`
--

DROP TABLE IF EXISTS `fa_user_bankcard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user_bankcard` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `bank_name` varchar(100) NOT NULL COMMENT '银行名称',
  `bank_code` varchar(20) NOT NULL DEFAULT '' COMMENT '银行代码',
  `card_no` varchar(30) NOT NULL COMMENT '卡号',
  `card_holder` varchar(50) NOT NULL COMMENT '持卡人',
  `bank_branch` varchar(200) DEFAULT '' COMMENT '开户支行',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认',
  `status` enum('normal','disabled') NOT NULL DEFAULT 'normal',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='用户银行卡表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user_bankcard`
--

LOCK TABLES `fa_user_bankcard` WRITE;
/*!40000 ALTER TABLE `fa_user_bankcard` DISABLE KEYS */;
INSERT INTO `fa_user_bankcard` VALUES (1,2,'中国工商银行','','1111111111111111','1','',1,'normal',1770528351,1770528351),(2,2,'中国工商银行','','2222222222222222','222','',0,'normal',1770530377,1770530377);
/*!40000 ALTER TABLE `fa_user_bankcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user_group`
--

DROP TABLE IF EXISTS `fa_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '组名',
  `rules` text COMMENT '权限节点',
  `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `status` enum('normal','hidden') DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='会员组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user_group`
--

LOCK TABLES `fa_user_group` WRITE;
/*!40000 ALTER TABLE `fa_user_group` DISABLE KEYS */;
INSERT INTO `fa_user_group` VALUES (1,'默认组','1,2,3,4,5,6,7,8,9,10,11,12',1491635035,1491635035,'normal');
/*!40000 ALTER TABLE `fa_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user_money_log`
--

DROP TABLE IF EXISTS `fa_user_money_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user_money_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更余额',
  `before` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更前余额',
  `after` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更后余额',
  `memo` varchar(255) DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员余额变动表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user_money_log`
--

LOCK TABLES `fa_user_money_log` WRITE;
/*!40000 ALTER TABLE `fa_user_money_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_user_money_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user_rule`
--

DROP TABLE IF EXISTS `fa_user_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) DEFAULT NULL COMMENT '父ID',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `title` varchar(50) DEFAULT '' COMMENT '标题',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `ismenu` tinyint(1) DEFAULT NULL COMMENT '是否菜单',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) DEFAULT '0' COMMENT '权重',
  `status` enum('normal','hidden') DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='会员规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user_rule`
--

LOCK TABLES `fa_user_rule` WRITE;
/*!40000 ALTER TABLE `fa_user_rule` DISABLE KEYS */;
INSERT INTO `fa_user_rule` VALUES (1,0,'index','Frontend','',1,1491635035,1491635035,1,'normal'),(2,0,'api','API Interface','',1,1491635035,1491635035,2,'normal'),(3,1,'user','User Module','',1,1491635035,1491635035,12,'normal'),(4,2,'user','User Module','',1,1491635035,1491635035,11,'normal'),(5,3,'index/user/login','Login','',0,1491635035,1491635035,5,'normal'),(6,3,'index/user/register','Register','',0,1491635035,1491635035,7,'normal'),(7,3,'index/user/index','User Center','',0,1491635035,1491635035,9,'normal'),(8,3,'index/user/profile','Profile','',0,1491635035,1491635035,4,'normal'),(9,4,'api/user/login','Login','',0,1491635035,1491635035,6,'normal'),(10,4,'api/user/register','Register','',0,1491635035,1491635035,8,'normal'),(11,4,'api/user/index','User Center','',0,1491635035,1491635035,10,'normal'),(12,4,'api/user/profile','Profile','',0,1491635035,1491635035,3,'normal');
/*!40000 ALTER TABLE `fa_user_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user_score_log`
--

DROP TABLE IF EXISTS `fa_user_score_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user_score_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '变更积分',
  `before` int(10) NOT NULL DEFAULT '0' COMMENT '变更前积分',
  `after` int(10) NOT NULL DEFAULT '0' COMMENT '变更后积分',
  `memo` varchar(255) DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员积分变动表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user_score_log`
--

LOCK TABLES `fa_user_score_log` WRITE;
/*!40000 ALTER TABLE `fa_user_score_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_user_score_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_user_token`
--

DROP TABLE IF EXISTS `fa_user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_user_token` (
  `token` varchar(50) NOT NULL COMMENT 'Token',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `expiretime` bigint(16) DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员Token表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_user_token`
--

LOCK TABLES `fa_user_token` WRITE;
/*!40000 ALTER TABLE `fa_user_token` DISABLE KEYS */;
INSERT INTO `fa_user_token` VALUES ('00e00eec4fa5e4f18909edcda04c5dc567bfadf2',11,1770630627,1773222627),('0975a676e3602e5bccb25946e3a50aa58fff6cdc',11,1770702468,1773294468),('11d6c6287be47628d778374b284577182ed303a2',3,1770622189,1773214189),('15c19d2d492bec29eb34e9f8039522180e200712',11,1770641031,1773233031),('17980c54b9b7ee2221ffd5bf41825cfdb97fe92a',10,1770289618,1772881618),('18aae23e294b792da8263ab8e6065833',9,1769040937,1771632937),('258d7172680270938f70c5d80a365b9effa634a9',10,1770309523,1772901523),('4242c32536f929d3c348871ccd679d3f5d46cfcb',11,1770620787,1773212787),('4374f86e48372790a94d699fed7dcd3e90b3bf57',10,1770279661,1772871661),('44d0ae409de9365f0cc32a6ab732f37fe92e7960',10,1770309243,1772901243),('52547f5c5b18eb19db72fa79072788fbfd62ba38',2,1770622168,1773214168),('56802e062f8c7efa8cd5aeefa3b250ec20965a23',2,1770638658,1773230658),('5c53c0345a8f799626b018a591b6ca60cdfad81c',5,1770719451,1773311451),('5cae9a77c66352c49eaaf7e271d51654a9b081bc',2,1770539744,1773131744),('6398b6a445ea5ada1ec87d820bee34c15a1a93ce',2,1770630820,1773222820),('68259796d603315e033dacb2fc3945f293ffc4cf',2,1770365555,1772957555),('6d6c1391224e5e6cc05bfe43811a7d0f6a415d3a',2,1770453290,1773045290),('9a2022ca85df2a49f4fb06a0953df217',4,1769040643,1771632643),('9ede162280543e140e4ab1e8d4203629b1794980',11,1770642135,1773234135),('a15d1c10c4bdafb329acf78e9f3922ffac0c4070',11,1770621534,1773213534),('a397871d7e377124b48ea09cc21dba7f',7,1769040937,1771632937),('b2d89b1c5dfa87d927665e3b5172e4b5',2,1769038711,1771630711),('bc33ce14fe4c68a2467291492299cfaf6f1a21bb',11,1770691556,1773283556),('c74250e8d9dbbe01b08371c3aefced39',6,1769040643,1771632643),('cfc4a6ee74e881ecda4b2723a657149e',8,1769040937,1771632937),('d49bce58fe33e65aa132409e955d10537a6f8c1f',10,1770281436,1772873436),('d60b4cc5f7149f7a7885f5499605e0218e50ff9c',3,1770552029,1773144029),('d79c944cefdde7f3bd69fe2c44c54f0cd6185caa',11,1770677248,1773269248),('dbb25c7c62083d7c93dbd0e7f56627652e3e56c7',2,1770601900,1773193900),('dd345e46cbaba1fdd607366c7bffaac24057a179',11,1770620257,1773212257),('ee3e43e99754d9bd3747fa07587a906eae8052b4',11,1770620244,1773212244),('ee5a96f6b1e42b9a5700bf782523ccbf',5,1769040643,1771632643),('fdd7ae834b26fdafcb5142ef41eecc1453b06aeb',10,1770308254,1772900254),('fddb55a1063662843242449c9cd0b4a21d6b009c',11,1770638607,1773230607),('fe55b1fc1f10bd38244d3c3c391e76855784b10f',2,1770630783,1773222783);
/*!40000 ALTER TABLE `fa_user_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_version`
--

DROP TABLE IF EXISTS `fa_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `oldversion` varchar(30) DEFAULT '' COMMENT '旧版本号',
  `newversion` varchar(30) DEFAULT '' COMMENT '新版本号',
  `packagesize` varchar(30) DEFAULT '' COMMENT '包大小',
  `content` varchar(500) DEFAULT '' COMMENT '升级内容',
  `downloadurl` varchar(255) DEFAULT '' COMMENT '下载地址',
  `enforce` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '强制更新',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='版本表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_version`
--

LOCK TABLES `fa_version` WRITE;
/*!40000 ALTER TABLE `fa_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_wallet`
--

DROP TABLE IF EXISTS `fa_wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_wallet` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额',
  `deposit` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '保证金',
  `frozen` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '冻结金额',
  `mutual_balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '互助余额',
  `total_income` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '累计收入',
  `total_withdraw` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '累计提现',
  `total_recharge` decimal(15,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计充值',
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COMMENT='钱包表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_wallet`
--

LOCK TABLES `fa_wallet` WRITE;
/*!40000 ALTER TABLE `fa_wallet` DISABLE KEYS */;
INSERT INTO `fa_wallet` VALUES (1,2,77440.06,2750.40,2733.78,-24604.80,152440.06,0.00,0.00,1770622532),(2,3,24653.96,0.00,0.00,24604.80,24653.96,0.00,0.00,1770622532),(3,4,1300.00,5200.00,5000.00,0.00,1000.00,0.00,0.00,1769040643),(4,5,1000.00,5000.00,0.00,0.00,0.00,0.00,0.00,1769040643),(5,6,1000.00,5000.00,0.00,0.00,0.00,0.00,0.00,1769040643),(6,7,2300.00,10200.00,0.00,0.00,0.00,0.00,0.00,1769040937),(7,8,2000.00,10000.00,0.00,0.00,0.00,0.00,0.00,1769040937),(8,9,2000.00,10000.00,0.00,0.00,0.00,0.00,0.00,1769040937),(9,10,0.00,0.00,0.00,0.00,0.00,0.00,0.00,1770309560),(10,11,0.00,0.00,0.00,0.00,0.00,0.00,0.00,1770620257);
/*!40000 ALTER TABLE `fa_wallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_wallet_log`
--

DROP TABLE IF EXISTS `fa_wallet_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_wallet_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `wallet_type` enum('balance','deposit','frozen','mutual') NOT NULL COMMENT '钱包类型',
  `change_type` enum('income','expense','freeze','unfreeze') NOT NULL COMMENT '变动类型',
  `amount` decimal(15,2) NOT NULL COMMENT '变动金额',
  `before_amount` decimal(15,2) NOT NULL COMMENT '变动前',
  `after_amount` decimal(15,2) NOT NULL COMMENT '变动后',
  `biz_type` varchar(50) NOT NULL COMMENT '业务类型',
  `biz_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '业务ID',
  `remark` varchar(255) DEFAULT NULL,
  `createtime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_biz` (`biz_type`,`biz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COMMENT='钱包流水表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_wallet_log`
--

LOCK TABLES `fa_wallet_log` WRITE;
/*!40000 ALTER TABLE `fa_wallet_log` DISABLE KEYS */;
INSERT INTO `fa_wallet_log` VALUES (1,2,'balance','income',100000.00,1000.00,101000.00,'recharge',12,'充值到账(补单)',1770552794),(2,2,'balance','income',10000.00,101000.00,111000.00,'recharge',13,'充值到账(补单)',1770552817),(7,2,'balance','income',1000.00,111000.00,112000.00,'recharge',14,'充值到账(补单)',1770553221),(10,2,'balance','expense',5000.00,112000.00,107000.00,'task_deposit',6,'任务保证金',1770553522),(11,2,'deposit','income',5000.00,5000.00,10000.00,'task_deposit',6,'任务保证金',1770553522),(12,2,'balance','expense',5000.00,107000.00,102000.00,'task_deposit_topup',6,'任务保证金补缴',1770553649),(13,2,'deposit','income',5000.00,10000.00,15000.00,'task_deposit_topup',6,'任务保证金补缴',1770553649),(14,2,'balance','expense',5000.00,102000.00,97000.00,'task_deposit_topup',6,'任务保证金补缴',1770553669),(15,2,'deposit','income',5000.00,15000.00,20000.00,'task_deposit_topup',6,'任务保证金补缴',1770553669),(16,2,'balance','expense',3000.00,97000.00,94000.00,'task_deposit_topup',6,'任务保证金补缴',1770553678),(17,2,'deposit','income',3000.00,20000.00,23000.00,'task_deposit_topup',6,'任务保证金补缴',1770553678),(18,2,'balance','expense',3000.00,94000.00,91000.00,'task_deposit_topup',6,'任务保证金补缴',1770553686),(19,2,'deposit','income',3000.00,23000.00,26000.00,'task_deposit_topup',6,'任务保证金补缴',1770553686),(20,2,'balance','expense',3000.00,91000.00,88000.00,'task_deposit_topup',6,'任务保证金补缴',1770553695),(21,2,'deposit','income',3000.00,26000.00,29000.00,'task_deposit_topup',6,'任务保证金补缴',1770553695),(22,2,'balance','expense',5000.00,88000.00,83000.00,'task_deposit_topup',6,'任务保证金补缴',1770553709),(23,2,'deposit','income',5000.00,29000.00,34000.00,'task_deposit_topup',6,'任务保证金补缴',1770553709),(41,3,'balance','income',4545.59,0.00,4545.59,'subtask_complete',155,'刷单收入+佣金',1770559828),(42,3,'mutual','income',4536.52,0.00,4536.52,'subtask_complete',155,'帮刷增加互助余额',1770559828),(43,2,'deposit','expense',4536.52,34000.00,29463.48,'subtask_complete',155,'子任务完成扣除',1770559828),(44,2,'deposit','expense',45.36,29463.48,29418.12,'service_fee',155,'服务费',1770559828),(45,2,'mutual','expense',4536.52,0.00,-4536.52,'subtask_complete',155,'被刷减少互助余额',1770559828),(46,2,'balance','expense',10000.00,83000.00,73000.00,'deposit_pay',0,'充值保证金',1770570968),(47,2,'deposit','income',10000.00,29418.12,39418.12,'deposit_pay',0,'充值保证金',1770570968),(48,2,'balance','expense',1000.00,73000.00,72000.00,'deposit_pay',0,'充值保证金',1770571319),(49,2,'deposit','income',1000.00,39418.12,40418.12,'deposit_pay',0,'充值保证金',1770571319),(50,2,'deposit','expense',40418.12,40418.12,0.00,'deposit_withdraw',0,'提取保证金',1770571722),(51,2,'balance','income',40418.12,72000.00,112418.12,'deposit_withdraw',0,'提取保证金',1770571722),(52,2,'balance','expense',10000.00,112418.12,102418.12,'withdraw_freeze',0,'提现冻结',1770599770),(53,2,'balance','expense',10000.00,102418.12,92418.12,'withdraw_freeze',0,'提现冻结',1770600375),(68,3,'balance','income',3822.35,4545.59,8367.94,'subtask_amount',156,'刷单收入（本次刷单¥3822.35，佣金¥7.64）',1770606612),(69,3,'balance','income',7.64,8367.94,8375.58,'subtask_commission',156,'佣金收入（本次刷单¥3822.35，佣金¥7.64）',1770606612),(70,3,'mutual','income',3822.35,4536.52,8358.87,'subtask_complete',156,'帮刷增加互助余额',1770606612),(71,2,'frozen','unfreeze',3822.35,3822.35,0.00,'subtask_complete',156,'子任务完成结算(解冻)',1770606612),(72,2,'deposit','expense',3822.35,3860.57,38.22,'subtask_complete',156,'子任务完成结算(扣除)',1770606612),(73,2,'deposit','expense',38.22,38.22,0.00,'service_fee',156,'服务费',1770606612),(74,2,'mutual','expense',3822.35,-4536.52,-8358.87,'subtask_complete',156,'被刷减少互助余额',1770606612),(110,3,'balance','income',4023.72,8375.58,12399.30,'subtask_amount',157,'刷单收入（本次刷单¥4023.72，佣金¥8.04）',1770612219),(111,3,'balance','income',8.04,12399.30,12407.34,'subtask_commission',157,'佣金收入（本次刷单¥4023.72，佣金¥8.04）',1770612219),(112,3,'mutual','income',4023.72,8358.87,12382.59,'subtask_complete',157,'帮刷增加互助余额',1770612219),(113,2,'frozen','unfreeze',4023.72,4023.72,0.00,'subtask_complete',157,'子任务完成结算(解冻)',1770612219),(114,2,'deposit','expense',4023.72,4158.76,135.04,'subtask_complete',157,'子任务完成结算(扣除)',1770612219),(115,2,'deposit','expense',40.23,135.04,94.81,'service_fee',157,'服务费',1770612219),(116,2,'mutual','expense',4023.72,-8358.87,-12382.59,'subtask_complete',157,'被刷减少互助余额',1770612219),(117,2,'balance','expense',10000.00,92418.12,82418.12,'task_deposit_topup',6,'任务保证金补缴',1770612269),(118,2,'deposit','income',10000.00,94.81,10094.81,'task_deposit_topup',6,'任务保证金补缴',1770612269),(122,3,'balance','income',3324.43,12407.34,15731.77,'subtask_amount',158,'刷单收入（本次刷单¥3324.43，佣金¥6.64）',1770612991),(123,3,'balance','income',6.64,15731.77,15738.41,'subtask_commission',158,'佣金收入（本次刷单¥3324.43，佣金¥6.64）',1770612991),(124,3,'mutual','income',3324.43,12382.59,15707.02,'subtask_complete',158,'帮刷增加互助余额',1770612991),(125,2,'frozen','unfreeze',3324.43,10094.81,6770.38,'subtask_complete',158,'子任务完成结算(解冻)',1770612991),(126,2,'deposit','expense',3324.43,10094.81,6770.38,'subtask_complete',158,'子任务完成结算(扣除)',1770612991),(127,2,'deposit','expense',33.24,6770.38,6737.14,'service_fee',158,'服务费',1770612991),(128,2,'mutual','expense',3324.43,-12382.59,-15707.02,'subtask_complete',158,'被刷减少互助余额',1770612991),(129,2,'balance','expense',5000.00,82418.12,77418.12,'task_deposit_topup',6,'任务保证金补缴',1770613036),(130,2,'deposit','income',5000.00,6737.14,11737.14,'task_deposit_topup',6,'任务保证金补缴',1770613036),(131,2,'frozen','freeze',4861.18,6770.38,11631.56,'subtask_assign',161,'子任务分配冻结保证金',1770613036),(132,3,'balance','income',2384.52,15738.41,18122.93,'subtask_amount',154,'刷单收入（本次刷单¥2384.52，佣金¥4.76）',1770622216),(133,3,'balance','income',4.76,18122.93,18127.69,'subtask_commission',154,'佣金收入（本次刷单¥2384.52，佣金¥4.76）',1770622216),(134,3,'mutual','income',2384.52,15707.02,18091.54,'subtask_complete',154,'帮刷增加互助余额',1770622216),(135,2,'frozen','unfreeze',2384.52,11631.56,9247.04,'subtask_complete',154,'子任务完成结算(解冻)',1770622216),(136,2,'deposit','expense',2384.52,11737.14,9352.62,'subtask_complete',154,'子任务完成结算(扣除)',1770622216),(137,2,'deposit','expense',23.84,9352.62,9328.78,'service_fee',154,'服务费',1770622216),(138,2,'mutual','expense',2384.52,-15707.02,-18091.54,'subtask_complete',154,'被刷减少互助余额',1770622216),(139,3,'balance','income',4318.45,18127.69,22446.14,'subtask_amount',159,'刷单收入（本次刷单¥4318.45，佣金¥8.63）',1770622387),(140,3,'balance','income',8.63,22446.14,22454.77,'subtask_commission',159,'佣金收入（本次刷单¥4318.45，佣金¥8.63）',1770622387),(141,3,'mutual','income',4318.45,18091.54,22409.99,'subtask_complete',159,'帮刷增加互助余额',1770622387),(142,2,'frozen','unfreeze',4318.45,9247.04,4928.59,'subtask_complete',159,'子任务完成结算(解冻)',1770622387),(143,2,'deposit','expense',4318.45,9328.78,5010.33,'subtask_complete',159,'子任务完成结算(扣除)',1770622387),(144,2,'deposit','expense',43.18,5010.33,4967.15,'service_fee',159,'服务费',1770622387),(145,2,'mutual','expense',4318.45,-18091.54,-22409.99,'subtask_complete',159,'被刷减少互助余额',1770622387),(146,3,'balance','income',2194.81,22454.77,24649.58,'subtask_amount',160,'刷单收入（本次刷单¥2194.81，佣金¥4.38）',1770622532),(147,3,'balance','income',4.38,24649.58,24653.96,'subtask_commission',160,'佣金收入（本次刷单¥2194.81，佣金¥4.38）',1770622532),(148,3,'mutual','income',2194.81,22409.99,24604.80,'subtask_complete',160,'帮刷增加互助余额',1770622532),(149,2,'frozen','unfreeze',2194.81,4928.59,2733.78,'subtask_complete',160,'子任务完成结算(解冻)',1770622532),(150,2,'deposit','expense',2194.81,4967.15,2772.34,'subtask_complete',160,'子任务完成结算(扣除)',1770622532),(151,2,'deposit','expense',21.94,2772.34,2750.40,'service_fee',160,'服务费',1770622532),(152,2,'mutual','expense',2194.81,-22409.99,-24604.80,'subtask_complete',160,'被刷减少互助余额',1770622532),(153,2,'balance','income',21.94,77418.12,77440.06,'commission',1,'直推奖励',1770622532);
/*!40000 ALTER TABLE `fa_wallet_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_weixin_config`
--

DROP TABLE IF EXISTS `fa_weixin_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_weixin_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '变量名',
  `group` varchar(30) NOT NULL DEFAULT '' COMMENT '分组',
  `value` text COMMENT '变量值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_weixin_config`
--

LOCK TABLES `fa_weixin_config` WRITE;
/*!40000 ALTER TABLE `fa_weixin_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_weixin_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_weixin_fans`
--

DROP TABLE IF EXISTS `fa_weixin_fans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_weixin_fans` (
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
  `subscribe_time` bigint(16) DEFAULT NULL COMMENT '关注时间',
  `subscribe_scene` varchar(100) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源',
  `unsubscribe_time` bigint(16) DEFAULT NULL COMMENT '取消关注时间',
  `update_date` bigint(16) DEFAULT NULL COMMENT '粉丝信息最后更新时间',
  `tagid_list` varchar(255) NOT NULL DEFAULT '' COMMENT '用户被打上的标签ID列表',
  `subscribe_scene_name` varchar(50) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源名称',
  `qr_scene` varchar(255) NOT NULL DEFAULT '' COMMENT 'qr_scene',
  `qr_scene_str` varchar(255) NOT NULL DEFAULT '' COMMENT 'qr_scene_str',
  PRIMARY KEY (`fans_id`) USING BTREE,
  KEY `idx_wxfans` (`unionid`,`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信粉丝列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_weixin_fans`
--

LOCK TABLES `fa_weixin_fans` WRITE;
/*!40000 ALTER TABLE `fa_weixin_fans` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_weixin_fans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_weixin_news`
--

DROP TABLE IF EXISTS `fa_weixin_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_weixin_news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '图文消息表',
  `title` varchar(255) NOT NULL COMMENT '图文标题',
  `description` varchar(255) NOT NULL COMMENT '图文简介',
  `pic` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'URL',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图文消息管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_weixin_news`
--

LOCK TABLES `fa_weixin_news` WRITE;
/*!40000 ALTER TABLE `fa_weixin_news` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_weixin_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_weixin_reply`
--

DROP TABLE IF EXISTS `fa_weixin_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_weixin_reply` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '微信关键字回复id',
  `keyword` varchar(1000) NOT NULL DEFAULT '' COMMENT '关键字',
  `reply_type` enum('text','image','news','voice','video') NOT NULL DEFAULT 'text' COMMENT '回复类型:text=文本消息,image=图片消息,news=图文消息,voice=音频消息,video=视频消息',
  `matching_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '匹配方式：1-全匹配；2-模糊匹配',
  `content` text COMMENT '回复数据',
  `status` enum('normal','hidden') NOT NULL DEFAULT 'normal' COMMENT '状态',
  `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `reply_type` (`reply_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信回复表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_weixin_reply`
--

LOCK TABLES `fa_weixin_reply` WRITE;
/*!40000 ALTER TABLE `fa_weixin_reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_weixin_reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_weixin_template`
--

DROP TABLE IF EXISTS `fa_weixin_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_weixin_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '模板id',
  `tempkey` char(50) NOT NULL DEFAULT '' COMMENT '模板编号',
  `name` char(100) NOT NULL DEFAULT '' COMMENT '模板名',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '回复内容',
  `tempid` char(100) DEFAULT NULL COMMENT '模板ID',
  `open_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '跳转类型：0网址1小程序',
  `open_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转网址',
  `appid` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序appid',
  `pagepath` varchar(100) NOT NULL DEFAULT '' COMMENT '小程序页面path',
  `add_time` bigint(16) DEFAULT NULL COMMENT '添加时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tempkey` (`tempkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='微信模板';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_weixin_template`
--

LOCK TABLES `fa_weixin_template` WRITE;
/*!40000 ALTER TABLE `fa_weixin_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_weixin_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_weixin_user`
--

DROP TABLE IF EXISTS `fa_weixin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_weixin_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `openid` varchar(128) NOT NULL COMMENT '微信openid',
  `unionid` varchar(128) DEFAULT '' COMMENT '微信unionid',
  `tagid_list` varchar(256) DEFAULT NULL COMMENT '用户被打上的标签ID列表',
  `user_type` varchar(32) DEFAULT 'wechat' COMMENT '用户类型',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `openid` (`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户授权表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_weixin_user`
--

LOCK TABLES `fa_weixin_user` WRITE;
/*!40000 ALTER TABLE `fa_weixin_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_weixin_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_withdraw`
--

DROP TABLE IF EXISTS `fa_withdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fa_withdraw` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
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
  `admin_id` int(10) unsigned DEFAULT NULL,
  `audit_time` int(10) unsigned DEFAULT NULL,
  `paid_time` int(10) unsigned DEFAULT NULL,
  `paid_remark` varchar(255) DEFAULT '' COMMENT '打款备注',
  `createtime` int(10) unsigned DEFAULT NULL,
  `updatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_withdraw_no` (`withdraw_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='提现申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_withdraw`
--

LOCK TABLES `fa_withdraw` WRITE;
/*!40000 ALTER TABLE `fa_withdraw` DISABLE KEYS */;
INSERT INTO `fa_withdraw` VALUES (1,4,'W202601220810435055',500.00,0.00,500.00,'中国银行','6217****1234',NULL,'张三','pending',NULL,NULL,NULL,NULL,'',1769040643,1769040643),(2,7,'W202601220815377781',500.00,0.00,500.00,'中国银行','6217****1234',NULL,'张三','pending',NULL,NULL,NULL,NULL,'',1769040937,1769040937),(3,2,'W202602090916102193',10000.00,0.00,10000.00,'中国工商银行','1111111111111111','','1','approved',NULL,1,1770599820,NULL,'',1770599770,1770599820),(4,2,'W202602090926150988',10000.00,0.00,10000.00,'中国工商银行','1111111111111111','','1','approved',NULL,1,1770600776,NULL,'',1770600375,1770600776);
/*!40000 ALTER TABLE `fa_withdraw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fa_withdraw_record`
--

DROP TABLE IF EXISTS `fa_withdraw_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fa_withdraw_record`
--

LOCK TABLES `fa_withdraw_record` WRITE;
/*!40000 ALTER TABLE `fa_withdraw_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `fa_withdraw_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'byhs_gynhc_com'
--

--
-- Dumping routines for database 'byhs_gynhc_com'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-10 18:35:42
