# 商户互助平台 - 完整开发指南

## 项目概述

商户互助刷单平台前端项目，基于 uni-app x 框架开发，支持 H5、App 和微信小程序三个平台。

## 快速开始

### 第 1 步：安装依赖
在 `frontend` 目录下运行：
```bash
npm install
```

**重要提示：** 
- 在 HBuilderX 中开发 uni-app 项目时，不需要安装 `@dcloudio/uni-app` 等包
- HBuilderX 内置了完整的编译工具链，只需安装基础依赖（Vue、TypeScript 等）即可
- **不要使用 `npm run dev` 或 `npm run build` 命令**，这些命令在 uni-app 项目中无效

### 第 2 步：在 HBuilderX 中打开项目
1. 打开 HBuilderX
2. `文件` → `打开文件夹`
3. 选择 **`frontend` 文件夹**（不是项目根目录）
4. 点击打开
5. 等待 1-2 分钟让 HBuilderX 识别项目

### 第 3 步：运行项目（必须在 HBuilderX 中操作）
- **H5 版本**：`运行` → `运行到浏览器` → `Chrome`（或 `Ctrl+Shift+R`）
- **App 版本**：`运行` → `运行到手机或模拟器`
- **小程序版本**：`运行` → `运行到小程序模拟器` → `微信开发者工具`

**注意：** uni-app 项目必须通过 HBuilderX 的图形界面运行，不支持命令行运行。

## 项目结构

```
frontend/
├── src/
│   ├── pages/              # 30 个页面文件
│   │   ├── auth/           # 认证相关（3个）
│   │   ├── index/          # 首页（1个）
│   │   ├── merchant/       # 商户模块（4个）
│   │   ├── task/           # 任务模块（9个）
│   │   ├── wallet/         # 钱包模块（4个）
│   │   ├── promo/          # 推广模块（8个）
│   │   └── message/        # 消息模块（1个）
│   ├── services/           # API 服务层
│   ├── types/              # TypeScript 类型定义
│   ├── utils/              # 工具函数
│   ├── config/             # 配置文件
│   ├── App.uvue            # 应用入口
│   └── main.ts             # 主文件
├── .hbuilderx              # HBuilderX 配置
├── manifest.json           # 应用清单
├── package.json            # 项目依赖
├── uni.config.ts           # uni-app 配置
├── vite.config.ts          # Vite 配置
└── tsconfig.json           # TypeScript 配置
```

## 核心配置文件说明

| 文件 | 说明 |
|------|------|
| `pages.json` | **必需** - HBuilderX 编译入口，定义页面路由、窗口样式、tabBar |
| `uni.config.ts` | uni-app 主配置，定义页面路由、窗口样式、tabBar |
| `manifest.json` | 应用清单，定义各平台配置 |
| `vite.config.ts` | Vite 构建配置 |
| `package.json` | 项目依赖和脚本命令 |
| `.hbuilderx` | HBuilderX 项目类型识别配置 |

**重要提示：** `pages.json` 是 HBuilderX 编译的必需文件，即使使用了 `uni.config.ts`，也必须保留 `pages.json`。

## 开发规范

### UTS 规范
- 强类型，所有变量必须声明类型
- 先定义后使用
- 不使用 `undefined`，使用 `null`
- 用 `type` 定义对象类型，不用 `interface`
- 可空类型使用 `| null` 或 `?`

### UVUE 规范
- 仅使用 Vue3 组合式 API
- 不使用 Pinia/Vuex
- 组件使用 easycom 规范
- 页面参数通过 props 接收

### 样式规范
- 仅使用 flex 布局
- 文字样式只能加在 `<text>` 上
- 单位仅使用 px/rpx/%
- 使用 TailwindCSS 类名

### 导航规范
- 使用 `uni.navigateTo()` 进行页面导航
- 使用 `uni.navigateBack()` 返回上一页
- 使用 `uni.reLaunch()` 重新启动应用

## 开发工作流

### 开发阶段（必须在 HBuilderX 中操作）
1. 在 HBuilderX 中打开项目
2. 点击 `运行` 菜单选择目标平台
3. 修改代码
4. 保存文件（Ctrl+S）
5. HBuilderX 会自动热更新

### 构建阶段（必须在 HBuilderX 中操作）
1. 在 HBuilderX 中打开项目
2. 点击 `发行` 菜单
3. 选择目标平台：
   - `发行` → `网站-H5手机版`
   - `发行` → `原生App-云打包`
   - `发行` → `小程序-微信`

**重要：** uni-app 项目的运行和构建都必须通过 HBuilderX 完成，不支持命令行操作。

## 常见问题排查

### 运行 npm run dev 报错 'uni' 不是内部或外部命令
**原因：** uni-app 项目不支持通过命令行运行

**解决方案：**
- 不要使用 `npm run dev`、`npm run build` 等命令
- 必须在 HBuilderX 中通过图形界面运行项目
- 打开 HBuilderX → 打开 `frontend` 文件夹 → 点击 `运行` 菜单

### npm install 失败
**原因：** 尝试安装不存在的 uni-app 包版本

**解决方案：**
1. 确保 `package.json` 中只包含基础依赖（Vue、TypeScript）
2. 不要尝试安装 `@dcloudio/uni-app` 等包，HBuilderX 内置了这些工具
3. 运行以下命令清除缓存后重试：
```bash
npm cache clean --force
npm install
```

### HBuilderX 无法识别项目
1. **重启 HBuilderX** - 完全关闭后重新打开
2. **检查 Node.js 版本** - `node --version`（需要 ≥ 16）
3. **检查 HBuilderX 版本** - `帮助` → `关于 HBuilderX`（需要 ≥ 3.8.0）
4. **清除缓存** - 删除 `node_modules` 后重新 `npm install`
5. **确保 pages.json 存在** - `pages.json` 是 HBuilderX 编译的必需文件
6. **检查 .hbuilderx 配置** - 确保 `.hbuilderx` 文件存在且配置正确

### 运行时出现错误
1. 确保依赖已安装：`npm install`
2. 确保 `pages.json` 文件存在且格式正确
3. 确保 `uni.config.ts` 文件存在且格式正确
4. 确保 `src/pages/` 目录下有页面文件
5. 确保 `static/icons/` 目录下有 tabBar 图标文件
6. 查看 HBuilderX 的日志：`视图` → `显示日志`

### HBuilderX 无法编译到支持平台
**原因：** 缺少 `pages.json` 文件或配置不完整

**解决方案：**
1. 确保 `frontend/pages.json` 文件存在
2. 确保所有页面路径在 `pages.json` 中都有定义
3. 确保 `static/icons/` 目录下有所有 tabBar 图标
4. 删除 `node_modules` 和 `.hbuilderx` 缓存目录
5. 重新运行 `npm install`
6. 重启 HBuilderX
7. 再次尝试运行项目

### 如何修改 API 地址
修改 `frontend/.env` 文件中的 `VITE_APP_API_URL` 变量

### 如何添加新页面
1. 在 `src/pages/` 中创建新的 `.uvue` 文件
2. 在 `pages.json` 的 `pages` 数组中添加页面配置
3. 在 `uni.config.ts` 的 `appConfig.pages` 数组中添加页面路径
4. 在需要的地方使用 `uni.navigateTo()` 进行导航

### 如何调试
- H5 版本：使用浏览器开发者工具（F12）
- App 版本：使用 HBuilderX 的调试工具
- 小程序版本：使用微信开发者工具

## 页面模块说明

### 认证模块 (3 个页面)
- `pages/auth/login.uvue` - 登录
- `pages/auth/register.uvue` - 注册
- `pages/auth/certification.uvue` - 实名认证

### 任务模块 (9 个页面)
- `pages/task/index.uvue` - 任务列表
- `pages/task/create.uvue` - 发起任务
- `pages/task/detail.uvue` - 任务详情
- `pages/task/my-tasks.uvue` - 我的任务
- `pages/task/deposit.uvue` - 保证金管理
- `pages/task/subtask/list.uvue` - 子任务列表
- `pages/task/subtask/my.uvue` - 我的子任务
- `pages/task/subtask/detail.uvue` - 子任务详情
- `pages/task/subtask/upload.uvue` - 上传凭证

### 钱包模块 (4 个页面)
- `pages/wallet/index.uvue` - 钱包首页
- `pages/wallet/recharge.uvue` - 充值
- `pages/wallet/withdraw.uvue` - 提现
- `pages/wallet/logs.uvue` - 交易记录

### 推广模块 (8 个页面)
- `pages/promo/index.uvue` - 推广中心
- `pages/promo/level.uvue` - 等级体系
- `pages/promo/invite.uvue` - 邀请好友
- `pages/promo/team.uvue` - 我的团队
- `pages/promo/commission.uvue` - 佣金记录
- `pages/promo/performance.uvue` - 业绩统计
- `pages/promo/bonus.uvue` - 分红记录
- `pages/promo/wallet.uvue` - 推广钱包

### 商户模块 (4 个页面)
- `pages/merchant/index.uvue` - 我的页面
- `pages/merchant/register.uvue` - 商户入驻
- `pages/merchant/audit-status.uvue` - 审核状态
- `pages/merchant/info.uvue` - 商户信息

### 其他模块
- `pages/index/index.uvue` - 首页
- `pages/message/index.uvue` - 消息中心

## 相关文档

- [uni-app 官方文档](https://uniapp.dcloud.net.cn/)
- [HBuilderX 官方文档](https://hx.dcloud.net.cn/)
- [Vue 3 文档](https://vuejs.org/)
- [TailwindCSS 文档](https://tailwindcss.com/)
