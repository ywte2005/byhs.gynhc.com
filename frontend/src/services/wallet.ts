/**
 * 钱包服务
 */

import { get, post } from './api'
import type { ApiResponse } from '@/types/common'
import type { Wallet } from '@/types/common'

// 获取钱包信息
export function getWalletInfo(): Promise<ApiResponse<Wallet>> {
  return get('/api/wallet/info')
}

// 获取流水记录
export function getWalletLogs(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: any[]; total: number }>> {
  return get(`/api/wallet/logs?page=${page}&limit=${limit}`)
}

// 充值
export function recharge(amount: number): Promise<ApiResponse<{ order_no: string }>> {
  return post('/api/wallet/recharge', { amount })
}

// 提现申请
export function withdraw(amount: number, bank_account: string): Promise<ApiResponse<{ order_no: string }>> {
  return post('/api/wallet/withdraw', { amount, bank_account })
}

// 获取提现记录
export function getWithdrawRecords(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: any[]; total: number }>> {
  return get(`/api/wallet/withdraw-records?page=${page}&limit=${limit}`)
}

// 缴纳保证金
export function payDeposit(amount: number): Promise<ApiResponse<{ order_no: string }>> {
  return post('/api/wallet/deposit/pay', { amount })
}

// 提取保证金
export function withdrawDeposit(amount: number): Promise<ApiResponse<null>> {
  return post('/api/wallet/deposit/withdraw', { amount })
}
