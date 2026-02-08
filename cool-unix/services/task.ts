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

// 上传支付凭证
export function uploadProof(form: UploadProofForm): Promise<void> {
	return request({
		url: "/task/subtaskUploadProof",
		method: "POST",
		data: form
	});
}

// 取消接单
export function cancelSubTask(subtaskId: number, reason: string): Promise<void> {
	return request({
		url: "/task/subtaskCancel",
		method: "POST",
		data: {
			subtask_id: subtaskId,
			reason
		}
	});
}

// 获取保证金信息
export function getDepositInfo(): Promise<{
	deposit: number;
	frozen: number;
	available: number;
}> {
	return request({
		url: "/task/depositInfo",
		method: "GET"
	});
}

// 充值保证金
export function rechargeDeposit(amount: number, payMethod: string = "balance"): Promise<{ order_no: string }> {
	return request({
		url: "/task/depositRecharge",
		method: "POST",
		data: {
			amount,
			pay_method: payMethod
		}
	});
}

// 提取保证金
export function withdrawDeposit(amount: number): Promise<void> {
	return request({
		url: "/task/depositWithdraw",
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
