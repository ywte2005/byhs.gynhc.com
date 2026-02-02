# 商户互助平台 - API接口文档

**版本**: v1.0  
**基础路径**: `/api`  
**文档生成时间**: 2025-01-22

---

## 目录

- [1. 通用说明](#1-通用说明)
- [2. 用户模块](#2-用户模块)
- [3. 商户模块](#3-商户模块)
- [4. 任务模块](#4-任务模块)
- [5. 钱包模块](#5-钱包模块)
- [6. 推广模块](#6-推广模块)
- [7. 回调接口](#7-回调接口)
- [8. 通用接口](#8-通用接口)

---

## 1. 通用说明

### 1.1 请求规范

**请求头**
```
Content-Type: application/x-www-form-urlencoded
token: {用户token}
```

**响应格式**
```json
{
  "code": 0,
  "message": "操作成功",
  "data": {}
}
```

**状态码说明**
- `0`: 成功
- `1001`: 参数缺失
- `1002`: 参数格式错误
- `2001`: 未登录
- `2002`: 无权限操作
- `3001`: 当前状态不允许该操作
- `5001`: 系统异常

### 1.2 认证机制

除特殊说明外，所有接口均需要在请求头中携带 `token` 参数。

获取token方式：
1. 用户登录接口 `/api/user/login`
2. 手机验证码登录 `/api/user/mobilelogin`

---

## 2. 用户模块

### 2.1 账号密码登录

**接口地址**: `/api/user/login`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| account | string | 是 | 账号（用户名/手机号） |
| password | string | 是 | 密码 |

**返回示例**
```json
{
  "code": 0,
  "message": "登录成功",
  "data": {
    "userinfo": {
      "id": 1,
      "username": "testuser",
      "nickname": "测试用户",
      "mobile": "13800138000",
      "avatar": "",
      "token": "abc123..."
    }
  }
}
```

---

### 2.2 手机验证码登录

**接口地址**: `/api/user/mobilelogin`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| mobile | string | 是 | 手机号 |
| captcha | string | 是 | 短信验证码 |

**返回示例**
```json
{
  "code": 0,
  "message": "登录成功",
  "data": {
    "userinfo": {
      "id": 1,
      "username": "13800138000",
      "mobile": "13800138000",
      "token": "abc123..."
    }
  }
}
```

---

### 2.3 用户注册

**接口地址**: `/api/user/register`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| username | string | 是 | 用户名 |
| password | string | 是 | 密码 |
| mobile | string | 是 | 手机号 |
| code | string | 是 | 短信验证码 |
| email | string | 否 | 邮箱 |

**返回示例**
```json
{
  "code": 0,
  "message": "注册成功",
  "data": {
    "userinfo": {
      "id": 2,
      "username": "newuser",
      "token": "abc123..."
    }
  }
}
```

---

### 2.4 退出登录

**接口地址**: `/api/user/logout`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "退出成功",
  "data": {}
}
```

---

### 2.5 修改个人信息

**接口地址**: `/api/user/profile`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| username | string | 否 | 用户名 |
| nickname | string | 否 | 昵称 |
| avatar | string | 否 | 头像地址 |
| bio | string | 否 | 个人简介 |

**返回示例**
```json
{
  "code": 0,
  "message": "操作成功",
  "data": {}
}
```

---

### 2.6 重置密码

**接口地址**: `/api/user/resetpwd`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| mobile | string | 是 | 手机号 |
| newpassword | string | 是 | 新密码 |
| captcha | string | 是 | 短信验证码 |

**返回示例**
```json
{
  "code": 0,
  "message": "重置成功",
  "data": {}
}
```

---

## 3. 商户模块

### 3.1 获取商户信息

**接口地址**: `/api/merchant/info`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "merchant": {
      "id": 1,
      "merchant_no": "M20250122001",
      "name": "测试商户",
      "legal_name": "张三",
      "id_card": "110101199001011234",
      "contact_phone": "13800138000",
      "bank_name": "中国银行",
      "bank_account": "6217000010001234567",
      "status": "approved",
      "createtime": 1705887600
    }
  }
}
```

**商户状态说明**
- `pending`: 待审核
- `approved`: 审核通过
- `rejected`: 审核拒绝
- `disabled`: 已禁用

---

### 3.2 商户注册

**接口地址**: `/api/merchant/register`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| name | string | 是 | 商户名称（最大100字符） |
| legal_name | string | 是 | 法人姓名（最大50字符） |
| id_card | string | 是 | 身份证号（18位） |
| id_card_front | string | 否 | 身份证正面 |
| id_card_back | string | 否 | 身份证背面 |
| business_license | string | 否 | 营业执照 |
| contact_phone | string | 是 | 联系电话 |
| bank_name | string | 否 | 银行名称 |
| bank_account | string | 否 | 银行账号 |
| bank_branch | string | 否 | 开户行 |

**返回示例**
```json
{
  "code": 0,
  "message": "提交成功，等待审核",
  "data": {
    "merchant": {
      "id": 1,
      "merchant_no": "M20250122001",
      "status": "pending"
    }
  }
}
```

---

### 3.3 获取审核状态

**接口地址**: `/api/merchant/auditStatus`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "status": "approved",
    "reject_reason": null,
    "approved_time": 1705887600
  }
}
```

---

### 3.4 支付入驻费

**接口地址**: `/api/merchant/payEntryFee`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pay_method | string | 否 | 支付方式（balance-余额, deposit-保证金） |

**返回示例**
```json
{
  "code": 0,
  "message": "支付成功",
  "data": {
    "merchant": {
      "entry_fee_paid": 1
    }
  }
}
```

---

## 4. 任务模块

### 4.1 任务列表

**接口地址**: `/api/task/list`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |
| status | string | 否 | 任务状态 |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "id": 1,
        "task_no": "T20250122001",
        "total_amount": "10000.00",
        "deposit_amount": "2000.00",
        "status": "running",
        "split_count": 3,
        "completed_count": 1,
        "createtime": 1705887600
      }
    ],
    "total": 10
  }
}
```

**任务状态说明**
- `pending`: 待审核
- `approved`: 审核通过
- `running`: 进行中
- `completed`: 已完成
- `rejected`: 已拒绝
- `cancelled`: 已取消

---

### 4.2 创建任务

**接口地址**: `/api/task/create`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| total_amount | decimal | 是 | 总金额（大于0） |
| deposit_amount | decimal | 是 | 保证金（大于0） |

**返回示例**
```json
{
  "code": 0,
  "message": "创建成功，等待审核",
  "data": {
    "task": {
      "id": 1,
      "task_no": "T20250122001",
      "total_amount": "10000.00",
      "deposit_amount": "2000.00",
      "status": "pending"
    }
  }
}
```

---

### 4.3 任务详情

**接口地址**: `/api/task/detail`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| task_id | int | 是 | 任务ID |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "task": {
      "id": 1,
      "task_no": "T20250122001",
      "total_amount": "10000.00",
      "deposit_amount": "2000.00",
      "frozen_amount": "5000.00",
      "status": "running",
      "split_count": 3,
      "completed_count": 1,
      "createtime": 1705887600
    }
  }
}
```

---

### 4.4 我的任务

**接口地址**: `/api/task/myTasks`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**: 同任务列表

---

### 4.5 可接子任务列表

**接口地址**: `/api/task/subtaskAvailable`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "id": 1,
        "task_no": "ST20250122001",
        "amount": "5000.00",
        "commission": "50.00",
        "status": "assigned",
        "createtime": 1705887600
      }
    ],
    "total": 5
  }
}
```

**子任务状态说明**
- `pending`: 待派发
- `assigned`: 已派发
- `accepted`: 已接单
- `paid`: 已支付
- `verified`: 已验证
- `completed`: 已完成
- `failed`: 已失败
- `cancelled`: 已取消

---

### 4.6 我的子任务

**接口地址**: `/api/task/subtaskMy`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**: 同可接子任务列表

---

### 4.7 子任务详情

**接口地址**: `/api/task/subtaskDetail`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| subtask_id | int | 是 | 子任务ID |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "subtask": {
      "id": 1,
      "task_no": "ST20250122001",
      "amount": "5000.00",
      "commission": "50.00",
      "status": "accepted",
      "proof_image": null,
      "third_order_no": null,
      "createtime": 1705887600
    }
  }
}
```

---

### 4.8 接单

**接口地址**: `/api/task/subtaskAccept`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| subtask_id | int | 是 | 子任务ID |

**返回示例**
```json
{
  "code": 0,
  "message": "接单成功",
  "data": {
    "subtask": {
      "id": 1,
      "status": "accepted",
      "accepted_time": 1705887600
    }
  }
}
```

---

### 4.9 检查是否可接单

**接口地址**: `/api/task/canReceive`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "can": true,
    "reason": ""
  }
}
```

**不可接单原因**
- 互助余额过低（< -50000）
- 保证金不足
- 账户异常

---

### 4.10 上传凭证

**接口地址**: `/api/task/subtaskUploadProof`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| subtask_id | int | 是 | 子任务ID |
| proof_image | string | 是 | 凭证图片地址 |
| third_order_no | string | 否 | 第三方订单号 |

**返回示例**
```json
{
  "code": 0,
  "message": "上传成功",
  "data": {
    "subtask": {
      "id": 1,
      "status": "paid",
      "proof_image": "/uploads/proof.jpg",
      "paid_time": 1705887600
    }
  }
}
```

---

## 5. 钱包模块

### 5.1 钱包信息

**接口地址**: `/api/wallet/info`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "wallet": {
      "balance": "1000.00",
      "deposit": "5000.00",
      "frozen": "0.00",
      "mutual_balance": "0.00",
      "total_income": "10000.00",
      "total_withdraw": "2000.00",
      "available_deposit": "5000.00"
    }
  }
}
```

**字段说明**
- `balance`: 余额
- `deposit`: 保证金
- `frozen`: 冻结金额
- `mutual_balance`: 互助余额
- `total_income`: 累计收入
- `total_withdraw`: 累计提现
- `available_deposit`: 可用保证金（保证金-冻结）

---

### 5.2 钱包流水

**接口地址**: `/api/wallet/logs`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |
| wallet_type | string | 否 | 钱包类型（balance-余额, deposit-保证金） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "id": 1,
        "wallet_type": "balance",
        "change_type": "income",
        "amount": "100.00",
        "balance_before": "900.00",
        "balance_after": "1000.00",
        "biz_type": "recharge",
        "remark": "充值到账",
        "createtime": 1705887600
      }
    ],
    "total": 50
  }
}
```

---

### 5.3 充值下单

**接口地址**: `/api/wallet/recharge`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| amount | decimal | 是 | 充值金额（大于0） |
| target | string | 否 | 充值目标（balance-余额, deposit-保证金，默认balance） |
| pay_method | string | 否 | 支付方式 |

**返回示例**
```json
{
  "code": 0,
  "message": "创建成功",
  "data": {
    "recharge": {
      "id": 1,
      "order_no": "R20250122001",
      "amount": "1000.00",
      "target": "balance",
      "status": "pending",
      "pay_url": "https://pay.example.com/..."
    }
  }
}
```

---

### 5.4 申请提现

**接口地址**: `/api/wallet/withdraw`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| amount | decimal | 是 | 提现金额（大于0） |
| bank_name | string | 是 | 银行名称 |
| bank_account | string | 是 | 银行账号 |
| bank_branch | string | 否 | 开户行 |
| account_name | string | 是 | 开户人姓名 |

**返回示例**
```json
{
  "code": 0,
  "message": "提现申请已提交",
  "data": {
    "withdraw": {
      "id": 1,
      "withdraw_no": "W20250122001",
      "amount": "500.00",
      "status": "pending",
      "createtime": 1705887600
    }
  }
}
```

**提现状态说明**
- `pending`: 待审核
- `approved`: 审核通过
- `paid`: 已打款
- `rejected`: 已拒绝

---

### 5.5 提现记录

**接口地址**: `/api/wallet/withdrawRecords`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "id": 1,
        "withdraw_no": "W20250122001",
        "amount": "500.00",
        "status": "paid",
        "bank_name": "中国银行",
        "bank_account": "6217****1234",
        "createtime": 1705887600
      }
    ],
    "total": 10
  }
}
```

---

### 5.6 充值保证金

**接口地址**: `/api/wallet/depositPay`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| amount | decimal | 是 | 金额（大于0） |

**说明**: 从余额中扣除，充值到保证金

**返回示例**
```json
{
  "code": 0,
  "message": "充值成功",
  "data": {
    "wallet": {
      "balance": "500.00",
      "deposit": "5500.00"
    }
  }
}
```

---

### 5.7 提取保证金

**接口地址**: `/api/wallet/depositWithdraw`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| amount | decimal | 是 | 金额（大于0） |

**说明**: 从保证金中提取，转入余额（需保证金可用余额充足）

**返回示例**
```json
{
  "code": 0,
  "message": "提取成功",
  "data": {
    "wallet": {
      "balance": "1500.00",
      "deposit": "4500.00"
    }
  }
}
```

---

## 6. 推广模块

### 6.1 推广概览

**接口地址**: `/api/promo/overview`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "invite_code": "ABC123",
    "level_id": 1,
    "level_name": "银卡会员",
    "parent_id": 0,
    "depth": 1,
    "team_count": 10,
    "direct_count": 5
  }
}
```

---

### 6.2 等级列表

**接口地址**: `/api/promo/levels`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "levels": [
      {
        "id": 1,
        "name": "普通会员",
        "upgrade_price": "0.00",
        "upgrade_type": "free",
        "sort": 0
      },
      {
        "id": 2,
        "name": "银卡会员",
        "upgrade_price": "1000.00",
        "upgrade_type": "both",
        "sort": 1
      }
    ]
  }
}
```

**升级类型说明**
- `free`: 免费
- `pay`: 付费
- `performance`: 业绩达标
- `both`: 付费或业绩达标

---

### 6.3 购买等级

**接口地址**: `/api/promo/purchaseLevel`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| level_id | int | 是 | 等级ID |
| pay_method | string | 否 | 支付方式（balance-余额，默认balance） |

**返回示例**
```json
{
  "code": 0,
  "message": "购买成功",
  "data": {
    "relation": {
      "level_id": 2,
      "level_name": "银卡会员"
    }
  }
}
```

---

### 6.4 我的邀请码

**接口地址**: `/api/promo/myInviteCode`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "invite_code": "ABC123"
  }
}
```

---

### 6.5 绑定上级

**接口地址**: `/api/promo/bindRelation`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| invite_code | string | 是 | 邀请码 |

**返回示例**
```json
{
  "code": 0,
  "message": "绑定成功",
  "data": {
    "relation": {
      "parent_id": 10,
      "depth": 2
    }
  }
}
```

---

### 6.6 我的团队

**接口地址**: `/api/promo/myTeam`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "user_id": 20,
        "username": "user20",
        "level_name": "普通会员",
        "depth": 1,
        "createtime": 1705887600
      }
    ],
    "total": 10
  }
}
```

---

### 6.7 佣金记录

**接口地址**: `/api/promo/commissionList`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "id": 1,
        "scene": "task_complete",
        "reward_type": "direct",
        "amount": "50.00",
        "from_user_id": 20,
        "status": "settled",
        "createtime": 1705887600
      }
    ],
    "total": 50
  }
}
```

**奖励类型说明**
- `direct`: 直推奖
- `indirect`: 间推奖
- `level_diff`: 级差奖
- `peer`: 平级奖
- `team`: 团队奖

---

### 6.8 业绩汇总

**接口地址**: `/api/promo/performanceSummary`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| month | string | 否 | 月份（格式：YYYY-MM，默认当月） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "month": "2025-01",
    "personal_amount": "5000.00",
    "team_amount": "50000.00",
    "growth": {
      "personal_rate": "20%",
      "team_rate": "15%"
    }
  }
}
```

---

### 6.9 分红汇总

**接口地址**: `/api/promo/bonusSummary`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**: 无

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "total_bonus": "10000.00",
    "pending_bonus": "1000.00"
  }
}
```

---

### 6.10 分红记录

**接口地址**: `/api/promo/bonusRecords`  
**请求方式**: `GET`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | int | 否 | 页码（默认1） |
| limit | int | 否 | 每页数量（默认20） |

**返回示例**
```json
{
  "code": 0,
  "message": "获取成功",
  "data": {
    "list": [
      {
        "id": 1,
        "month": "2024-12",
        "amount": "1000.00",
        "status": "settled",
        "settled_time": 1705887600
      }
    ],
    "total": 12
  }
}
```

---

## 7. 回调接口

### 7.1 充值回调

**接口地址**: `/api/notify/recharge`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| out_trade_no | string | 是 | 商户订单号 |
| trade_no | string | 是 | 第三方交易号 |
| amount | decimal | 是 | 金额 |
| status | string | 是 | 状态（success/paid） |
| sign | string | 是 | 签名 |

**说明**: 由第三方支付平台回调，用于充值订单到账通知

**返回示例**
```json
{
  "code": 0,
  "message": "处理成功",
  "data": {}
}
```

---

### 7.2 刷单验证回调

**接口地址**: `/api/notify/subtask`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| order_no | string | 是 | 第三方订单号 |
| amount | decimal | 是 | 金额 |
| status | string | 是 | 状态（success/paid） |
| sign | string | 是 | 签名 |

**说明**: 由第三方平台推送交易数据，用于验证子任务支付凭证

**返回示例**
```json
{
  "code": 0,
  "message": "处理成功",
  "data": {}
}
```

---

### 7.3 手动验证子任务

**接口地址**: `/api/notify/verifySubTask`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| subtask_id | int | 是 | 子任务ID |
| third_order_no | string | 否 | 第三方订单号 |

**说明**: 由管理员或定时任务调用，主动查询第三方订单状态

**返回示例**
```json
{
  "code": 0,
  "message": "验证通过，任务已完成",
  "data": {}
}
```

---

## 8. 通用接口

### 8.1 初始化配置

**接口地址**: `/api/common/init`  
**请求方式**: `GET`  
**是否需要登录**: 否

**返回示例**
```json
{
  "code": 0,
  "message": "操作成功",
  "data": {
    "config": {
      "version": "1.0.0",
      "upload_max_size": 10485760,
      "allowed_extensions": ["jpg", "png", "gif"]
    }
  }
}
```

---

### 8.2 文件上传

**接口地址**: `/api/common/upload`  
**请求方式**: `POST`  
**是否需要登录**: 是

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| file | file | 是 | 文件 |

**返回示例**
```json
{
  "code": 0,
  "message": "上传成功",
  "data": {
    "url": "/uploads/20250122/abc123.jpg",
    "fullurl": "https://example.com/uploads/20250122/abc123.jpg"
  }
}
```

---

### 8.3 发送短信验证码

**接口地址**: `/api/sms/send`  
**请求方式**: `POST`  
**是否需要登录**: 否

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| mobile | string | 是 | 手机号 |
| event | string | 是 | 事件（register/login/resetpwd） |

**返回示例**
```json
{
  "code": 0,
  "message": "发送成功",
  "data": {}
}
```

---

### 8.4 检查Token

**接口地址**: `/api/token/check`  
**请求方式**: `POST`  
**是否需要登录**: 是

**返回示例**
```json
{
  "code": 0,
  "message": "Token有效",
  "data": {
    "valid": true
  }
}
```

---

### 8.5 刷新Token

**接口地址**: `/api/token/refresh`  
**请求方式**: `POST`  
**是否需要登录**: 是

**返回示例**
```json
{
  "code": 0,
  "message": "刷新成功",
  "data": {
    "token": "new_token_abc123..."
  }
}
```

---

## 附录

### A. 错误码完整列表

| 错误码 | 说明 |
|--------|------|
| 0 | 操作成功 |
| 1001 | 参数缺失 |
| 1002 | 参数格式错误 |
| 1003 | 参数值不合法 |
| 2001 | 未登录 |
| 2002 | 无权限操作 |
| 3001 | 当前状态不允许该操作 |
| 3002 | 操作过于频繁 |
| 4001 | 行为异常，已被限制 |
| 5001 | 系统异常，请稍后重试 |

### B. 业务状态枚举

**商户状态**
- pending: 待审核
- approved: 审核通过
- rejected: 审核拒绝
- disabled: 已禁用

**任务状态**
- pending: 待审核
- approved: 审核通过
- running: 进行中
- completed: 已完成
- rejected: 已拒绝
- cancelled: 已取消

**子任务状态**
- pending: 待派发
- assigned: 已派发
- accepted: 已接单
- paid: 已支付
- verified: 已验证
- completed: 已完成
- failed: 已失败
- cancelled: 已取消

**提现状态**
- pending: 待审核
- approved: 审核通过
- paid: 已打款
- rejected: 已拒绝

---

**文档版本**: v1.0  
**最后更新**: 2025-01-22  
**维护者**: 开发团队
