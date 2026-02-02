import { request } from "@/.cool/service";
import type { MerchantInfo, MerchantRegisterForm, MerchantAudit } from "@/types/merchant";

/**
 * 商户服务
 */

// 获取商户信息
export function getMerchantInfo(): Promise<MerchantInfo | null> {
	return request({
		url: "/merchant/info",
		method: "GET"
	});
}

// 商户注册/进件
export function registerMerchant(form: MerchantRegisterForm): Promise<{ merchant_id: number }> {
	return request({
		url: "/merchant/register",
		method: "POST",
		data: form
	});
}

// 获取审核状态
export function getAuditStatus(): Promise<{
	status: string;
	audit_list: MerchantAudit[];
}> {
	return request({
		url: "/merchant/auditStatus",
		method: "GET"
	});
}

// 支付入驻费
export function payEntryFee(payMethod: string = "balance"): Promise<{ order_no: string }> {
	return request({
		url: "/merchant/payEntryFee",
		method: "POST",
		data: {
			pay_method: payMethod
		}
	});
}

// 更新商户信息
export function updateMerchantInfo(data: Partial<MerchantRegisterForm>): Promise<void> {
	return request({
		url: "/merchant/update",
		method: "POST",
		data
	});
}
