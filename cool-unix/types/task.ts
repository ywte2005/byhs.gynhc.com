/**
 * 任务模块类型定义
 */

// 任务状态
export type TaskStatus = 'pending' | 'approved' | 'running' | 'paused' | 'completed' | 'cancelled'

// 子任务状态
export type SubTaskStatus = 'pending' | 'assigned' | 'accepted' | 'paid' | 'verified' | 'completed' | 'failed' | 'cancelled'

// 互助主任务
export type MutualTask = {
	id: number
	user_id: number
	task_no: string
	total_amount: number
	completed_amount: number
	deposit_amount: number
	service_fee_rate: number
	sub_task_min: number
	sub_task_max: number
	channel_id: number
	start_time: number
	end_time: number
	status: TaskStatus
	remark: string
	createtime: number
	updatetime: number
}

// 子任务
export type SubTask = {
	id: number
	task_id: number
	task_no: string
	from_user_id: number
	to_user_id: number
	amount: number
	commission: number
	service_fee: number
	proof_image: string
	third_order_no: string
	status: SubTaskStatus
	assigned_time: number
	accepted_time: number
	paid_time: number
	completed_time: number
	fail_reason: string
	createtime: number
	updatetime: number
}

// 创建任务表单
export type CreateTaskForm = {
	title: string
	type_code: string
	total_amount: number
	channel_id: number
	collection_type: 'merchant' | 'qrcode'
	qr_code?: string
	start_time: string
	end_time: string
	remark: string
}

// 上传凭证表单
export type UploadProofForm = {
	subtask_id: number
	proof_image: string
	third_order_no: string
}
