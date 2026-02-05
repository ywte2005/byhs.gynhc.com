export const proxy = {
	// 开发环境配置
	dev: {
		// 本地后端地址
		target: "https://byhs.gynhc.com",
		changeOrigin: true,
		rewrite: (path: string) => path.replace("/dev", "/api")
	},

	// 生产环境配置
	prod: {
		// 生产环境地址（需要根据实际情况修改）
		target: "https://byhs.gynhc.com",
		changeOrigin: true,
		rewrite: (path: string) => path.replace("/prod", "/api")
	}
};

export const value = "dev";
