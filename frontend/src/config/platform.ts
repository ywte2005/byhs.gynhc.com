/**
 * 平台配置
 */

// 获取当前平台
export function getPlatform(): string {
  // #ifdef H5
  return 'h5'
  // #endif

  // #ifdef APP-PLUS
  return 'app'
  // #endif

  // #ifdef MP-WEIXIN
  return 'weixin'
  // #endif

  return 'unknown'
}

// 平台特定功能检查
export const platformFeatures = {
  // H5 特定功能
  h5: {
    supportShare: false,
    supportQRCode: true,
    supportNativeAPI: false,
    supportPayment: true
  },
  
  // App 特定功能
  app: {
    supportShare: true,
    supportQRCode: true,
    supportNativeAPI: true,
    supportPayment: true
  },
  
  // 微信小程序特定功能
  weixin: {
    supportShare: true,
    supportQRCode: true,
    supportNativeAPI: false,
    supportPayment: true
  }
}

// 获取当前平台的功能支持
export function getPlatformFeatures() {
  const platform = getPlatform()
  return platformFeatures[platform as keyof typeof platformFeatures] || platformFeatures.h5
}

// 平台特定的 API 调用
export function callPlatformAPI(apiName: string, params?: any): Promise<any> {
  const platform = getPlatform()
  
  switch (platform) {
    case 'app':
      return callAppAPI(apiName, params)
    case 'weixin':
      return callWechatAPI(apiName, params)
    default:
      return callH5API(apiName, params)
  }
}

// H5 平台 API
function callH5API(apiName: string, params?: any): Promise<any> {
  return new Promise((resolve, reject) => {
    // H5 特定的 API 实现
    console.log(`H5 API: ${apiName}`, params)
    resolve({ platform: 'h5', apiName, params })
  })
}

// App 平台 API
function callAppAPI(apiName: string, params?: any): Promise<any> {
  return new Promise((resolve, reject) => {
    // App 特定的 API 实现
    console.log(`App API: ${apiName}`, params)
    resolve({ platform: 'app', apiName, params })
  })
}

// 微信小程序 API
function callWechatAPI(apiName: string, params?: any): Promise<any> {
  return new Promise((resolve, reject) => {
    // 微信小程序特定的 API 实现
    console.log(`WeChat API: ${apiName}`, params)
    resolve({ platform: 'weixin', apiName, params })
  })
}

// 平台特定的导航
export function navigateTo(url: string, options?: any): void {
  const platform = getPlatform()
  
  if (platform === 'weixin') {
    // 微信小程序导航
    uni.navigateTo({
      url,
      ...options
    })
  } else if (platform === 'app') {
    // App 导航
    uni.navigateTo({
      url,
      ...options
    })
  } else {
    // H5 导航
    uni.navigateTo({
      url,
      ...options
    })
  }
}

// 平台特定的分享
export function share(options: any): void {
  const platform = getPlatform()
  const features = getPlatformFeatures()
  
  if (!features.supportShare) {
    uni.showToast({ title: '当前平台不支持分享', icon: 'none' })
    return
  }
  
  if (platform === 'weixin') {
    // 微信小程序分享
    uni.share({
      provider: 'weixin',
      scene: 'WXSceneSession',
      type: 1,
      title: options.title,
      content: options.content,
      href: options.href,
      success: options.success,
      fail: options.fail
    })
  } else if (platform === 'app') {
    // App 分享
    uni.share({
      provider: 'weixin',
      scene: 'WXSceneSession',
      type: 1,
      title: options.title,
      content: options.content,
      href: options.href,
      success: options.success,
      fail: options.fail
    })
  } else {
    // H5 分享
    uni.showToast({ title: '请使用浏览器分享功能', icon: 'none' })
  }
}

// 平台特定的支付
export function pay(options: any): void {
  const platform = getPlatform()
  
  if (platform === 'weixin') {
    // 微信小程序支付
    uni.requestPayment({
      provider: 'weixin',
      timeStamp: options.timeStamp,
      nonceStr: options.nonceStr,
      package: options.package,
      signType: options.signType,
      paySign: options.paySign,
      success: options.success,
      fail: options.fail
    })
  } else if (platform === 'app') {
    // App 支付
    uni.requestPayment({
      provider: 'weixin',
      timeStamp: options.timeStamp,
      nonceStr: options.nonceStr,
      package: options.package,
      signType: options.signType,
      paySign: options.paySign,
      success: options.success,
      fail: options.fail
    })
  } else {
    // H5 支付
    window.location.href = options.payUrl
  }
}
