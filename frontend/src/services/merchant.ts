/**
 * 商户服务
 */

import { get, post } from './api'
import type { ApiResponse } from '@/types/common'
import type { Merchant } from '@/types/merchant'

// 获取商户信息
export function getMerchantInfo(): Promise<ApiResponse<Merchant>> {
  return get('/api/merchant/info')
}

// 支付入驻费
export function payEntryFee(): Promise<ApiResponse<{ order_no: string }>> {
  return post('/api/merchant/pay-entry-fee')
}
