# HBuilderX 运行问题排查

## 当前问题

```
Error: Cannot find module '@cool-vue/unix'
```

## 已尝试的解决方案

1. ✅ 重新安装依赖 `npm install`
2. ✅ 验证包已安装 `node_modules/@cool-vue/unix` 存在
3. ✅ 修复 tsconfig.json（移除 extends）
4. ✅ 修复 vite.config.ts（使用 path 而不是 node:path）

## 可能的原因

HBuilderX 使用的 Node.js 环境可能与系统环境不同，导致无法找到已安装的包。

## 解决方案

### 方案一：在 HBuilderX 中重新安装依赖

1. 在 HBuilderX 中打开项目
2. 右键点击项目根目录
3. 选择"使用命令行窗口打开所在目录"
4. 在打开的命令行中执行：
   ```bash
   npm install
   ```

### 方案二：检查 HBuilderX 的 Node.js 配置

1. 打开 HBuilderX
2. 工具 → 设置 → 运行配置
3. 检查 Node.js 路径是否正确
4. 如果路径不对，修改为系统 Node.js 路径

### 方案三：使用内置终端安装

1. 在 HBuilderX 中打开项目
2. 视图 → 显示控制台
3. 在控制台中执行：
   ```bash
   cd backend/cool-unix
   npm install
   ```

### 方案四：清除 HBuilderX 缓存

1. 关闭 HBuilderX
2. 删除以下目录：
   - `C:\Users\[用户名]\.hbuilderx`
   - 项目中的 `.hbuilderx` 目录
3. 重新打开 HBuilderX
4. 重新打开项目

### 方案五：手动配置模块路径

如果以上方案都不行，可以尝试修改 vite.config.ts，添加 resolve.alias：

```typescript
import { defineConfig } from "vite";
import { resolve } from "path";

export default defineConfig({
  resolve: {
    alias: {
      '@cool-vue/unix': resolve(__dirname, 'node_modules/@cool-vue/unix')
    }
  },
  // ... 其他配置
});
```

## 临时解决方案：简化配置

如果急需运行项目，可以暂时注释掉 cool 插件：

### 修改 vite.config.ts

```typescript
import { defineConfig } from "vite";
// import { cool } from "@cool-vue/unix";
import { proxy } from "./config/proxy";
import tailwindcss from "tailwindcss";
import { join } from "path";
import uni from "@dcloudio/vite-plugin-uni";

const resolve = (dir: string) => join(__dirname, dir);

const proxyConfig: Record<string, any> = {};
for (const i in proxy) {
	proxyConfig[`/${i}/`] = proxy[i];
}

export default defineConfig({
	plugins: [
		uni(),
		// 暂时注释掉 cool 插件
		// cool({
		// 	proxy: proxyConfig
		// })
	],

	server: {
		port: 9900,
		proxy: proxyConfig
	},

	css: {
		postcss: {
			plugins: [tailwindcss({ config: resolve("./tailwind.config.ts") })]
		}
	}
});
```

**注意：** 注释掉 cool 插件后，部分 Cool UI 的功能可能无法使用，但基本的页面应该可以运行。

## 验证步骤

运行成功后，应该能看到：

1. ✅ 编译成功，没有错误
2. ✅ 浏览器自动打开 `http://localhost:9900`
3. ✅ 页面正常显示
4. ✅ 可以访问登录页面

## 如果还是无法运行

请提供以下信息：

1. HBuilderX 版本号
2. Node.js 版本（在 HBuilderX 终端中执行 `node -v`）
3. npm 版本（在 HBuilderX 终端中执行 `npm -v`）
4. 完整的错误日志

## 联系支持

如果以上方案都无法解决，可能需要：
1. 更新 HBuilderX 到最新版本
2. 重新安装 HBuilderX
3. 使用其他开发工具（如 VS Code + Vite）
