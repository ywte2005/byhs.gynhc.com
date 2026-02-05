# 数据库安装说明

## 数据库文件说明

| 文件 | 说明 |
|------|------|
| `01_promo_tables.sql` | 推广模块数据表（6张表） |
| `02_merchant_tables.sql` | 商户模块数据表（2张表） |
| `03_task_tables.sql` | 任务模块数据表（2张表） |
| `04_wallet_tables.sql` | 钱包模块数据表（3张表） |
| `05_config_tables.sql` | 配置模块数据表（3张表） |
| `06_init_data.sql` | 初始化数据 |

## 安装步骤

### 方法一：手动导入（推荐）

1. 创建数据库
```sql
CREATE DATABASE IF NOT EXISTS `fastadmin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `fastadmin`;
```

2. 按顺序导入 SQL 文件
```bash
mysql -u root -p fastadmin < 01_promo_tables.sql
mysql -u root -p fastadmin < 02_merchant_tables.sql
mysql -u root -p fastadmin < 03_task_tables.sql
mysql -u root -p fastadmin < 04_wallet_tables.sql
mysql -u root -p fastadmin < 05_config_tables.sql
mysql -u root -p fastadmin < 06_init_data.sql
```

### 方法二：使用安装脚本

Windows:
```bash
install.bat
```

Linux/Mac:
```bash
chmod +x install.sh
./install.sh
```

## 数据表清单

### 推广模块（6张表）
1. `fa_promo_level` - 等级配置表
2. `fa_promo_relation` - 用户推广关系表
3. `fa_promo_commission` - 佣金记录表
4. `fa_promo_bonus_config` - 分红配置表
5. `fa_promo_bonus` - 分红记录表
6. `fa_promo_performance` - 业绩统计表

### 商户模块（2张表）
7. `fa_merchant` - 商户信息表
8. `fa_merchant_audit` - 商户审核记录表

### 任务模块（2张表）
9. `fa_mutual_task` - 互助主任务表
10. `fa_sub_task` - 子任务表

### 钱包模块（3张表）
11. `fa_wallet` - 用户钱包表
12. `fa_wallet_log` - 钱包流水表
13. `fa_withdraw_record` - 提现记录表

### 配置模块（3张表）
14. `fa_reward_rule` - 奖励规则配置表
15. `fa_profit_rule` - 分润规则配置表
16. `fa_system_config_ext` - 系统配置扩展表

## 初始化数据说明

### 1. 等级配置（6个等级）
- 普通会员（免费）
- 初级代理（1000元）
- 中级代理（5000元）
- 高级代理（10000元）
- 市级代理（50000元）
- 省级代理（100000元）

### 2. 分红配置（4个档位）
- 基础分红（团队业绩10万+）
- 进阶分红（团队业绩50万+）
- 高级分红（团队业绩100万+）
- 顶级分红（团队业绩500万+）

### 3. 奖励规则（6条规则）
- 商户入驻：直推奖10%、间推奖5%
- 订单完成：直推奖1%、间推奖0.5%
- 等级升级：直推奖10%、间推奖5%

### 4. 分润规则（5个档位）
- 1级差：0.5%
- 2级差：1.0%
- 3级差：1.5%（需增量1万+）
- 4级差：2.0%（需增量5万+）
- 5级差：2.5%（需增量10万+）

### 5. 系统配置
- 子任务金额范围：2000-5000元
- 服务费率：5%
- 互助余额阈值：-50000/-20000
- 提现手续费：0.6%，最低2元
- 提现限额：100-50000元
- 分红时间：每月1号计算，3号发放

## 注意事项

1. **数据库字符集**：必须使用 `utf8mb4`
2. **存储引擎**：使用 `InnoDB`
3. **金额字段**：使用 `decimal` 类型
4. **时间字段**：使用 `int` 类型存储时间戳
5. **索引优化**：已添加常用查询字段的索引

## 验证安装

安装完成后，执行以下 SQL 验证：

```sql
-- 检查表数量
SELECT COUNT(*) as table_count FROM information_schema.tables 
WHERE table_schema = 'fastadmin' AND table_name LIKE 'fa_%';
-- 应该返回 16 张表

-- 检查等级配置
SELECT COUNT(*) as level_count FROM fa_promo_level;
-- 应该返回 6 条记录

-- 检查分红配置
SELECT COUNT(*) as bonus_count FROM fa_promo_bonus_config;
-- 应该返回 4 条记录

-- 检查奖励规则
SELECT COUNT(*) as reward_count FROM fa_reward_rule;
-- 应该返回 6 条记录

-- 检查分润规则
SELECT COUNT(*) as profit_count FROM fa_profit_rule;
-- 应该返回 5 条记录

-- 检查系统配置
SELECT COUNT(*) as config_count FROM fa_system_config_ext;
-- 应该返回 11 条记录
```

## 卸载

如需卸载，执行以下 SQL：

```sql
DROP TABLE IF EXISTS `fa_promo_level`;
DROP TABLE IF EXISTS `fa_promo_relation`;
DROP TABLE IF EXISTS `fa_promo_commission`;
DROP TABLE IF EXISTS `fa_promo_bonus_config`;
DROP TABLE IF EXISTS `fa_promo_bonus`;
DROP TABLE IF EXISTS `fa_promo_performance`;
DROP TABLE IF EXISTS `fa_merchant`;
DROP TABLE IF EXISTS `fa_merchant_audit`;
DROP TABLE IF EXISTS `fa_mutual_task`;
DROP TABLE IF EXISTS `fa_sub_task`;
DROP TABLE IF EXISTS `fa_wallet`;
DROP TABLE IF EXISTS `fa_wallet_log`;
DROP TABLE IF EXISTS `fa_withdraw_record`;
DROP TABLE IF EXISTS `fa_reward_rule`;
DROP TABLE IF EXISTS `fa_profit_rule`;
DROP TABLE IF EXISTS `fa_system_config_ext`;
```

---

**创建时间：** 2025-01-30  
**版本：** v1.0  
**状态：** ✅ 已完成
