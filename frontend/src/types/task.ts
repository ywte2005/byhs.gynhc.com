/**
 * 任务相关类型定义
 */

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
  status: 'pending' | 'approved' | 'running' | 'paused' | 'completed' | 'cancelled'
  remark: string | null
  createtime: number
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
  proof_image: string | null
  third_order_no: string | null
  status: 'pending' | 'assigned' | 'accepted' | 'paid' | 'verified' | 'completed' | 'failed' | 'cancelled'
  assigned_time: number | null
  accepted_time: number | null
  paid_time: number | null
  completed_time: number | null
  fail_reason: string | null
  createtime: number
}

// 创建任务表单
export type CreateTaskForm = {
  total_amount: number
  deposit_amount: number
  channel_id: number
  start_time: number
  end_time: number
  remark: string | null
}

// 接单表单
export type AcceptSubTaskForm = {
  sub_task_id: number
}

// 上传凭证表单
export type UploadProofForm = {
  sub_task_id: number
  proof_image: string
  third_order_no: string
}
