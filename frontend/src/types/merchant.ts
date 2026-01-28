/**
 * 商户相关类型定义
 */

// 商户信息
export type Merchant = {
  id: number
  user_id: number
  merchant_no: string
  name: string
  legal_name: string
  id_card: string
  id_card_front: string
  id_card_back: string
  business_license: string
  bank_name: string
  bank_account: string
  bank_branch: string
  contact_phone: string
  entry_fee: number
  status: 'pending' | 'approved' | 'rejected' | 'disabled'
  approved_time: number | null
  createtime: number
}

// 商户审核状态
export type MerchantAuditStatus = {
  status: 'pending' | 'approved' | 'rejected'
  reason: string | null
  approved_time: number | null
}

// 认证类型
export type AuthType = 'personal' | 'enterprise'

// 认证表单
export type AuthForm = {
  auth_type: AuthType
  name: string
  id_card: string
  contact_phone: string
  id_card_front: string | null
  id_card_back: string | null
  business_license: string | null
}
