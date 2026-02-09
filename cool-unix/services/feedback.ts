import { request } from "@/.cool/service";

/**
 * 工单反馈服务
 */

// 反馈状态类型
export type FeedbackStatus = 'pending' | 'processing' | 'replied' | 'closed';

// 反馈类型
export type FeedbackType = 'suggestion' | 'bug' | 'complaint' | 'question' | 'other';

// 反馈项
export type FeedbackItem = {
	id: number;
	type: FeedbackType;
	type_text: string;
	title: string;
	content: string;
	status: FeedbackStatus;
	status_text: string;
	reply?: string;
	createtime: number;
	reply_time?: number;
};

// 反馈详情
export type FeedbackDetail = FeedbackItem & {
	images: string[];
	contact: string;
};

// 反馈表单
export type FeedbackForm = {
	type: FeedbackType;
	title?: string;
	content: string;
	images?: string;
	contact?: string;
};

// 反馈类型选项
export type FeedbackTypeOption = {
	value: FeedbackType;
	label: string;
};

// 获取反馈列表
export function getFeedbackList(page: number = 1, pageSize: number = 10): Promise<{
	list: FeedbackItem[];
	total: number;
	page: number;
	page_size: number;
}> {
	return request({
		url: "/feedback/index",
		method: "GET",
		data: { page, page_size: pageSize }
	});
}

// 获取反馈类型列表
export function getFeedbackTypes(): Promise<{ list: FeedbackTypeOption[] }> {
	return request({
		url: "/feedback/types",
		method: "GET"
	});
}

// 提交反馈
export function submitFeedback(form: FeedbackForm): Promise<{ id: number }> {
	return request({
		url: "/feedback/submit",
		method: "POST",
		data: form
	});
}

// 获取反馈详情
export function getFeedbackDetail(id: number): Promise<FeedbackDetail> {
	return request({
		url: "/feedback/detail",
		method: "GET",
		data: { id }
	});
}
