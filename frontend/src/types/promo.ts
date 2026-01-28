/**
 * 推广相关类型定义
 */

// 推广关系
export type PromoRelation = {
  id: number
  user_id: number
  level_id: number
  parent_id: number | null
  path: string
  depth: number
  invite_code: string
  createtime: number
}

// 佣金记录
export type Commission = {
  id: number
  user_id: number
  source_user_id: number
  scene: string
  reward_type: string
  rule_id: number
  base_amount: number
  amount: number
  status: 'pending' | 'settled' | 'cancelled'
  settle_time: number | null
  remark: string | null
  createtime: number
}

// 分红记录
export type Bonus = {
  id: number
  user_id: number
  bonus_config_id: number
  amount: number
  status: 'pending' | 'settled' | 'cancelled'
  settle_time: number | null
  createtime: number
}

// 业绩统计
export type Performance = {
  id: number
  user_id: number
  month: string
  personal_performance: number
  team_performance: number
  growth: number
  createtime: number
}

// 团队成员
export type TeamMember = {
  id: number
  user_id: number
  nickname: string
  avatar: string | null
  level_id: number
  level_name: string
  personal_performance: number
  team_performance: number
  createtime: number
}

// 推广概览
export type PromoOverview = {
  level_id: number
  level_name: string
  invite_code: string
  total_team_members: number
  personal_performance: number
  team_performance: number
  total_commission: number
  total_bonus: number
  pending_commission: number
}
