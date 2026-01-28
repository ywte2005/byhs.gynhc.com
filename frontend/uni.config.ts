import { defineConfig } from '@dcloudio/uni-app'

export default defineConfig({
  // 项目配置
  projectName: '商户互助平台',
  appId: 'merchant-mutual-platform',
  
  // 编译配置
  compilerOptions: {
    // 启用 TypeScript
    typescript: true,
    // 启用 UTS
    uts: true
  },

  // 应用配置
  appConfig: {
    pages: [
      // 认证相关
      'pages/auth/login',
      'pages/auth/register',
      'pages/auth/certification',
      'pages/auth/forgot',
      
      // 首页
      'pages/index/index',
      
      // 消息
      'pages/message/index',
      
      // 商户
      'pages/merchant/index',
      'pages/merchant/register',
      'pages/merchant/audit-status',
      'pages/merchant/info',
      
      // 任务
      'pages/task/index',
      'pages/task/create',
      'pages/task/detail',
      'pages/task/my-tasks',
      'pages/task/subtask/list',
      'pages/task/subtask/my',
      'pages/task/subtask/detail',
      'pages/task/subtask/upload',
      'pages/task/deposit',
      
      // 钱包
      'pages/wallet/index',
      'pages/wallet/recharge',
      'pages/wallet/withdraw',
      'pages/wallet/logs',
      
      // 推广
      'pages/promo/index',
      'pages/promo/level',
      'pages/promo/invite',
      'pages/promo/team',
      'pages/promo/commission',
      'pages/promo/performance',
      'pages/promo/bonus',
      'pages/promo/wallet'
    ],
    
    window: {
      navigationBarBackgroundColor: '#0052d9',
      navigationBarTextStyle: 'white',
      navigationBarTitleText: '旺铺集',
      backgroundColor: '#f5f7fa',
      backgroundTextStyle: 'light'
    },

    tabBar: {
      color: '#9aa0a6',
      selectedColor: '#0052d9',
      backgroundColor: '#ffffff',
      borderStyle: 'black',
      list: [
        {
          pagePath: 'pages/index/index',
          text: '首页',
          iconPath: 'static/icons/home.png',
          selectedIconPath: 'static/icons/home-active.png'
        },
        {
          pagePath: 'pages/task/index',
          text: '任务',
          iconPath: 'static/icons/task.png',
          selectedIconPath: 'static/icons/task-active.png'
        },
        {
          pagePath: 'pages/promo/index',
          text: '推广',
          iconPath: 'static/icons/promo.png',
          selectedIconPath: 'static/icons/promo-active.png'
        },
        {
          pagePath: 'pages/wallet/index',
          text: '钱包',
          iconPath: 'static/icons/wallet.png',
          selectedIconPath: 'static/icons/wallet-active.png'
        },
        {
          pagePath: 'pages/merchant/index',
          text: '我的',
          iconPath: 'static/icons/user.png',
          selectedIconPath: 'static/icons/user-active.png'
        }
      ]
    }
  }
})
