/**
 * 推广服务
 */

import { get, post } from './api'
import type { ApiResponse } from '@/types/common'
import type { PromoRelation, Commission, Bonus, Performance, TeamMember, PromoOverview } from '@/types/promo'

// 获取推广概览
export function getPromoOverview(): Promise<ApiResponse<PromoOverview>> {
  return get('/api/promo/overview')
}

// 获取等级列表
export function getLevelList(): Promise<ApiResponse<any[]>> {
  return get('/api/promo/levels')
}

// 购买等级
export function purchaseLevel(level_id: number): Promise<ApiResponse<{ order_no: string }>> {
  return post('/api/promo/purchase-level', { level_id })
}

// 获取我的邀请码
export function getMyInviteCode(): Promise<ApiResponse<{ invite_code: string }>> {
  return get('/api/promo/my-invite-code')
}

// 绑定上级
export function bindRelation(invite_code: string): Promise<ApiResponse<null>> {
  return post('/api/promo/bind-relation', { invite_code })
}

// 获取我的团队
export function getMyTeam(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: TeamMember[]; total: number }>> {
  return get(`/api/promo/my-team?page=${page}&limit=${limit}`)
}

// 获取佣金记录
export function getCommissionList(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: Commission[]; total: number }>> {
  return get(`/api/promo/commission-list?page=${page}&limit=${limit}`)
}

// 获取业绩统计
export function getPerformanceSummary(): Promise<ApiResponse<Performance>> {
  return get('/api/promo/performance-summary')
}

// 获取分红概览
export function getBonusSummary(): Promise<ApiResponse<{ total_bonus: number; pending_bonus: number }>> {
  return get('/api/promo/bonus-summary')
}

// 获取分红记录
export function getBonusRecords(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: Bonus[]; total: number }>> {
  return get(`/api/promo/bonus-records?page=${page}&limit=${limit}`)
}
