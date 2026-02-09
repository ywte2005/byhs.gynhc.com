import { request } from "@/.cool/service";

/**
 * 实名认证服务
 */

// 认证状态类型
export type CertificationStatus = 'none' | 'pending' | 'approved' | 'rejected';

// 认证类型
export type CertificationType = 'personal' | 'enterprise';

// 认证信息
export type CertificationInfo = {
	id: number;
	status: CertificationStatus;
	status_text: string;
	type: CertificationType;
	type_text: string;
	name: string;
	id_card: string;
	reject_reason?: string;
	createtime: string;
	audit_time?: string;
};

// 认证详情
export type CertificationDetail = CertificationInfo & {
	id_card_front: string;
	id_card_back: string;
	contact_phone: string;
	enterprise_name?: string;
	credit_code?: string;
	business_license?: string;
};

// 认证表单
export type CertificationForm = {
	type: CertificationType;
	name: string;
	id_card: string;
	id_card_front: string;
	id_card_back: string;
	contact_phone: string;
	enterprise_name?: string;
	credit_code?: string;
	business_license?: string;
};

// 获取认证状态
export function getCertificationStatus(): Promise<CertificationInfo | { status: 'none'; message: string }> {
	return request({
		url: "/certification/status",
		method: "GET"
	});
}

// 提交认证申请
export function submitCertification(form: CertificationForm): Promise<{ id: number; status: string }> {
	return request({
		url: "/certification/submit",
		method: "POST",
		data: form
	});
}

// 获取认证详情
export function getCertificationDetail(): Promise<CertificationDetail> {
	return request({
		url: "/certification/detail",
		method: "GET"
	});
}
