/**
 * 认证模块类型定义
 */

// 登录方式
export type LoginType = 'password' | 'sms' | 'wechat'

// 登录表单
export type LoginForm = {
	mobile: string
	password?: string
	code?: string
	type: LoginType
	agree: boolean
}

// 注册表单
export type RegisterForm = {
	mobile: string
	code: string
	password: string
	confirm_password: string
	invite_code?: string
	agree: boolean
}

// 认证类型
export type CertificationType = 'personal' | 'enterprise'

// 认证状态
export type CertificationStatus = 'none' | 'pending' | 'approved' | 'rejected'

// 认证信息
export type CertificationInfo = {
	id: number
	user_id: number
	type: CertificationType
	status: CertificationStatus
	name: string
	id_card: string
	id_card_front: string
	id_card_back: string
	contact_phone: string
	reject_reason?: string
	createtime: number
	updatetime: number
}

// 个人认证表单
export type PersonalCertificationForm = {
	type: 'personal'
	name: string
	id_card: string
	id_card_front: string
	id_card_back: string
	contact_phone: string
}

// 企业认证表单
export type EnterpriseCertificationForm = {
	type: 'enterprise'
	company_name: string
	legal_name: string
	id_card: string
	id_card_front: string
	id_card_back: string
	business_license: string
	contact_phone: string
}

// 认证表单联合类型
export type CertificationForm = PersonalCertificationForm | EnterpriseCertificationForm
