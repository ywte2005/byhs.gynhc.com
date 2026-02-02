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
export function recharge(form: RechargeForm): Promise<{ order_no: string; pay_info: any }> {
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
	daily_limit: number;
}> {
	return request({
		url: "/wallet/withdrawConfig",
		method: "GET"
	});
}
