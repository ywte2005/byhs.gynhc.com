/**
 * 平台适配器 - 处理不同平台的差异
 */

import { getPlatform, getPlatformFeatures } from '@/config/platform'

/**
 * 平台适配基类
 */
export class PlatformAdapter {
  protected platform: string
  protected features: any

  constructor() {
    this.platform = getPlatform()
    this.features = getPlatformFeatures()
  }

  /**
   * 检查功能是否支持
   */
  isFeatureSupported(feature: string): boolean {
    return this.features[feature] || false
  }

  /**
   * 获取平台特定的样式类
   */
  getPlatformClass(): string {
    return `platform-${this.platform}`
  }

  /**
   * 获取平台特定的样式变量
   */
  getPlatformStyles(): Record<string, any> {
    const styles: Record<string, any> = {}

    if (this.platform === 'weixin') {
      // 微信小程序特定样式
      styles.statusBarHeight = uni.getSystemInfoSync().statusBarHeight
      styles.safeAreaInsets = uni.getSystemInfoSync().safeAreaInsets
    } else if (this.platform === 'app') {
      // App 特定样式
      styles.statusBarHeight = uni.getSystemInfoSync().statusBarHeight
      styles.safeAreaInsets = uni.getSystemInfoSync().safeAreaInsets
    } else {
      // H5 特定样式
      styles.statusBarHeight = 0
      styles.safeAreaInsets = { top: 0, bottom: 0, left: 0, right: 0 }
    }

    return styles
  }

  /**
   * 获取平台特定的导航栏高度
   */
  getNavBarHeight(): number {
    const systemInfo = uni.getSystemInfoSync()
    
    if (this.platform === 'weixin') {
      // 微信小程序导航栏高度
      return 44 + (systemInfo.statusBarHeight || 0)
    } else if (this.platform === 'app') {
      // App 导航栏高度
      return 44 + (systemInfo.statusBarHeight || 0)
    } else {
      // H5 导航栏高度
      return 44
    }
  }

  /**
   * 获取平台特定的底部安全距离
   */
  getBottomSafeArea(): number {
    const systemInfo = uni.getSystemInfoSync()
    
    if (this.platform === 'weixin' || this.platform === 'app') {
      return systemInfo.safeAreaInsets?.bottom || 0
    }
    
    return 0
  }

  /**
   * 处理平台特定的返回
   */
  handleBack(): void {
    if (this.platform === 'weixin') {
      // 微信小程序返回
      uni.navigateBack()
    } else if (this.platform === 'app') {
      // App 返回
      uni.navigateBack()
    } else {
      // H5 返回
      uni.navigateBack()
    }
  }

  /**
   * 处理平台特定的分享
   */
  handleShare(data: any): void {
    if (!this.isFeatureSupported('supportShare')) {
      uni.showToast({ title: '当前平台不支持分享', icon: 'none' })
      return
    }

    if (this.platform === 'weixin') {
      // 微信小程序分享
      uni.share({
        provider: 'weixin',
        scene: 'WXSceneSession',
        type: 1,
        title: data.title,
        content: data.content,
        href: data.href
      })
    } else if (this.platform === 'app') {
      // App 分享
      uni.share({
        provider: 'weixin',
        scene: 'WXSceneSession',
        type: 1,
        title: data.title,
        content: data.content,
        href: data.href
      })
    }
  }

  /**
   * 处理平台特定的支付
   */
  handlePay(data: any): void {
    if (this.platform === 'weixin' || this.platform === 'app') {
      // 微信支付
      uni.requestPayment({
        provider: 'weixin',
        timeStamp: data.timeStamp,
        nonceStr: data.nonceStr,
        package: data.package,
        signType: data.signType,
        paySign: data.paySign,
        success: data.success,
        fail: data.fail
      })
    } else {
      // H5 支付
      window.location.href = data.payUrl
    }
  }

  /**
   * 处理平台特定的扫码
   */
  handleScan(): Promise<string> {
    return new Promise((resolve, reject) => {
      if (!this.isFeatureSupported('supportQRCode')) {
        reject(new Error('当前平台不支持扫码'))
        return
      }

      uni.scanCode({
        success: (res: any) => {
          resolve(res.result)
        },
        fail: (err: any) => {
          reject(err)
        }
      })
    })
  }

  /**
   * 处理平台特定的图片选择
   */
  handleChooseImage(count: number = 1): Promise<string[]> {
    return new Promise((resolve, reject) => {
      uni.chooseImage({
        count,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: (res: any) => {
          resolve(res.tempFilePaths)
        },
        fail: (err: any) => {
          reject(err)
        }
      })
    })
  }

  /**
   * 处理平台特定的文件上传
   */
  handleUploadFile(filePath: string, url: string, name: string = 'file'): Promise<any> {
    return new Promise((resolve, reject) => {
      uni.uploadFile({
        url,
        filePath,
        name,
        success: (res: any) => {
          resolve(JSON.parse(res.data))
        },
        fail: (err: any) => {
          reject(err)
        }
      })
    })
  }

  /**
   * 处理平台特定的登录
   */
  handleLogin(): Promise<string> {
    return new Promise((resolve, reject) => {
      uni.login({
        provider: 'weixin',
        success: (res: any) => {
          resolve(res.code)
        },
        fail: (err: any) => {
          reject(err)
        }
      })
    })
  }

  /**
   * 获取平台特定的系统信息
   */
  getSystemInfo(): any {
    return uni.getSystemInfoSync()
  }

  /**
   * 检查是否为特定平台
   */
  isPlatform(platform: string): boolean {
    return this.platform === platform
  }

  /**
   * 检查是否为移动平台（App 或小程序）
   */
  isMobilePlatform(): boolean {
    return this.platform === 'app' || this.platform === 'weixin'
  }

  /**
   * 检查是否为 H5 平台
   */
  isH5Platform(): boolean {
    return this.platform === 'h5'
  }
}

// 导出单例
export const platformAdapter = new PlatformAdapter()
