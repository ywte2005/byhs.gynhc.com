import { request } from "@/.cool/service";
import type { MutualTask, SubTask, CreateTaskForm, UploadProofForm } from "@/types/task";

/**
 * 任务服务
 */

// 获取任务列表（任务大厅 - 可接的子任务）
export function getTaskList(params: {
	category?: string;
	page?: number;
	pageSize?: number;
}): Promise<{ list: SubTask[]; total: number; hasMore: boolean }> {
	return request({
		url: "/task/list",
		method: "GET",
		data: {
			category: params.category,
			page: params.page,
			limit: params.pageSize
		}
	});
}

// 获取任务详情
export function getTaskDetail(taskId: number): Promise<MutualTask & { sub_tasks: SubTask[] }> {
	return request({
		url: "/task/detail",
		method: "GET",
		data: { task_id: taskId }
	});
}

// 创建任务
export function createTask(form: CreateTaskForm): Promise<{ task_id: number }> {
	return request({
		url: "/task/create",
		method: "POST",
		data: form
	});
}

// 取消任务
export function cancelTask(taskId: number, reason: string): Promise<void> {
	return request({
		url: "/task/cancel",
		method: "POST",
		data: {
			task_id: taskId,
			reason
		}
	});
}

// 获取任务保证金信息
export function getTaskDepositInfo(taskId: number): Promise<{
	task_id: number;
	total_amount: string;
	paid_amount: string;
	remaining_amount: string;
	progress: number;
	status: string;
	status_text: string;
	logs: any[];
}> {
	return request({
		url: "/task/getDepositInfo",
		method: "GET",
		data: { task_id: taskId }
	});
}

// 获取用户保证金账户信息
export function getDepositInfo(): Promise<{
	deposit: number;
	frozen_deposit: number;
	total_deposit: number;
	logs: any[];
}> {
	return request({
		url: "/wallet/depositInfo",
		method: "GET"
	});
}

// 缴纳/补缴保证金
export function payDeposit(taskId: number, amount?: number): Promise<{ task: any }> {
	return request({
		url: "/task/payDeposit",
		method: "POST",
		data: { 
			task_id: taskId,
			amount: amount  // 可选，不传则缴纳全部剩余
		}
	});
}

// 我发起的任务
export function getMyTasks(params: {
	status?: string;
	page?: number;
	limit?: number;
}): Promise<{ list: MutualTask[]; total: number }> {
	return request({
		url: "/task/myTasks",
		method: "GET",
		data: params
	});
}

// 获取可接子任务列表
export function getAvailableSubTasks(params: {
	page?: number;
	limit?: number;
}): Promise<{ list: SubTask[]; total: number }> {
	return request({
		url: "/task/subtaskAvailable",
		method: "GET",
		data: params
	});
}

// 我接的子任务
export function getMySubTasks(params: {
	status?: string;
	page?: number;
	limit?: number;
}): Promise<{ list: SubTask[]; total: number }> {
	return request({
		url: "/task/subtaskMy",
		method: "GET",
		data: params
	});
}

// 获取子任务详情
export function getSubTaskDetail(subtaskId: number): Promise<SubTask> {
	return request({
		url: "/task/subtaskDetail",
		method: "GET",
		data: { subtask_id: subtaskId }
	});
}

// 接受子任务
export function acceptSubTask(subtaskId: number): Promise<void> {
	return request({
		url: "/task/subtaskAccept",
		method: "POST",
		data: { subtask_id: subtaskId }
	});
}

// 上传支付凭证（旧接口，保留兼容）
export function uploadProof(form: UploadProofForm): Promise<void> {
	return request({
		url: "/task/subtaskUploadProof",
		method: "POST",
		data: form
	});
}

// 上传子任务凭证
export function uploadSubTaskProof(subtaskId: number, proofImage: string, proofDesc: string = ''): Promise<{ subtask: SubTask }> {
	return request({
		url: "/task/subtaskUploadProof",
		method: "POST",
		data: {
			subtask_id: subtaskId,
			proof_image: proofImage,
			proof_desc: proofDesc
		}
	});
}

// 取消接单
export function cancelSubTask(subtaskId: number, reason: string = ''): Promise<void> {
	return request({
		url: "/task/subtaskCancel",
		method: "POST",
		data: {
			subtask_id: subtaskId,
			reason
		}
	});
}

// 发布者确认子任务完成
export function confirmSubTask(subtaskId: number): Promise<{ count: number }> {
	return request({
		url: "/task/subtaskConfirm",
		method: "POST",
		data: { subtask_id: subtaskId }
	});
}

// 发布者拒绝子任务
export function rejectSubTask(subtaskId: number, reason: string = '凭证不符合要求'): Promise<{ count: number }> {
	return request({
		url: "/task/subtaskReject",
		method: "POST",
		data: {
			subtask_id: subtaskId,
			reason
		}
	});
}


// 充值保证金（从余额转入保证金账户）
export function rechargeDeposit(amount: number): Promise<void> {
	return request({
		url: "/wallet/depositPay",
		method: "POST",
		data: { amount }
	});
}

// 提取保证金（从保证金账户转回余额）
export function withdrawDeposit(amount: number): Promise<void> {
	return request({
		url: "/wallet/depositWithdraw",
		method: "POST",
		data: { amount }
	});
}

// 检查是否可以接单
export function canReceiveTask(): Promise<{ can: boolean; reason: string }> {
	return request({
		url: "/task/canReceive",
		method: "GET"
	});
}

// 任务类型
export type TaskType = {
	id: number;
	name: string;
	code: string;
	icon: string;
	description: string;
	sort: number;
	status: string;
}

// 获取任务类型列表
export function getTaskTypes(): Promise<{ list: TaskType[] }> {
	return request({
		url: "/task/types",
		method: "GET"
	});
}
