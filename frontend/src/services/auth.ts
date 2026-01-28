/**
 * 认证服务
 */

import { post, get } from './api'
import type { ApiResponse, User } from '@/types/common'
import type { AuthForm, MerchantAuditStatus } from '@/types/merchant'

// 登录
export function login(phone: string, password: string): Promise<ApiResponse<{ token: string; user: User }>> {
  return post('/api/auth/login', { phone, password })
}

// 微信登录
export function wechatLogin(code: string): Promise<ApiResponse<{ token: string; user: User }>> {
  return post('/api/auth/wechat-login', { code })
}

// 注册
export function register(phone: string, password: string, invite_code?: string): Promise<ApiResponse<{ token: string; user: User }>> {
  return post('/api/auth/register', { phone, password, invite_code })
}

// 获取用户信息
export function getUserInfo(): Promise<ApiResponse<User>> {
  return get('/api/user/info')
}

// 提交认证
export function submitAuth(form: AuthForm): Promise<ApiResponse<null>> {
  return post('/api/merchant/auth', form)
}

// 获取认证状态
export function getAuthStatus(): Promise<ApiResponse<MerchantAuditStatus>> {
  return get('/api/merchant/audit-status')
}

// 登出
export function logout(): Promise<ApiResponse<null>> {
  return post('/api/auth/logout')
}
