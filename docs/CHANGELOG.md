# 更新日志

## [2.0.0] - 2026-02-03

### 数据库字段重命名

#### 变更内容
- `fa_promo_performance` 表字段重命名
  - `month` → `period`（期数）
  - `personal_amount` → `personal_performance`（个人业绩）
  - `team_amount` → `team_performance`（团队业绩）
  - `growth_amount` → `growth`（业绩增量）
  - `direct_count` → `direct_invite_count`（直推人数）
  
- `fa_promo_bonus` 表字段重命名
  - `month` → `period`（期数）

#### 代码更新
- ✅ Model 层：`Performance.php`
- ✅ Service 层：`PromoService.php`、`SettlementService.php`
- ✅ Command 层：`Performance.php`
- ✅ API Controller：`Promo.php`
- ✅ Admin Controller：`Statistics.php`、`Relation.php`
- ✅ 语言包：`performance.php`、`bonus.php`

#### 数据库升级
- ✅ 执行 `backend/database/upgrade_v2.sql`
- ✅ 执行 `backend/database/upgrade_fix.sql`
- ✅ 测试通过率：100%（27/27项）

#### 测试工具
- 📁 `public/test_field_update.php` - 在线测试工具
- 📁 `public/check_update.bat` - 本地检查脚本

#### 文档
- 📄 `docs/数据库字段更新完成总结.md` - 详细总结
- 📄 `docs/测试执行指南.md` - 测试指南
- 📄 `docs/数据库字段更新说明.md` - 快速说明

### 注意事项
⚠️ 本次更新需要先执行数据库升级脚本，然后更新代码，最后清除缓存。

---

## [1.0.0] - 2026-02-02

### 初始版本
- 商户互助刷单平台基础功能
- 推广分销体系
- 等级权益系统
- 佣金分润机制
- 团队业绩分红
