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

// 获取银行列表
export function getBanks(): Promise<{ list: Array<{ code: string; name: string }> }> {
	return request({
		url: "/merchant/banks",
		method: "GET"
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

// 经营类目类型
export type MerchantCategory = {
	id: number;
	name: string;
	code: string;
	level: number;
	children?: MerchantCategory[];
};

// 获取经营类目列表
export function getMerchantCategories(): Promise<{ list: MerchantCategory[] }> {
	return request({
		url: "/merchant/categories",
		method: "GET"
	});
}

// ==================== 进件申请相关 ====================

// 进件申请类型
export type MerchantApplication = {
	id: number;
	application_no: string;
	merchant_id: number;
	channel: string;
	type: string;
	name: string;
	id_card: string;
	contact_name: string;
	contact_phone: string;
	category: string;
	category_code: string;
	address: string;
	business_license: string;
	id_card_front: string;
	id_card_back: string;
	shop_front: string;
	other_files: string;
	status: 'pending' | 'approved' | 'rejected';
	status_text: string;
	type_text: string;
	reject_reason: string;
	createtime: number;
};

// 进件申请表单类型
export type ApplicationForm = {
	type: 'personal' | 'individual' | 'enterprise';
	name: string;
	id_card: string;
	contact_name: string;
	contact_phone: string;
	category: string;
	category_code: string;
	address: string;
	business_license?: string;
	id_card_front?: string;
	id_card_back?: string;
	shop_front?: string;
	other_files?: string;
	channel?: string;
};

// 获取进件列表
export function getApplicationList(status: string = 'all', page: number = 1, pageSize: number = 10): Promise<{
	list: MerchantApplication[];
	total: number;
}> {
	return request({
		url: "/merchantapp/list",
		method: "GET",
		data: { status, page, page_size: pageSize }
	});
}

// 获取进件详情
export function getApplicationDetail(id: number): Promise<{ application: MerchantApplication }> {
	return request({
		url: "/merchantapp/detail",
		method: "GET",
		data: { id }
	});
}

// 提交进件申请
export function submitApplication(form: ApplicationForm): Promise<{ application: MerchantApplication }> {
	return request({
		url: "/merchantapp/submit",
		method: "POST",
		data: form
	});
}

// 重新提交进件申请
export function resubmitApplication(id: number, form: ApplicationForm): Promise<{ application: MerchantApplication }> {
	return request({
		url: "/merchantapp/resubmit",
		method: "POST",
		data: { id, ...form }
	});
}
