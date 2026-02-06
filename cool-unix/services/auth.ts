import { request } from "@/.cool/service";
import type { LoginForm, RegisterForm, CertificationForm, CertificationInfo } from "@/types/auth";

/**
 * 认证服务
 */

// 密码登录
export function loginByPassword(mobile: string, password: string): Promise<{ token: string; userInfo: any }> {
	return request({
		url: "/user/login",
		method: "POST",
		data: {
			mobile,
			password,
			type: "password"
		}
	});
}

// 短信验证码登录
export function loginBySms(mobile: string, code: string): Promise<{ token: string; userInfo: any }> {
	return request({
		url: "/user/mobilelogin",
		method: "POST",
		data: {
			phone: mobile,
			smsCode: code
		}
	});
}

// 微信登录
export function loginByWechat(code: string): Promise<{ token: string; userInfo: any }> {
	return request({
		url: "/user/wechatLogin",
		method: "POST",
		data: {
			code
		}
	});
}

// 注册
export function register(form: RegisterForm): Promise<{ token: string; userInfo: any }> {
	return request({
		url: "/user/register",
		method: "POST",
		data: form
	});
}

// 发送短信验证码
export function sendSmsCode(mobile: string, event: string = "register"): Promise<void> {
	return request({
		url: "/sms/send",
		method: "POST",
		data: {
			mobile,
			event
		}
	});
}

// 获取认证信息
export function getCertificationInfo(): Promise<CertificationInfo | null> {
	return request({
		url: "/user/certification/info",
		method: "GET"
	});
}

// 提交认证
export function submitCertification(form: CertificationForm): Promise<void> {
	return request({
		url: "/user/certification/submit",
		method: "POST",
		data: form
	});
}

// 获取认证状态
export function getCertificationStatus(): Promise<{ status: string; reject_reason?: string }> {
	return request({
		url: "/user/certification/status",
		method: "GET"
	});
}

// 获取图片验证码
export function getCaptcha(params: {
	color?: string;
	phone?: string;
	width?: number;
	height?: number;
}): Promise<{ captchaId: string; data: string }> {
	return request({
		url: "/app/user/login/captcha",
		method: "GET",
		data: params
	});
}

// 发送短信验证码（用于登录）
export function sendLoginSms(mobile: string): Promise<void> {
	return request({
		url: "/sms/send",
		method: "POST",
		data: {
			mobile,
			event: "mobilelogin"
		}
	});
}

// 微信小程序登录
export function loginByMiniApp(data: any): Promise<{ token: string; userInfo: any }> {
	return request({
		url: "/app/user/login/mini",
		method: "POST",
		data
	});
}
