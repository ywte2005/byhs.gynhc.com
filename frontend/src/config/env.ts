/**
 * 环境配置 - 根据平台和环境进行配置
 */

import { getPlatform } from './platform'

// 获取当前环境
function getEnv(): string {
  // #ifdef DEBUG
  return 'development'
  // #endif

  // #ifdef RELEASE
  return 'production'
  // #endif

  return 'development'
}

// 获取 API 基础 URL
function getApiBaseUrl(): string {
  const platform = getPlatform()
  const env = getEnv()

  // 开发环境
  if (env === 'development') {
    if (platform === 'h5') {
      return 'http://localhost:8000'
    } else if (platform === 'app') {
      return 'https://api-dev.example.com'
    } else if (platform === 'weixin') {
      return 'https://api-dev.example.com'
    }
  }

  // 生产环境
  if (platform === 'h5') {
    return 'https://api.example.com'
  } else if (platform === 'app') {
    return 'https://api.example.com'
  } else if (platform === 'weixin') {
    return 'https://api.example.com'
  }

  return 'https://api.example.com'
}

// 获取应用配置
function getAppConfig(): any {
  const platform = getPlatform()
  const env = getEnv()

  return {
    platform,
    env,
    apiBaseUrl: getApiBaseUrl(),
    debug: env === 'development',
    
    // 平台特定配置
    h5: {
      enableShare: false,
      enableNativeAPI: false,
      enableStatusBar: false
    },
    
    app: {
      enableShare: true,
      enableNativeAPI: true,
      enableStatusBar: true
    },
    
    weixin: {
      enableShare: true,
      enableNativeAPI: false,
      enableStatusBar: true,
      appId: process.env.VUE_APP_WEIXIN_APPID || ''
    }
  }
}

// 获取存储配置
function getStorageConfig(): any {
  const platform = getPlatform()

  return {
    // 存储键前缀
    keyPrefix: `${platform}_`,
    
    // 存储大小限制（字节）
    maxSize: platform === 'h5' ? 5 * 1024 * 1024 : 10 * 1024 * 1024,
    
    // 是否启用加密
    enableEncryption: platform !== 'h5'
  }
}

// 获取网络配置
function getNetworkConfig(): any {
  const platform = getPlatform()

  return {
    // 请求超时时间（毫秒）
    timeout: 30000,
    
    // 重试次数
    retryCount: platform === 'h5' ? 1 : 3,
    
    // 重试延迟（毫秒）
    retryDelay: 1000,
    
    // 是否启用请求缓存
    enableCache: platform !== 'h5',
    
    // 缓存过期时间（秒）
    cacheExpiry: 3600
  }
}

// 获取日志配置
function getLogConfig(): any {
  const env = getEnv()

  return {
    // 日志级别
    level: env === 'development' ? 'debug' : 'error',
    
    // 是否输出到控制台
    console: env === 'development',
    
    // 是否上传到服务器
    upload: env === 'production',
    
    // 上传地址
    uploadUrl: 'https://api.example.com/logs'
  }
}

// 导出配置
export const config = {
  app: getAppConfig(),
  storage: getStorageConfig(),
  network: getNetworkConfig(),
  log: getLogConfig(),
  
  // 获取平台特定配置
  getPlatformConfig() {
    const platform = getPlatform()
    return this.app[platform as keyof typeof this.app] || {}
  }
}

// 导出单个配置获取函数
export const appConfig = getAppConfig()
export const storageConfig = getStorageConfig()
export const networkConfig = getNetworkConfig()
export const logConfig = getLogConfig()
