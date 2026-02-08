# 商户互助平台 API 集成任务清单

## 一、项目概述

本文档基于对以下内容的分析生成：
- API接口文档.md - API规范定义
- xuqiu.md - 业务需求文档
- 开发方案.md - 技术方案文档
- 数据库Schema - byhs_gynhc_com_upgraded_20260203.sql
- 后端API控制器 - application/api/controller/
- 前端服务层 - cool-unix/services/

---

## 二、现有实现状态总结

### 2.1 数据库表（已创建）

| 表名 | 用途 | 状态 |
|------|------|------|
| fa_user | 用户表 | ✅ 已创建 |
| fa_merchant | 商户信息表 | ✅ 已创建 |
| fa_merchant_audit | 商户审核记录表 | ✅ 已创建 |
| fa_wallet | 钱包表 | ✅ 已创建 |
| fa_wallet_log | 钱包流水表 | ✅ 已创建 |
| fa_mutual_task | 互助主任务表 | ✅ 已创建 |
| fa_sub_task | 子任务表 | ✅ 已创建 |
| fa_promo_level | 等级配置表 | ✅ 已创建 |
| fa_promo_relation | 推广关系表 | ✅ 已创建 |
| fa_promo_commission | 佣金记录表 | ✅ 已创建 |
| fa_promo_performance | 业绩统计表 | ✅ 已创建 |
| fa_promo_bonus | 分红记录表 | ✅ 已创建 |
| fa_promo_bonus_config | 分红配置表 | ✅ 已创建 |
| fa_reward_rule | 奖励规则配置表 | ✅ 已创建 |
| fa_profit_rule | 分润规则配置表 | ✅ 已创建 |
| fa_recharge | 充值记录表 | ✅ 已创建 |
| fa_withdraw | 提现申请表 | ✅ 已创建 |
| fa_system_config_ext | 系统配置扩展表 | ✅ 已创建 |

### 2.2 后端API控制器

| 控制器 | 文件 | 状态 |
|--------|------|------|
| User | User.php | ✅ 已实现（登录/注册/个人信息） |
| Merchant | Merchant.php | ⚠️ 部分实现（缺少update接口） |
| Task | Task.php | ⚠️ 部分实现（缺少部分接口） |
| Wallet | Wallet.php | ⚠️ 部分实现（缺少配置接口） |
| Promo | Promo.php | ⚠️ 部分实现（有bug：$period未定义） |
| Notify | Notify.php | ❓ 待确认 |

### 2.3 前端服务层

| 服务 | 文件 | 状态 |
|------|------|------|
| auth.ts | 认证服务 | ✅ 已实现 |
| user.ts | 用户服务 | ✅ 已实现 |
| merchant.ts | 商户服务 | ⚠️ 部分实现 |
| task.ts | 任务服务 | ⚠️ 部分实现（API路径不匹配） |
| wallet.ts | 钱包服务 | ⚠️ 部分实现 |
| promo.ts | 推广服务 | ⚠️ 部分实现 |

---

## 三、API接口对照与差异分析

### 3.1 用户模块 (/api/user)

| API文档接口 | 后端实现 | 前端调用 | 状态 |
|-------------|----------|----------|------|
| POST /login | ✅ login() | ✅ | 完成 |
| POST /mobilelogin | ✅ mobilelogin() | ✅ | 完成 |
| POST /register | ✅ register() | ✅ | 完成 |
| GET /person | ✅ person() | ✅ | 完成 |
| POST /profile | ✅ profile() | ✅ | 完成 |
| POST /logout | ✅ logout() | ✅ | 完成 |

### 3.2 商户模块 (/api/merchant)

| API文档接口 | 后端实现 | 前端调用 | 状态 |
|-------------|----------|----------|------|
| GET /info | ✅ info() | ✅ getMerchantInfo() | 完成 |
| POST /register | ✅ register() | ✅ registerMerchant() | 完成 |
| GET /auditStatus | ✅ auditStatus() | ✅ getAuditStatus() | 完成 |
| POST /payEntryFee | ✅ payEntryFee() | ✅ payEntryFee() | 完成 |
| POST /update | ❌ 缺失 | ✅ updateMerchantInfo() | **需实现** |

### 3.3 任务模块 (/api/task)

| API文档接口 | 后端实现 | 前端调用 | 状态 |
|-------------|----------|----------|------|
| GET /list | ✅ list() | ✅ getTaskList() | 完成 |
| GET /detail | ✅ detail() | ⚠️ 参数名不匹配(id vs task_id) | **需修复** |
| POST /create | ✅ create() | ✅ createTask() | 完成 |
| POST /cancel | ⚠️ 返回暂不支持 | ✅ cancelTask() | **需实现** |
| GET /myTasks | ✅ myTasks() | ✅ getMyTasks() | 完成 |
| GET /subtaskAvailable | ✅ subtaskAvailable() | ⚠️ 路径不匹配(/task/subtask/available) | **需修复** |
| GET /subtaskMy | ✅ subtaskMy() | ⚠️ 路径不匹配(/task/subtask/my) | **需修复** |
| GET /subtaskDetail | ✅ subtaskDetail() | ⚠️ 参数名不匹配(id vs subtask_id) | **需修复** |
| POST /subtaskAccept | ✅ subtaskAccept() | ⚠️ 路径不匹配(/task/subtask/accept) | **需修复** |
| POST /subtaskUploadProof | ✅ subtaskUploadProof() | ⚠️ 路径不匹配(/task/subtask/uploadProof) | **需修复** |
| POST /subtaskCancel | ⚠️ 返回暂不支持 | ⚠️ 路径不匹配(/task/subtask/cancel) | **需实现** |
| GET /canReceive | ✅ canReceive() | ❌ 缺失 | **需添加前端** |
| GET /deposit/info | ❌ 缺失 | ✅ getDepositInfo() | **需实现** |
| POST /deposit/recharge | ❌ 缺失 | ✅ rechargeDeposit() | **需实现** |
| POST /deposit/withdraw | ❌ 缺失 | ✅ withdrawDeposit() | **需实现** |

### 3.4 钱包模块 (/api/wallet)

| API文档接口 | 后端实现 | 前端调用 | 状态 |
|-------------|----------|----------|------|
| GET /info | ✅ info() | ✅ getWalletInfo() | 完成 |
| GET /logs | ✅ logs() | ✅ getWalletLogs() | 完成 |
| POST /recharge | ✅ recharge() | ✅ recharge() | 完成 |
| POST /withdraw | ✅ withdraw() | ✅ withdraw() | 完成 |
| GET /withdrawRecords | ✅ withdrawRecords() | ✅ getWithdrawRecords() | 完成 |
| POST /depositPay | ✅ depositPay() | ❌ 缺失 | **需添加前端** |
| POST /depositWithdraw | ✅ depositWithdraw() | ❌ 缺失 | **需添加前端** |
| GET /withdrawConfig | ❌ 缺失 | ✅ getWithdrawConfig() | **需实现** |

### 3.5 推广模块 (/api/promo)

| API文档接口 | 后端实现 | 前端调用 | 状态 |
|-------------|----------|----------|------|
| GET /overview | ✅ overview() | ✅ getOverview() | 完成 |
| GET /levels | ✅ levels() | ✅ getLevels() | 完成 |
| POST /purchaseLevel | ✅ purchaseLevel() | ✅ purchaseLevel() | 完成 |
| GET /myInviteCode | ✅ myInviteCode() | ✅ getMyInviteCode() | 完成 |
| POST /bindRelation | ✅ bindRelation() | ✅ bindRelation() | 完成 |
| GET /myTeam | ✅ myTeam() | ✅ getMyTeam() | 完成 |
| GET /commissionList | ✅ commissionList() | ✅ getCommissionList() | 完成 |
| GET /walletLogs | ✅ walletLogs() | ✅ getWalletLogs() | 完成 |
| GET /performanceSummary | ⚠️ 有bug($period未定义) | ✅ getPerformanceSummary() | **需修复** |
| GET /bonusSummary | ✅ bonusSummary() | ✅ getBonusSummary() | 完成 |
| GET /bonusRecords | ✅ bonusRecords() | ✅ getBonusRecords() | 完成 |

---

## 四、集成任务清单

### 4.1 高优先级 - 后端Bug修复

#### Task-001: 修复 Promo.php performanceSummary() 方法 ✅ 已完成
- **文件**: `application/api/controller/Promo.php`
- **问题**: 第113行使用了未定义变量 `$period`，应为 `$month`
- **状态**: 已修复

### 4.2 高优先级 - 后端缺失接口实现

#### Task-002: 实现 Merchant::update() 接口 ✅ 已完成
- **文件**: `application/api/controller/Merchant.php`
- **功能**: 更新商户信息
- **状态**: 已实现，包含 MerchantService::updateMerchant()

#### Task-003: 实现 Task::cancel() 接口 ✅ 已完成
- **文件**: `application/api/controller/Task.php`
- **功能**: 取消任务
- **状态**: 已实现，包含完整业务逻辑（检查子任务状态、解冻保证金、退回余额）

#### Task-004: 实现 Task::subtaskCancel() 接口 ✅ 已完成
- **文件**: `application/api/controller/Task.php`
- **功能**: 取消接单
- **状态**: 已实现

#### Task-005: 实现任务保证金相关接口 ✅ 已完成
- **文件**: `application/api/controller/Task.php`
- **接口**:
  - `depositInfo()` - 获取保证金信息 ✅
  - `depositRecharge()` - 充值保证金 ✅
  - `depositWithdraw()` - 提取保证金 ✅

#### Task-006: 实现 Wallet::withdrawConfig() 接口 ✅ 已完成
- **文件**: `application/api/controller/Wallet.php`
- **功能**: 获取提现配置（从 fa_system_config_ext 读取）
- **状态**: 已实现

### 4.3 中优先级 - 前端API路径修复

#### Task-007: 修复 task.ts 中的API路径 ✅ 已完成
- **文件**: `cool-unix/services/task.ts`
- **状态**: 所有路径已修复

#### Task-008: 修复前端参数名不匹配 ✅ 已完成
- **文件**: `cool-unix/services/task.ts`
- **修改**:
  - `getTaskDetail()`: `id` -> `task_id` ✅
  - `getSubTaskDetail()`: `id` -> `subtask_id` ✅

### 4.4 中优先级 - 前端缺失服务方法

#### Task-009: 添加 canReceive 方法到 task.ts ✅ 已完成
- **状态**: 已添加 `canReceiveTask()` 方法

#### Task-010: 添加保证金操作方法到 wallet.ts ✅ 已完成
- **状态**: 已添加 `depositPay()` 和 `depositWithdraw()` 方法

### 4.5 低优先级 - 功能增强

#### Task-011: 完善任务取消逻辑 ✅ 已完成
- **实现的业务规则**:
  - 允许取消状态：pending, approved, running, paused
  - 存在进行中子任务（accepted/paid/verified）时不允许取消
  - 取消时解冻已派发子任务的保证金
  - 退回剩余保证金到余额

#### Task-012: 完善子任务取消逻辑 ✅ 已完成
- **实现的业务规则**:
  - 允许取消状态：assigned, accepted
  - 取消后子任务状态重置为 pending
  - 解冻发起方的保证金

#### Task-013: 添加银行卡管理接口 ✅ 已完成
- **新增文件**:
  - `application/common/model/wallet/Bankcard.php` - 银行卡模型
  - `backend/database/12_bankcard_table.sql` - 数据库表
- **新增接口**:
  - GET /wallet/bankcards - 获取银行卡列表 ✅
  - POST /wallet/addBankcard - 添加银行卡 ✅
  - POST /wallet/deleteBankcard - 删除银行卡 ✅
  - POST /wallet/setDefaultBankcard - 设置默认银行卡 ✅
- **前端服务**: `cool-unix/services/wallet.ts` 已添加对应方法

#### Task-014: 添加消息通知接口 ✅ 已完成
- **新增文件**:
  - `application/common/model/Message.php` - 消息模型
  - `application/api/controller/Message.php` - 消息控制器
  - `backend/database/12_bankcard_table.sql` - 包含消息表
- **新增接口**:
  - GET /message/list - 获取消息列表 ✅
  - GET /message/unreadCount - 获取未读数量 ✅
  - GET /message/detail - 获取消息详情 ✅
  - POST /message/markRead - 标记已读 ✅
  - POST /message/markAllRead - 全部标记已读 ✅
  - POST /message/delete - 删除消息 ✅
- **前端服务**: `cool-unix/services/message.ts` 已更新参数匹配

---

## 五、数据模型补充建议

### 5.1 建议新增表

#### fa_user_bankcard (用户银行卡表)
```sql
CREATE TABLE `fa_user_bankcard` (
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
```

#### fa_message (消息表)
```sql
CREATE TABLE `fa_message` (
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
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';
```

---

## 六、执行计划

### 第一阶段：Bug修复 ✅ 已完成
1. Task-001: 修复 Promo.php bug ✅
2. Task-007: 修复前端API路径 ✅
3. Task-008: 修复前端参数名 ✅

### 第二阶段：核心接口补全 ✅ 已完成
1. Task-002: Merchant::update() ✅
2. Task-005: 任务保证金接口 ✅
3. Task-006: Wallet::withdrawConfig() ✅
4. Task-009: 前端 canReceive 方法 ✅
5. Task-010: 前端保证金方法 ✅

### 第三阶段：功能完善 ✅ 已完成
1. Task-003: Task::cancel() ✅
2. Task-004: Task::subtaskCancel() ✅
3. Task-011-012: 取消逻辑完善 ✅

### 第四阶段：功能扩展 ✅ 已完成
1. Task-013: 银行卡管理 ✅
2. Task-014: 消息通知 ✅

---

## 七、测试要点

### 7.1 接口测试
- 所有接口需要验证Token认证
- 验证参数校验逻辑
- 验证错误响应格式

### 7.2 业务流程测试
- 商户入驻完整流程
- 任务创建->审核->派发->接单->完成流程
- 钱包充值->提现流程
- 推广关系绑定->佣金计算流程

### 7.3 并发测试
- 子任务接单并发控制
- 钱包余额变动并发控制

---

## 八、新增文件清单

### 后端文件
| 文件路径 | 说明 |
|----------|------|
| `application/api/controller/Message.php` | 消息API控制器 |
| `application/common/model/Message.php` | 消息模型 |
| `application/common/model/wallet/Bankcard.php` | 银行卡模型 |
| `backend/database/12_bankcard_table.sql` | 银行卡和消息表SQL |

### 修改的后端文件
| 文件路径 | 修改内容 |
|----------|----------|
| `application/api/controller/Promo.php` | 修复 $period bug |
| `application/api/controller/Merchant.php` | 新增 update() 方法 |
| `application/api/controller/Task.php` | 新增 cancel(), depositInfo/Recharge/Withdraw() |
| `application/api/controller/Wallet.php` | 新增 withdrawConfig(), 银行卡管理接口 |
| `application/common/library/MerchantService.php` | 新增 updateMerchant() |
| `application/common/library/TaskService.php` | 新增 cancelTask(), cancelSubTask() |

### 修改的前端文件
| 文件路径 | 修改内容 |
|----------|----------|
| `cool-unix/services/task.ts` | 修复API路径，新增 canReceiveTask() |
| `cool-unix/services/wallet.ts` | 新增 depositPay/Withdraw(), 银行卡管理方法 |
| `cool-unix/services/message.ts` | 修复API参数匹配 |

### 前端页面API集成更新
| 文件路径 | 修改内容 |
|----------|----------|
| `cool-unix/pages/index/home.uvue` | 首页统计数据API集成，数据格式化 |
| `cool-unix/pages/wallet/index.uvue` | 钱包首页API集成，余额和流水加载 |
| `cool-unix/pages/wallet/logs.uvue` | 钱包流水API集成，分页和筛选 |
| `cool-unix/pages/wallet/withdraw.uvue` | 提现页面API集成，银行卡加载 |
| `cool-unix/pages/wallet/bankcard.uvue` | 银行卡管理API集成，增删改查 |
| `cool-unix/pages/message/index.uvue` | 消息列表API集成，标记已读 |
| `cool-unix/pages/promo/index.uvue` | 推广中心API集成，数据展示 |
| `cool-unix/pages/task/detail.uvue` | 任务详情API集成，状态映射 |
| `cool-unix/pages/task/deposit.uvue` | 保证金管理API集成，充值提取 |
| `cool-unix/pages/task/my-tasks.uvue` | 我的任务API集成，分页筛选 |
| `cool-unix/pages/task/subtask/list.uvue` | 可接子任务API集成，接单功能 |
| `cool-unix/pages/task/subtask/detail.uvue` | 子任务详情API集成，取消接单 |
| `cool-unix/pages/merchant/audit-status.uvue` | 审核状态API集成，数据格式化 |

---

## 九、前端页面API集成详情

### 9.1 首页模块 (pages/index)
| 页面 | API调用 | 状态 |
|------|---------|------|
| home.uvue | getStatistics() | ✅ 已集成 |

### 9.2 钱包模块 (pages/wallet)
| 页面 | API调用 | 状态 |
|------|---------|------|
| index.uvue | getWalletInfo(), getWalletLogs() | ✅ 已集成 |
| logs.uvue | getWalletLogs() | ✅ 已集成 |
| withdraw.uvue | getWalletInfo(), getBankcards(), withdraw() | ✅ 已集成 |
| bankcard.uvue | getBankcards(), deleteBankcard() | ✅ 已集成 |

### 9.3 消息模块 (pages/message)
| 页面 | API调用 | 状态 |
|------|---------|------|
| index.uvue | getMessageList(), markAsRead(), markAllAsRead() | ✅ 已集成 |

### 9.4 推广模块 (pages/promo)
| 页面 | API调用 | 状态 |
|------|---------|------|
| index.uvue | getOverview() | ✅ 已集成 |

### 9.5 任务模块 (pages/task)
| 页面 | API调用 | 状态 |
|------|---------|------|
| detail.uvue | getTaskDetail(), cancelTask() | ✅ 已集成 |
| deposit.uvue | getDepositInfo(), rechargeDeposit(), withdrawDeposit() | ✅ 已集成 |
| my-tasks.uvue | getMyTasks() | ✅ 已集成 |
| subtask/list.uvue | getAvailableSubTasks(), acceptSubTask() | ✅ 已集成 |
| subtask/detail.uvue | getSubTaskDetail(), cancelSubTask() | ✅ 已集成 |

### 9.6 商户模块 (pages/merchant)
| 页面 | API调用 | 状态 |
|------|---------|------|
| audit-status.uvue | getAuditStatus() | ✅ 已集成 |

---

---

## 十、后台管理模块补充

### 10.1 新增后台管理控制器

| 控制器 | 文件路径 | 功能说明 |
|--------|----------|----------|
| Message | `application/admin/controller/Message.php` | 消息管理（列表、发送、详情、删除、标记已读） |
| Bankcard | `application/admin/controller/wallet/Bankcard.php` | 银行卡管理（列表、详情、启用、禁用、删除） |

### 10.2 新增后台视图模板

| 模块 | 文件路径 | 说明 |
|------|----------|------|
| 消息管理 | `application/admin/view/message/index.html` | 消息列表页 |
| 消息管理 | `application/admin/view/message/add.html` | 发送消息页 |
| 消息管理 | `application/admin/view/message/detail.html` | 消息详情页 |
| 银行卡管理 | `application/admin/view/wallet/bankcard/index.html` | 银行卡列表页 |
| 银行卡管理 | `application/admin/view/wallet/bankcard/detail.html` | 银行卡详情页 |

### 10.3 新增后台JavaScript

| 文件路径 | 说明 |
|----------|------|
| `public/assets/js/backend/message.js` | 消息管理前端逻辑 |
| `public/assets/js/backend/wallet/bankcard.js` | 银行卡管理前端逻辑 |

### 10.4 模型关联更新

| 模型 | 文件路径 | 新增关联 |
|------|----------|----------|
| Message | `application/common/model/Message.php` | 添加 `user()` 关联 |
| Bankcard | `application/common/model/wallet/Bankcard.php` | 添加 `user()` 关联 |

### 10.5 后台菜单SQL

- **文件**: `backend/database/13_admin_menu.sql`
- **内容**: 消息管理和银行卡管理的菜单权限配置
- **使用**: 执行SQL后需在后台【权限管理】-【角色组】中分配权限

### 10.6 现有后台管理模块对照

| 模块 | 控制器 | 状态 |
|------|--------|------|
| 用户管理 | `user/User`, `user/Group`, `user/Rule` | ✅ 已有 |
| 商户管理 | `merchant/Merchant`, `merchant/Audit` | ✅ 已有 |
| 任务管理 | `task/Mutualtask`, `task/Subtask` | ✅ 已有 |
| 钱包管理 | `wallet/Wallet`, `wallet/Log`, `wallet/Recharge`, `wallet/Withdraw` | ✅ 已有 |
| 银行卡管理 | `wallet/Bankcard` | ✅ 新增 |
| 推广管理 | `promo/Level`, `promo/Relation`, `promo/Commission`, `promo/Performance`, `promo/Bonus` | ✅ 已有 |
| 消息管理 | `Message` | ✅ 新增 |

---

*文档生成时间: 2025-01-22*
*最后更新: 2025-02-08*
*版本: 4.0*
*状态: 所有任务已完成 ✅ (包括前端页面API集成和后台管理模块)*
