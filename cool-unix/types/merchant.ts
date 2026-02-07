/**
 * 商户模块类型定义
 */

// 商户状态
export type MerchantStatus = 'pending' | 'approved' | 'rejected' | 'disabled'

// 商户信息
export type MerchantInfo = {
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
	status: MerchantStatus
	approved_time: number
	createtime: number
	updatetime: number
}

// 商户注册表单
export type MerchantRegisterForm = {
	type?: string
	name: string
	legal_name?: string
	id_card: string
	id_card_front: string
	id_card_back: string
	business_license?: string
	shop_front?: string
	other_files?: string
	bank_name?: string
	bank_account?: string
	bank_branch?: string
	contact_phone: string
	contact?: string
	category?: string
	address?: string
	credit_code?: string
}

// 审核记录
export type MerchantAudit = {
	id: number
	merchant_id: number
	status: MerchantStatus
	remark: string
	admin_id: number
	createtime: number
}
