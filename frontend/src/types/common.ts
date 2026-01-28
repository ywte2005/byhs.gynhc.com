/**
 * 通用类型定义
 */

// API 响应格式
export type ApiResponse<T = null> = {
  code: number
  message: string
  data: T
}

// 用户信息
export type User = {
  id: number
  phone: string
  nickname: string
  avatar: string | null
  level_id: number
  status: 'normal' | 'disabled'
  createtime: number
}

// 认证状态
export type AuthStatus = 'pending' | 'approved' | 'rejected'

// 钱包信息
export type Wallet = {
  id: number
  user_id: number
  balance: number
  deposit: number
  frozen: number
  mutual_balance: number
  total_income: number
  total_withdraw: number
}

// 消息类型
export type MessageType = 'system' | 'task' | 'fund' | 'promo'

// 消息项
export type Message = {
  id: number
  user_id: number
  type: MessageType
  title: string
  content: string
  read: boolean
  createtime: number
}

// 等级信息
export type Level = {
  id: number
  name: string
  sort: number
  upgrade_type: 'purchase' | 'performance' | 'both'
  upgrade_price: number
  commission_rate: number
  status: 'normal' | 'hidden'
}

// 任务状态
export type TaskStatus = 'pending' | 'approved' | 'running' | 'paused' | 'completed' | 'cancelled'

// 子任务状态
export type SubTaskStatus = 'pending' | 'assigned' | 'accepted' | 'paid' | 'verified' | 'completed' | 'failed' | 'cancelled'
