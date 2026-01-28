# 🚀 快速开始指南

## 重要提示

**uni-app x 必须在 HBuilderX 中开发**，不能使用 npm 命令行工具。

## 第一步：安装 HBuilderX

1. 访问 [HBuilderX 官方下载页面](https://www.dcloud.io/hbuilderx.html)
2. 下载适合你系统的版本
3. 按照安装向导完成安装

## 第二步：在 HBuilderX 中打开项目

1. 打开 HBuilderX
2. 菜单 → 文件 → 打开文件夹
3. 选择 `frontend` 文件夹
4. 点击打开

## 第三步：运行项目

### 运行到浏览器（H5）

1. 右键项目 → 运行 → 运行到浏览器
2. 或按快捷键 `Ctrl+R`（Windows）/ `Cmd+R`（Mac）
3. 浏览器会自动打开预览

### 运行到 Android App

1. 连接 Android 真机或启动模拟器
2. 右键项目 → 运行 → 运行到 Android App
3. 选择目标设备
4. 等待编译和安装完成

### 运行到 iOS App

1. 连接 iOS 真机或启动模拟器（需要 Mac）
2. 右键项目 → 运行 → 运行到 iOS App
3. 选择目标设备
4. 等待编译和安装完成

### 运行到微信小程序

1. 下载 [微信开发者工具](https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html)
2. 右键项目 → 运行 → 运行到微信开发者工具
3. 微信开发者工具会自动打开

## 常用操作

### 刷新预览

- 按 F5 刷新浏览器
- 或在 HBuilderX 中按 `Ctrl+Shift+R` 重新运行

### 调试

- 按 F12 打开浏览器开发者工具
- 查看 Console 标签查看日志
- 在代码中设置断点进行调试

### 构建发行

#### 构建 H5

1. 右键项目 → 发行 → 网站-H5 手机版
2. 选择输出目录
3. 点击发行

#### 构建 App

1. 右键项目 → 发行 → App-云打包
2. 选择平台（Android / iOS）
3. 点击云打包

#### 构建小程序

1. 右键项目 → 发行 → 小程序-微信
2. 点击发行

## 项目结构

```
frontend/
├── src/
│   ├── pages/              # 页面组件
│   ├── services/           # API 服务
│   ├── types/              # 类型定义
│   ├── config/             # 配置文件
│   ├── utils/              # 工具函数
│   ├── components/         # 组件
│   ├── App.uvue            # 根组件
│   └── main.ts             # 入口文件
├── static/                 # 静态资源
├── uni.config.ts           # uni-app 配置
├── package.json            # 项目依赖
├── tsconfig.json           # TypeScript 配置
└── README.md               # 项目说明
```

## 开发规范

### 语言
- 所有代码注释和文档使用中文

### 前端框架
- 使用 Vue3 组合式 API
- 使用 TypeScript 进行类型检查
- 不使用 Pinia/Vuex

### 样式
- 仅使用 flex 布局
- 使用 TailwindCSS 类名
- 单位仅使用 px/rpx/%

### 页面组件
- 页面使用 `<cl-page>` 包裹
- 底部操作区使用 `<cl-footer>`

详见 `frontend/DEVELOPMENT.md`

## 支持的平台

- ✅ H5（Web）
- ✅ App（iOS/Android）
- ✅ 微信小程序

详见 `frontend/PLATFORM_GUIDE.md`

## 获取帮助

| 文档 | 用途 |
|------|------|
| `frontend/HBUILDERX_GUIDE.md` | HBuilderX 使用指南 |
| `frontend/QUICK_FIX.md` | 快速参考和常用命令 |
| `frontend/TROUBLESHOOTING.md` | 详细的问题解决方案 |
| `frontend/SETUP.md` | 完整的安装和运行指南 |
| `frontend/DEVELOPMENT.md` | 开发规范和最佳实践 |
| `frontend/PLATFORM_GUIDE.md` | 平台适配指南 |
| `frontend/README.md` | 项目说明 |

## 下一步

1. ✅ 安装 HBuilderX
2. ✅ 在 HBuilderX 中打开 `frontend` 文件夹
3. ✅ 按 `Ctrl+R` 运行到浏览器
4. ✅ 开始开发！

---

**最后更新**: 2026-01-28  
**版本**: 1.0.0
