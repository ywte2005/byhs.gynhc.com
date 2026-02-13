# 商户入驻流程 - 需求文档

## 简介

商户互助刷单平台的商户入驻系统，支持个人、个体工商户和企业三种主体类型的商户注册。系统包含完整的申请提交、风控审核、入驻费支付和奖励触发流程。

## 术语表

- **System**: 商户入驻系统
- **User**: 平台注册用户
- **Merchant**: 已入驻的商户
- **Admin**: 后台管理员
- **Applicant**: 提交入驻申请的用户
- **Entry_Fee**: 商户入驻费用
- **Audit_Record**: 审核记录
- **Reward_System**: 推广奖励系统

## 需求

### 需求 1: 商户类型选择

**用户故事:** 作为用户，我想选择不同的商户主体类型，以便根据我的实际情况进行入驻申请。

#### 验收标准

1. THE System SHALL 支持三种商户类型：个人(personal)、个体工商户(individual)、企业(enterprise)
2. WHEN 用户选择商户类型 THEN THE System SHALL 根据类型显示对应的必填字段
3. WHEN 用户选择个人类型 THEN THE System SHALL 要求上传身份证正反面照片
4. WHEN 用户选择个体工商户或企业类型 THEN THE System SHALL 要求上传营业执照

### 需求 2: 商户信息提交

**用户故事:** 作为申请人，我想提交完整的商户信息，以便平台审核我的入驻申请。

#### 验收标准

1. THE System SHALL 验证所有必填字段已填写
2. WHEN 提交商户名称 THEN THE System SHALL 限制长度不超过100个字符
3. WHEN 提交法人姓名 THEN THE System SHALL 限制长度不超过50个字符
4. WHEN 提交联系电话 THEN THE System SHALL 验证手机号格式正确性
5. WHEN 提交身份证号 THEN THE System SHALL 验证身份证号格式正确性
6. WHEN 提交银行账号 THEN THE System SHALL 验证账号格式正确性
7. WHEN 用户已有待审核申请 THEN THE System SHALL 阻止重复提交并提示"您的申请正在审核中，请耐心等待"
8. WHEN 用户已通过审核 THEN THE System SHALL 阻止重复提交并提示"您已通过审核"
9. WHEN 用户申请被拒绝 THEN THE System SHALL 允许重新提交申请

### 需求 3: 图片上传

**用户故事:** 作为申请人，我想上传身份证明和营业执照照片，以便完成入驻申请。

#### 验收标准

1. THE System SHALL 支持上传JPG、PNG格式的图片
2. WHEN 上传图片 THEN THE System SHALL 限制单个文件大小不超过5MB
3. WHEN 上传成功 THEN THE System SHALL 返回相对路径(url)和完整路径(fullurl)
4. WHEN 提交申请 THEN THE System SHALL 使用相对路径存储到数据库
5. WHEN 显示图片 THEN THE System SHALL 使用完整路径进行展示

### 需求 4: 商户审核

**用户故事:** 作为管理员，我想审核商户入驻申请，以便控制平台商户质量。

#### 验收标准

1. WHEN 管理员审核通过 THEN THE System SHALL 更新商户状态为approved
2. WHEN 管理员审核通过 THEN THE System SHALL 记录审核通过时间(approved_time)
3. WHEN 管理员审核通过 THEN THE System SHALL 创建审核记录到fa_merchant_audit表
4. WHEN 管理员审核拒绝 THEN THE System SHALL 更新商户状态为rejected
5. WHEN 管理员审核拒绝 THEN THE System SHALL 记录拒绝原因(reject_reason)
6. WHEN 管理员审核拒绝 THEN THE System SHALL 创建审核记录到fa_merchant_audit表
7. WHEN 审核操作 THEN THE System SHALL 使用数据库事务保证数据一致性
8. WHEN 审核操作 THEN THE System SHALL 使用悲观锁防止并发问题

### 需求 5: 入驻费配置

**用户故事:** 作为平台管理员，我想在后台配置入驻费金额，以便灵活调整入驻门槛。

#### 验收标准

1. THE System SHALL 在后台提供入驻费配置功能
2. THE System SHALL 支持设置默认入驻费金额
3. THE System SHALL 支持按商户类型设置不同的入驻费
4. WHEN 管理员修改入驻费配置 THEN THE System SHALL 只影响新申请的商户
5. WHEN 管理员修改入驻费配置 THEN THE System SHALL 不影响已审核通过的商户
6. THE System SHALL 支持设置入驻费为0（免费入驻）

### 需求 6: 入驻费支付

**用户故事:** 作为通过审核的商户，我想支付入驻费，以便获得商户资格并开始使用平台功能。

#### 验收标准

1. WHEN 商户状态为approved且未支付入驻费 THEN THE System SHALL 要求支付入驻费
2. WHEN 商户状态为approved且未支付入驻费 THEN THE System SHALL 阻止访问商户中心功能
3. WHEN 商户状态不是approved THEN THE System SHALL 阻止支付并提示"商户未通过审核"
4. WHEN 入驻费已支付 THEN THE System SHALL 阻止重复支付并提示"入驻费已支付"
5. WHEN 支付入驻费 THEN THE System SHALL 从用户钱包扣除对应金额
6. WHEN 支付入驻费 THEN THE System SHALL 更新entry_fee_paid字段为1
7. WHEN 支付入驻费 THEN THE System SHALL 创建钱包流水记录
8. WHEN 支付入驻费 THEN THE System SHALL 使用数据库事务保证数据一致性
9. WHEN 入驻费大于0 THEN THE System SHALL 触发推广奖励系统
10. WHEN 入驻费为0 THEN THE System SHALL 自动标记为已支付并允许访问商户中心
11. WHEN 用户钱包余额不足 THEN THE System SHALL 阻止支付并提示"余额不足，请先充值"

### 需求 7: 商户权限控制

**用户故事:** 作为系统，我想控制商户访问权限，以便确保只有完成入驻流程的商户才能使用平台功能。

#### 验收标准

1. WHEN 商户未支付入驻费 THEN THE System SHALL 阻止访问商户中心所有功能
2. WHEN 商户未支付入驻费 THEN THE System SHALL 阻止发布任务
3. WHEN 商户未支付入驻费 THEN THE System SHALL 阻止接受任务
4. WHEN 商户未支付入驻费 THEN THE System SHALL 显示"请先支付入驻费"提示
5. WHEN 商户已支付入驻费 THEN THE System SHALL 允许访问所有商户功能
6. WHEN 商户状态为disabled THEN THE System SHALL 阻止所有商户操作

### 需求 8: 入驻费支付页面

**用户故事:** 作为通过审核的商户，我想看到清晰的入驻费支付页面，以便了解费用详情并完成支付。

#### 验收标准

1. WHEN 商户审核通过且未支付 THEN THE System SHALL 显示入驻费支付页面
2. THE System SHALL 显示入驻费金额
3. THE System SHALL 显示当前钱包余额
4. THE System SHALL 显示支付后剩余余额
5. WHEN 余额不足 THEN THE System SHALL 显示充值按钮
6. WHEN 余额充足 THEN THE System SHALL 显示支付按钮
7. WHEN 点击支付 THEN THE System SHALL 弹出确认对话框
8. WHEN 支付成功 THEN THE System SHALL 跳转到商户中心
9. WHEN 支付失败 THEN THE System SHALL 显示错误提示

### 需求 9: 奖励触发

**用户故事:** 作为推荐人，我想在被推荐人完成入驻后获得奖励，以便获得推广收益。

#### 验收标准

1. WHEN 商户支付入驻费 THEN THE System SHALL 触发merchant_entry类型的奖励
2. WHEN 触发奖励 THEN THE System SHALL 向直推人发放直推奖
3. WHEN 触发奖励 THEN THE System SHALL 向间推人发放间推奖(如已配置)
4. WHEN 触发奖励 THEN THE System SHALL 按等级差向上级发放分润
5. WHEN 触发奖励 THEN THE System SHALL 记录所有奖励流水

### 需求 10: 商户状态查询

**用户故事:** 作为申请人，我想查询我的入驻申请状态，以便了解审核进度和下一步操作。

#### 验收标准

1. WHEN 用户未提交申请 THEN THE System SHALL 返回status=none
2. WHEN 用户申请审核中 THEN THE System SHALL 返回status=pending和message="审核中"
3. WHEN 用户申请已通过且未支付 THEN THE System SHALL 返回status=approved和message="待支付入驻费"
4. WHEN 用户申请已通过且未支付 THEN THE System SHALL 返回入驻费金额和钱包余额
5. WHEN 用户申请已通过且已支付 THEN THE System SHALL 返回status=approved和message="已入驻"
6. WHEN 用户申请被拒绝 THEN THE System SHALL 返回status=rejected和拒绝原因
7. WHEN 用户商户被禁用 THEN THE System SHALL 返回status=disabled

### 需求 11: 商户信息查询

**用户故事:** 作为商户，我想查看我的商户信息和统计数据，以便了解经营情况。

#### 验收标准

1. WHEN 查询商户信息 THEN THE System SHALL 返回商户基本信息
2. WHEN 查询商户信息 THEN THE System SHALL 对敏感信息进行脱敏处理
3. WHEN 脱敏身份证号 THEN THE System SHALL 只显示前6位和后4位
4. WHEN 脱敏银行账号 THEN THE System SHALL 只显示前4位和后4位
5. WHEN 查询商户信息 THEN THE System SHALL 返回任务统计数据
6. WHEN 查询商户信息 THEN THE System SHALL 返回收入统计数据
7. WHEN 查询商户信息 THEN THE System SHALL 返回信用分和等级信息

### 需求 12: 商户信息更新

**用户故事:** 作为商户，我想更新我的商户信息，以便保持信息准确性。

#### 验收标准

1. THE System SHALL 允许更新商户名称、法人姓名、联系电话、联系地址
2. THE System SHALL 允许更新经营类目、银行信息
3. THE System SHALL 阻止更新商户类型、身份证号等关键信息
4. WHEN 商户不存在 THEN THE System SHALL 返回错误"商户不存在"

### 需求 13: 商户禁用

**用户故事:** 作为管理员，我想禁用违规商户，以便维护平台秩序。

#### 验收标准

1. WHEN 管理员禁用商户 THEN THE System SHALL 更新商户状态为disabled
2. WHEN 商户被禁用 THEN THE System SHALL 阻止该商户发布新任务
3. WHEN 商户被禁用 THEN THE System SHALL 阻止该商户接受新任务
4. WHEN 商户被禁用 THEN THE System SHALL 在前端显示禁用原因和申诉说明

### 需求 14: 数据安全

**用户故事:** 作为平台运营方，我想保护用户敏感信息，以便符合数据安全规范。

#### 验收标准

1. THE System SHALL 对所有API接口进行Token校验
2. THE System SHALL 对敏感信息进行加密存储
3. THE System SHALL 对查询结果中的敏感信息进行脱敏
4. THE System SHALL 记录所有关键操作日志
5. THE System SHALL 使用HTTPS协议传输数据

### 需求 15: 并发控制

**用户故事:** 作为系统架构师，我想防止并发操作导致的数据不一致，以便保证系统稳定性。

#### 验收标准

1. WHEN 审核操作 THEN THE System SHALL 使用悲观锁(lock(true))锁定记录
2. WHEN 支付操作 THEN THE System SHALL 使用悲观锁锁定记录
3. WHEN 批量操作 THEN THE System SHALL 使用数据库事务保证原子性
4. WHEN 事务执行失败 THEN THE System SHALL 回滚所有操作

### 需求 16: 错误处理

**用户故事:** 作为用户，我想看到清晰的错误提示，以便知道如何修正问题。

#### 验收标准

1. WHEN 验证失败 THEN THE System SHALL 返回具体的错误字段和提示信息
2. WHEN 业务规则不满足 THEN THE System SHALL 返回友好的中文错误提示
3. WHEN 系统异常 THEN THE System SHALL 返回通用错误提示并记录详细日志
4. THE System SHALL 使用统一的API返回格式{code, msg, data}

### 需求 17: 银行列表

**用户故事:** 作为申请人，我想从预设的银行列表中选择，以便快速填写银行信息。

#### 验收标准

1. THE System SHALL 提供常用银行列表接口
2. THE System SHALL 包含至少15家主流银行
3. WHEN 查询银行列表 THEN THE System SHALL 返回银行代码和名称

### 需求 18: 经营类目

**用户故事:** 作为申请人，我想选择经营类目，以便平台了解我的业务范围。

#### 验收标准

1. THE System SHALL 提供经营类目树形结构接口
2. THE System SHALL 支持二级类目选择
3. WHEN 查询类目 THEN THE System SHALL 返回完整的树形结构数据

### 需求 19: 商户编号生成

**用户故事:** 作为系统，我想为每个商户生成唯一编号，以便标识和管理商户。

#### 验收标准

1. WHEN 创建商户 THEN THE System SHALL 自动生成商户编号
2. THE System SHALL 使用格式"M+年月日+5位随机数"生成编号
3. THE System SHALL 保证商户编号全局唯一

### 需求 20: 审核记录

**用户故事:** 作为管理员，我想查看商户的审核历史，以便追溯审核过程。

#### 验收标准

1. WHEN 审核通过或拒绝 THEN THE System SHALL 创建审核记录
2. THE System SHALL 记录审核人ID、审核动作、审核备注
3. THE System SHALL 记录审核时间(createtime)
4. THE System SHALL 支持查询商户的所有审核记录
