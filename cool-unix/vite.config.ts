import { defineConfig } from "vite";
import { cool } from "@cool-vue/unix";
import { proxy } from "./config/proxy";
import tailwindcss from "tailwindcss";
import { join } from "path";
import uni from "@dcloudio/vite-plugin-uni";

const resolve = (dir: string) => join(__dirname, dir);

// 处理代理配置
const proxyConfig: Record<string, any> = {};
for (const i in proxy) {
	proxyConfig[`/${i}/`] = proxy[i];
}

export default defineConfig({
	plugins: [
		uni(),
		cool({
			proxy: proxyConfig
		})
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
