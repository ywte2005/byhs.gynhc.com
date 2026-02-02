import { request } from "@/.cool/service";

export type TaskConfig = {
	split_amount: string;
	service_fee_ratio: string;
	deposit_warn_ratio: string;
};

export type PromoTask = {
	id: number;
	merchant_id: number;
	total_amount: string;
	deposit_amount: string;
	completed_amount: string;
	service_fee: string;
	status: string;
	start_time: number;
	end_time: number;
	createtime: number;
};

export type TaskItem = {
	id: number;
	task_id: number;
	user_id: number;
	amount: string;
	status: string;
	assigned_time: number;
	settled_time: number;
};

export function getTaskConfig(): Promise<TaskConfig> {
	return request({
		url: "/promo_task/config",
		method: "GET",
	});
}

export function createTask(totalAmount: string, startTime: string, endTime: string): Promise<{ task_id: number }> {
	return request({
		url: "/promo_task/create",
		method: "POST",
		data: {
			total_amount: totalAmount,
			start_time: startTime,
			end_time: endTime,
		},
	});
}

export function startTask(taskId: number): Promise<{ task_id: number; status: string }> {
	return request({
		url: "/promo_task/start",
		method: "POST",
		data: {
			task_id: taskId,
		},
	});
}

export function getTaskList(status: string | null = null): Promise<{ list: PromoTask[] }> {
	return request({
		url: "/promo_task/list",
		method: "GET",
		data: status != null ? { status } : {},
	});
}

export function getTaskDetail(taskId: number): Promise<PromoTask & { items: TaskItem[] }> {
	return request({
		url: "/promo_task/detail",
		method: "GET",
		data: { task_id: taskId },
	});
}
