/**
 * 图标配置文件
 * 从设计文件中提取的所有图标名称
 * 使用 Lucide Icons 图标库
 */

export type IconName =
  | 'zap'                  // 闪电 - Logo图标
  | 'message-square'       // 消息方块 - 微信图标
  | 'chevron-left'         // 左箭头 - 返回按钮
  | 'chevron-right'        // 右箭头 - 导航箭头
  | 'plus'                 // 加号 - 添加/上传
  | 'bell'                 // 铃铛 - 通知/消息
  | 'clipboard-list'       // 剪贴板列表 - 任务列表
  | 'clipboard-check'      // 剪贴板勾选 - 任务完成
  | 'wallet'               // 钱包 - 钱包功能
  | 'check'                // 勾选 - 完成/确认
  | 'timer'                // 计时器 - 倒计时
  | 'credit-card'          // 信用卡 - 支付/充值
  | 'users'                // 用户组 - 团队/推广
  | 'user'                 // 用户 - 个人中心
  | 'user-plus'            // 添加用户 - 邀请好友
  | 'gift'                 // 礼物 - 奖励/红包
  | 'triangle-alert'       // 三角警告 - 警告提示
  | 'trending-up'          // 趋势上升 - 业绩增长
  | 'qr-code'              // 二维码 - 扫码
  | 'file-text'            // 文件文本 - 文档/订单
  | 'megaphone'            // 喇叭 - 公告/推广
  | 'search'               // 搜索 - 搜索功能
  | 'house'                // 房子 - 首页
  | 'settings'             // 设置 - 设置页面
  | 'log-out'              // 登出 - 退出登录
  | 'shield-check'         // 盾牌勾选 - 安全认证
  | 'phone'                // 电话 - 联系方式
  | 'mail'                 // 邮件 - 邮箱
  | 'map-pin'              // 地图标记 - 地址
  | 'calendar'             // 日历 - 日期
  | 'clock'                // 时钟 - 时间
  | 'eye'                  // 眼睛 - 查看
  | 'eye-off'              // 眼睛关闭 - 隐藏
  | 'copy'                 // 复制 - 复制功能
  | 'share-2'              // 分享 - 分享功能
  | 'download'             // 下载 - 下载功能
  | 'upload'               // 上传 - 上传功能
  | 'refresh-cw'           // 刷新 - 刷新功能
  | 'filter'               // 筛选 - 筛选功能
  | 'more-horizontal'      // 更多横向 - 更多操作
  | 'more-vertical'        // 更多纵向 - 更多操作
  | 'x'                    // 叉号 - 关闭
  | 'info'                 // 信息 - 提示信息
  | 'alert-circle'         // 警告圆圈 - 错误提示
  | 'check-circle'         // 勾选圆圈 - 成功提示
  | 'help-circle'          // 帮助圆圈 - 帮助提示
  | 'arrow-left'           // 左箭头 - 返回
  | 'arrow-right'          // 右箭头 - 前进
  | 'arrow-up'             // 上箭头 - 向上
  | 'arrow-down'           // 下箭头 - 向下
  | 'external-link'        // 外部链接 - 跳转
  | 'link'                 // 链接 - 链接功能
  | 'image'                // 图片 - 图片功能
  | 'camera'               // 相机 - 拍照功能
  | 'video'                // 视频 - 视频功能
  | 'mic'                  // 麦克风 - 语音功能
  | 'volume-2'             // 音量 - 音频功能
  | 'star'                 // 星星 - 收藏/评分
  | 'heart'                // 心形 - 喜欢/收藏
  | 'bookmark'             // 书签 - 收藏
  | 'flag'                 // 旗帜 - 标记
  | 'tag'                  // 标签 - 标签功能
  | 'folder'               // 文件夹 - 分类
  | 'file'                 // 文件 - 文件功能
  | 'trash-2'              // 垃圾桶 - 删除
  | 'edit'                 // 编辑 - 编辑功能
  | 'save'                 // 保存 - 保存功能
  | 'lock'                 // 锁 - 锁定/加密
  | 'unlock'               // 解锁 - 解锁
  | 'key'                  // 钥匙 - 密码/密钥
  | 'shield'               // 盾牌 - 安全
  | 'award'                // 奖章 - 奖励
  | 'target'               // 目标 - 目标/任务
  | 'activity'             // 活动 - 活动/统计
  | 'bar-chart'            // 柱状图 - 统计图表
  | 'pie-chart'            // 饼图 - 统计图表
  | 'package'              // 包裹 - 订单/包裹
  | 'shopping-cart'        // 购物车 - 购物车
  | 'shopping-bag'         // 购物袋 - 购物
  | 'percent'              // 百分号 - 折扣/比例
  | 'dollar-sign'          // 美元符号 - 金额
  | 'coins'                // 硬币 - 金币/余额

/**
 * 图标Unicode映射表
 * 用于图标字体显示
 */
export const IconUnicode: Record<IconName, string> = {
  'zap': '\ue900',
  'message-square': '\ue901',
  'chevron-left': '\ue902',
  'chevron-right': '\ue903',
  'plus': '\ue904',
  'bell': '\ue905',
  'clipboard-list': '\ue906',
  'clipboard-check': '\ue907',
  'wallet': '\ue908',
  'check': '\ue909',
  'timer': '\ue90a',
  'credit-card': '\ue90b',
  'users': '\ue90c',
  'user': '\ue90d',
  'user-plus': '\ue90e',
  'gift': '\ue90f',
  'triangle-alert': '\ue910',
  'trending-up': '\ue911',
  'qr-code': '\ue912',
  'file-text': '\ue913',
  'megaphone': '\ue914',
  'search': '\ue915',
  'house': '\ue916',
  'settings': '\ue917',
  'log-out': '\ue918',
  'shield-check': '\ue919',
  'headphones': '\ue952',
  'phone': '\ue91a',
  'mail': '\ue91b',
  'map-pin': '\ue91c',
  'calendar': '\ue91d',
  'clock': '\ue91e',
  'eye': '\ue91f',
  'eye-off': '\ue920',
  'copy': '\ue921',
  'share-2': '\ue922',
  'download': '\ue923',
  'upload': '\ue924',
  'refresh-cw': '\ue925',
  'filter': '\ue926',
  'more-horizontal': '\ue927',
  'more-vertical': '\ue928',
  'x': '\ue929',
  'info': '\ue92a',
  'alert-circle': '\ue92b',
  'check-circle': '\ue92c',
  'help-circle': '\ue92d',
  'arrow-left': '\ue92e',
  'arrow-right': '\ue92f',
  'arrow-up': '\ue930',
  'arrow-down': '\ue931',
  'external-link': '\ue932',
  'link': '\ue933',
  'image': '\ue934',
  'camera': '\ue935',
  'video': '\ue936',
  'mic': '\ue937',
  'volume-2': '\ue938',
  'star': '\ue939',
  'heart': '\ue93a',
  'bookmark': '\ue93b',
  'flag': '\ue93c',
  'tag': '\ue93d',
  'folder': '\ue93e',
  'file': '\ue93f',
  'trash-2': '\ue940',
  'edit': '\ue941',
  'save': '\ue942',
  'lock': '\ue943',
  'unlock': '\ue944',
  'key': '\ue945',
  'shield': '\ue946',
  'award': '\ue947',
  'target': '\ue948',
  'activity': '\ue949',
  'bar-chart': '\ue94a',
  'pie-chart': '\ue94b',
  'package': '\ue94c',
  'shopping-cart': '\ue94d',
  'shopping-bag': '\ue94e',
  'percent': '\ue94f',
  'dollar-sign': '\ue950',
  'coins': '\ue951'
}

/**
 * 图标中文名称映射
 */
export const IconLabel: Record<IconName, string> = {
  'zap': '闪电',
  'message-square': '消息',
  'chevron-left': '左箭头',
  'chevron-right': '右箭头',
  'plus': '加号',
  'bell': '铃铛',
  'clipboard-list': '任务列表',
  'clipboard-check': '任务完成',
  'wallet': '钱包',
  'check': '勾选',
  'timer': '计时器',
  'credit-card': '信用卡',
  'users': '用户组',
  'user': '用户',
  'user-plus': '添加用户',
  'gift': '礼物',
  'triangle-alert': '警告',
  'trending-up': '趋势上升',
  'qr-code': '二维码',
  'file-text': '文件',
  'megaphone': '喇叭',
  'search': '搜索',
  'house': '首页',
  'settings': '设置',
  'log-out': '登出',
  'shield-check': '安全认证',
  'phone': '电话',
  'mail': '邮件',
  'map-pin': '地址',
  'calendar': '日历',
  'clock': '时钟',
  'eye': '查看',
  'eye-off': '隐藏',
  'copy': '复制',
  'share-2': '分享',
  'download': '下载',
  'upload': '上传',
  'refresh-cw': '刷新',
  'filter': '筛选',
  'more-horizontal': '更多',
  'more-vertical': '更多',
  'x': '关闭',
  'info': '信息',
  'alert-circle': '错误',
  'check-circle': '成功',
  'help-circle': '帮助',
  'arrow-left': '返回',
  'arrow-right': '前进',
  'arrow-up': '向上',
  'arrow-down': '向下',
  'external-link': '外部链接',
  'link': '链接',
  'image': '图片',
  'camera': '相机',
  'video': '视频',
  'mic': '麦克风',
  'volume-2': '音量',
  'star': '星星',
  'heart': '心形',
  'bookmark': '书签',
  'flag': '旗帜',
  'tag': '标签',
  'folder': '文件夹',
  'file': '文件',
  'trash-2': '删除',
  'edit': '编辑',
  'save': '保存',
  'lock': '锁定',
  'unlock': '解锁',
  'key': '钥匙',
  'shield': '盾牌',
  'award': '奖章',
  'target': '目标',
  'activity': '活动',
  'bar-chart': '柱状图',
  'pie-chart': '饼图',
  'package': '包裹',
  'shopping-cart': '购物车',
  'shopping-bag': '购物袋',
  'percent': '百分号',
  'dollar-sign': '美元',
  'coins': '硬币'
}
