/**
 * 钱包模块类型定义
 */

// 钱包类型
export type WalletType = 'balance' | 'deposit' | 'frozen' | 'mutual'

// 变动类型
export type ChangeType = 'income' | 'expense' | 'freeze' | 'unfreeze'

// 钱包信息
export type WalletInfo = {
	id: number
	user_id: number
	balance: number
	deposit: number
	frozen: number
	mutual_balance: number
	total_income: number
	total_withdraw: number
	updatetime: number
}

// 钱包流水
export type WalletLog = {
	id: number
	user_id: number
	wallet_type: WalletType
	change_type: ChangeType
	amount: number
	before_amount: number
	after_amount: number
	biz_type: string
	biz_id: number
	remark: string
	createtime: number
}

// 充值表单
export type RechargeForm = {
	amount: number
	pay_type: string
}

// 提现表单
export type WithdrawForm = {
	amount: number
	bank_account: string
	bank_name: string
}

// 提现记录
export type WithdrawRecord = {
	id: number
	user_id: number
	amount: number
	fee: number
	actual_amount: number
	bank_account: string
	bank_name: string
	status: 'pending' | 'approved' | 'rejected' | 'completed'
	remark: string
	createtime: number
	updatetime: number
}
