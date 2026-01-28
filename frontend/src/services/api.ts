/**
 * API 基础服务
 */

import type { ApiResponse } from '@/types/common'
import { appConfig } from '@/config/env'

const API_BASE_URL = appConfig.apiBaseUrl

type RequestMethod = 'GET' | 'POST' | 'PUT' | 'DELETE'

interface RequestOptions {
  method?: RequestMethod
  data?: Record<string, any>
  headers?: Record<string, string>
}

/**
 * 发送 HTTP 请求
 */
export async function request<T = null>(
  url: string,
  options: RequestOptions = {}
): Promise<ApiResponse<T>> {
  const {
    method = 'GET',
    data = null,
    headers = {}
  } = options

  // 获取 token
  const token = uni.getStorageSync('token')
  const finalHeaders: Record<string, string> = {
    'Content-Type': 'application/json',
    ...headers
  }

  if (token) {
    finalHeaders['Authorization'] = `Bearer ${token}`
  }

  return new Promise((resolve, reject) => {
    uni.request({
      url: `${API_BASE_URL}${url}`,
      method: method as any,
      data,
      header: finalHeaders,
      success: (res: any) => {
        const response = res.data as ApiResponse<T>
        if (response.code === 0) {
          resolve(response)
        } else if (response.code === 2001) {
          // 未登录，清除 token 并跳转到登录页
          uni.removeStorageSync('token')
          uni.navigateTo({ url: '/pages/auth/login' })
          reject(new Error(response.message))
        } else {
          reject(new Error(response.message))
        }
      },
      fail: (err: any) => {
        reject(new Error('网络请求失败'))
      }
    })
  })
}

/**
 * GET 请求
 */
export function get<T = null>(url: string, headers?: Record<string, string>): Promise<ApiResponse<T>> {
  return request<T>(url, { method: 'GET', headers })
}

/**
 * POST 请求
 */
export function post<T = null>(
  url: string,
  data?: Record<string, any>,
  headers?: Record<string, string>
): Promise<ApiResponse<T>> {
  return request<T>(url, { method: 'POST', data, headers })
}

/**
 * PUT 请求
 */
export function put<T = null>(
  url: string,
  data?: Record<string, any>,
  headers?: Record<string, string>
): Promise<ApiResponse<T>> {
  return request<T>(url, { method: 'PUT', data, headers })
}

/**
 * DELETE 请求
 */
export function del<T = null>(url: string, headers?: Record<string, string>): Promise<ApiResponse<T>> {
  return request<T>(url, { method: 'DELETE', headers })
}
