/**
 * 平台工具函数
 */

import { getPlatform } from '@/config/platform'
import { platformAdapter } from '@/components/PlatformAdapter'

/**
 * 显示提示信息（平台适配）
 */
export function showToast(options: {
  title: string
  icon?: 'success' | 'error' | 'loading' | 'none'
  duration?: number
}): void {
  const platform = getPlatform()

  if (platform === 'h5') {
    // H5 使用 uni.showToast
    uni.showToast({
      title: options.title,
      icon: options.icon || 'none',
      duration: options.duration || 2000
    })
  } else if (platform === 'app' || platform === 'weixin') {
    // App 和小程序使用 uni.showToast
    uni.showToast({
      title: options.title,
      icon: options.icon || 'none',
      duration: options.duration || 2000
    })
  }
}

/**
 * 显示加载中（平台适配）
 */
export function showLoading(title: string = '加载中...'): void {
  uni.showLoading({
    title,
    mask: true
  })
}

/**
 * 隐藏加载中
 */
export function hideLoading(): void {
  uni.hideLoading()
}

/**
 * 显示模态框（平台适配）
 */
export function showModal(options: {
  title: string
  content: string
  confirmText?: string
  cancelText?: string
}): Promise<boolean> {
  return new Promise((resolve) => {
    uni.showModal({
      title: options.title,
      content: options.content,
      confirmText: options.confirmText || '确定',
      cancelText: options.cancelText || '取消',
      success: (res: any) => {
        resolve(res.confirm)
      }
    })
  })
}

/**
 * 复制到剪贴板（平台适配）
 */
export function copyToClipboard(text: string): Promise<void> {
  return new Promise((resolve, reject) => {
    uni.setClipboardData({
      data: text,
      success: () => {
        showToast({ title: '已复制到剪贴板', icon: 'success' })
        resolve()
      },
      fail: (err: any) => {
        reject(err)
      }
    })
  })
}

/**
 * 分享（平台适配）
 */
export function share(options: {
  title: string
  content: string
  href: string
}): Promise<void> {
  return new Promise((resolve, reject) => {
    platformAdapter.handleShare(options)
    resolve()
  })
}

/**
 * 支付（平台适配）
 */
export function pay(options: any): Promise<void> {
  return new Promise((resolve, reject) => {
    platformAdapter.handlePay({
      ...options,
      success: () => resolve(),
      fail: (err: any) => reject(err)
    })
  })
}

/**
 * 扫码（平台适配）
 */
export function scanCode(): Promise<string> {
  return platformAdapter.handleScan()
}

/**
 * 选择图片（平台适配）
 */
export function chooseImage(count: number = 1): Promise<string[]> {
  return platformAdapter.handleChooseImage(count)
}

/**
 * 上传文件（平台适配）
 */
export function uploadFile(filePath: string, url: string, name: string = 'file'): Promise<any> {
  return platformAdapter.handleUploadFile(filePath, url, name)
}

/**
 * 登录（平台适配）
 */
export function login(): Promise<string> {
  return platformAdapter.handleLogin()
}

/**
 * 获取系统信息（平台适配）
 */
export function getSystemInfo(): any {
  return platformAdapter.getSystemInfo()
}

/**
 * 获取导航栏高度
 */
export function getNavBarHeight(): number {
  return platformAdapter.getNavBarHeight()
}

/**
 * 获取底部安全距离
 */
export function getBottomSafeArea(): number {
  return platformAdapter.getBottomSafeArea()
}

/**
 * 获取平台特定的样式
 */
export function getPlatformStyles(): Record<string, any> {
  return platformAdapter.getPlatformStyles()
}

/**
 * 检查功能是否支持
 */
export function isFeatureSupported(feature: string): boolean {
  return platformAdapter.isFeatureSupported(feature)
}

/**
 * 检查是否为特定平台
 */
export function isPlatform(platform: string): boolean {
  return platformAdapter.isPlatform(platform)
}

/**
 * 检查是否为移动平台
 */
export function isMobilePlatform(): boolean {
  return platformAdapter.isMobilePlatform()
}

/**
 * 检查是否为 H5 平台
 */
export function isH5Platform(): boolean {
  return platformAdapter.isH5Platform()
}

/**
 * 获取平台名称
 */
export function getPlatformName(): string {
  const platform = getPlatform()
  const names: Record<string, string> = {
    h5: 'H5',
    app: 'App',
    weixin: '微信小程序'
  }
  return names[platform] || 'Unknown'
}

/**
 * 获取平台特定的 CSS 类
 */
export function getPlatformClass(): string {
  return platformAdapter.getPlatformClass()
}
