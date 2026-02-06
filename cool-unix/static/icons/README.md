# 图标文件说明

## 目录结构

```
static/icons/
├── README.md           # 本说明文件
├── tabbar/             # TabBar 图标（如需要）
│   ├── home.png
│   ├── home-active.png
│   ├── task.png
│   ├── task-active.png
│   ├── wallet.png
│   ├── wallet-active.png
│   ├── promo.png
│   ├── promo-active.png
│   ├── user.png
│   └── user-active.png
└── common/             # 通用图标（如需要）
    ├── logo.png
    └── placeholder.png
```

## 图标规范

### TabBar 图标
- **尺寸**: 81px × 81px（@3x）
- **格式**: PNG（支持透明背景）
- **命名**: `图标名称.png` 和 `图标名称-active.png`
- **颜色**: 
  - 未选中: #9aa0a6（灰色）
  - 选中: #0052d9（主色）

### 通用图标
- **尺寸**: 根据实际需求
- **格式**: PNG / SVG / WebP
- **命名**: 小写字母，使用连字符分隔

## 使用方式

### 在页面中使用

```vue
<template>
  <image 
    src="/static/icons/common/logo.png" 
    mode="aspectFit"
    style="width: 72px; height: 72px;"
  />
</template>
```

### 在 TabBar 中使用

在 `pages.json` 或 `uni.config.ts` 中配置：

```json
{
  "tabBar": {
    "list": [
      {
        "pagePath": "pages/index/index",
        "text": "首页",
        "iconPath": "static/icons/tabbar/home.png",
        "selectedIconPath": "static/icons/tabbar/home-active.png"
      }
    ]
  }
}
```

## 图标来源

- **Lucide Icons**: https://lucide.dev/
- **uni-icons**: https://ext.dcloud.net.cn/plugin?id=28
- **自定义设计**: 根据项目需求设计

## 注意事项

1. **文件大小**: 尽量控制在 10KB 以内，使用压缩工具优化
2. **命名规范**: 使用英文小写，避免使用中文和特殊字符
3. **版权问题**: 确保图标来源合法，避免侵权
4. **兼容性**: PNG 格式兼容性最好，建议优先使用
5. **备份**: 保留原始设计文件（.sketch / .figma / .ai）

## 图标导出工具

- **Figma**: File → Export → PNG
- **Sketch**: Make Exportable → PNG
- **Adobe Illustrator**: File → Export → Export for Screens
- **在线工具**: 
  - https://www.iconfont.cn/
  - https://www.flaticon.com/
  - https://iconify.design/

## 更新日志

- 2026-02-06: 创建图标目录和说明文件
