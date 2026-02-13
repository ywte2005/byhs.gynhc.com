import { request } from "@/.cool/service";
import type { WalletInfo, WalletLog, RechargeForm, WithdrawForm, WithdrawRecord } from "@/types/wallet";

/**
 * 钱包服务
 */

// 获取钱包信息
export function getWalletInfo(): Promise<WalletInfo> {
	return request({
		url: "/wallet/info",
		method: "GET"
	});
}

// 获取流水记录
export function getWalletLogs(params: {
	wallet_type?: string;
	change_type?: string;
	page?: number;
	limit?: number;
}): Promise<{ list: WalletLog[]; total: number }> {
	return request({
		url: "/wallet/logs",
		method: "GET",
		data: params
	});
}

// 充值
export function recharge(form: RechargeForm): Promise<{ recharge: any }> {
	return request({
		url: "/wallet/recharge",
		method: "POST",
		data: form
	});
}

// 提现申请
export function withdraw(form: WithdrawForm): Promise<{ withdraw_id: number }> {
	return request({
		url: "/wallet/withdraw",
		method: "POST",
		data: form
	});
}

// 提现记录
export function getWithdrawRecords(params: {
	status?: string;
	page?: number;
	limit?: number;
}): Promise<{ list: WithdrawRecord[]; total: number }> {
	return request({
		url: "/wallet/withdrawRecords",
		method: "GET",
		data: params
	});
}

// 获取提现配置
export function getWithdrawConfig(): Promise<{
	min_amount: number;
	max_amount: number;
	fee_rate: number;
	fee_min: number;
}> {
	return request({
		url: "/wallet/withdrawConfig",
		method: "GET"
	});
}

// 余额转保证金
export function depositPay(amount: number): Promise<void> {
	return request({
		url: "/wallet/depositPay",
		method: "POST",
		data: { amount }
	});
}

// 保证金转余额
export function depositWithdraw(amount: number): Promise<void> {
	return request({
		url: "/wallet/depositWithdraw",
		method: "POST",
		data: { amount }
	});
}

// 银行卡相关接口
export type Bankcard = {
	id: number;
	bank_name: string;
	bank_code: string;
	card_no: string;
	card_holder: string;
	bank_branch: string;
	is_default: number;
};

// 银行配置类型
export type BankConfig = {
	id: number;
	bank_name: string;
	bank_code: string;
	bank_logo: string;
};

// 获取银行列表
export function getBankList(): Promise<{ list: BankConfig[] }> {
	return request({
		url: "/wallet/bankList",
		method: "GET"
	});
}

// 获取银行卡列表
export function getBankcards(): Promise<{ list: Bankcard[] }> {
	return request({
		url: "/wallet/bankcards",
		method: "GET"
	});
}

// 添加银行卡
export function addBankcard(data: {
	bank_name: string;
	bank_code?: string;
	card_no: string;
	card_holder: string;
	bank_branch?: string;
}): Promise<{ bankcard: Bankcard }> {
	return request({
		url: "/wallet/addBankcard",
		method: "POST",
		data
	});
}

// 删除银行卡
export function deleteBankcard(bankcardId: number): Promise<void> {
	return request({
		url: "/wallet/deleteBankcard",
		method: "POST",
		data: { bankcard_id: bankcardId }
	});
}

// 设置默认银行卡
export function setDefaultBankcard(bankcardId: number): Promise<void> {
	return request({
		url: "/wallet/setDefaultBankcard",
		method: "POST",
		data: { bankcard_id: bankcardId }
	});
}

// 发起微信支付
export function wechatPay(orderNo: string, payMethod?: string): Promise<any> {
	return request({
		url: "/payment/wechat",
		method: "POST",
		data: { order_no: orderNo, method: payMethod }
	});
}

// 查询支付状态
export function queryPayStatus(orderNo: string): Promise<{ status: string; paid: boolean }> {
	return request({
		url: "/payment/query",
		method: "GET",
		data: { order_no: orderNo }
	});
}
