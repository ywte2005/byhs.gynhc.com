import { storage } from "../utils";
import { router } from "./index";
import { PAGES } from "../ctx";

/**
 * 调试函数：打印所有页面的meta信息
 */
export function debugPages() {
	// Debug function - logs disabled in production
}

/**
 * 检查页面是否需要登录
 * @param path 页面路径
 * @returns 是否需要登录
 */
export function checkPageAuth(path: string): boolean {
	// 清理路径（移除query参数）
	const cleanPath = path.split('?')[0];
	
	// 确保路径以/开头
	const fullPath = cleanPath.startsWith('/') ? cleanPath : '/' + cleanPath;
	
	const page = PAGES.find((e) => e.path === fullPath);
	const needAuth = page?.meta?.isAuth === true;
	
		
	return needAuth;
}

/**
 * 检查当前是否已登录
 * @returns 是否已登录
 */
export function isLoggedIn(): boolean {
	const token = storage.get("token");
	const hasToken = token && token !== "" && token !== "null";
	
	if (!hasToken) {
		return false;
	}
	
	// 检查token是否过期
	if (storage.isExpired("token")) {
		return false;
	}
	
	return true;
}

/**
 * 强制跳转到登录页
 * @param redirectPath 登录后要跳转的页面
 */
export function forceLogin(redirectPath?: string) {
	if (redirectPath) {
		storage.set("redirect_after_login", redirectPath, 0);
	}
	
	uni.reLaunch({
		url: "/pages/user/login"
	});
}

/**
 * 路由守卫 - 使用uni-app拦截器实现
 */
export function setupRouterGuard() {
	// 调试：打印PAGES数组
	debugPages();
	
	// 检查应用启动时的登录状态
	// 如果首页需要登录但用户未登录，直接跳转到登录页
	const homePage = PAGES[0];
	if (homePage && homePage.meta?.isAuth === true) {
		if (!isLoggedIn()) {
						// 延迟执行，确保应用已完全启动
			setTimeout(() => {
				forceLogin(homePage.path);
			}, 100);
		}
	}
	
	// 拦截 navigateTo
	uni.addInterceptor('navigateTo', {
		invoke(args) {
			const url = args.url;
			const path = url.split('?')[0];
			
						
			// 检查是否需要登录
			if (checkPageAuth(path)) {
				// 检查是否已登录
				if (!isLoggedIn()) {
										
					// 保存目标页面
					storage.set("redirect_after_login", url, 0);
					
					// 跳转到登录页
					forceLogin();
					
					// 阻止原跳转
					return false;
				} else {
									}
			} else {
							}
			
			return true;
		}
	});
	
	// 拦截 redirectTo
	uni.addInterceptor('redirectTo', {
		invoke(args) {
			const url = args.url;
			const path = url.split('?')[0];
			
						
			if (checkPageAuth(path)) {
				if (!isLoggedIn()) {
										storage.set("redirect_after_login", url, 0);
					forceLogin();
					return false;
				}
			}
			
			return true;
		}
	});
	
	// 拦截 reLaunch
	uni.addInterceptor('reLaunch', {
		invoke(args) {
			const url = args.url;
			const path = url.split('?')[0];
			
						
			// 如果是跳转到登录页，直接放行
			if (path.includes('/login')) {
				return true;
			}
			
			if (checkPageAuth(path)) {
				if (!isLoggedIn()) {
										storage.set("redirect_after_login", url, 0);
					forceLogin();
					return false;
				}
			}
			
			return true;
		}
	});
	
	// 拦截 switchTab
	uni.addInterceptor('switchTab', {
		invoke(args) {
			const url = args.url;
			const path = url.split('?')[0];
			
						
			if (checkPageAuth(path)) {
				if (!isLoggedIn()) {
										storage.set("redirect_after_login", url, 0);
					forceLogin();
					return false;
				}
			}
			
			return true;
		}
	});
	
	// 保留原有的beforeEach钩子（用于router.push）
	router.beforeEach((to, from, next) => {
		const { meta, path } = to;
		
				
		const isAuth = meta?.isAuth === true;
		
		if (!isAuth) {
						next();
			return;
		}
		
		const token = storage.get("token");
		const hasToken = token && token !== "" && token !== "null";
		
		if (!hasToken) {
						storage.set("redirect_after_login", path, 0);
			forceLogin();
			return;
		}
		
		if (storage.isExpired("token")) {
						storage.remove("token");
			storage.remove("userInfo");
			storage.set("redirect_after_login", path, 0);
			forceLogin();
			return;
		}
		
				next();
	});
	
	// 注册登录后回调
	router.afterLogin(() => {
		const redirectPath = storage.get("redirect_after_login") as string | null;
		
		if (redirectPath) {
						storage.remove("redirect_after_login");
			
			uni.reLaunch({
				url: redirectPath
			});
		} else {
						router.home();
		}
	});
	
	}
