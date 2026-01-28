/**
 * 任务服务
 */

import { get, post } from './api'
import type { ApiResponse } from '@/types/common'
import type { MutualTask, SubTask, CreateTaskForm, AcceptSubTaskForm, UploadProofForm } from '@/types/task'

// 获取任务列表
export function getTaskList(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: MutualTask[]; total: number }>> {
  return get(`/api/task/list?page=${page}&limit=${limit}`)
}

// 获取任务详情
export function getTaskDetail(task_id: number): Promise<ApiResponse<MutualTask>> {
  return get(`/api/task/detail?task_id=${task_id}`)
}

// 创建任务
export function createTask(form: CreateTaskForm): Promise<ApiResponse<{ task_id: number }>> {
  return post('/api/task/create', form)
}

// 获取我发起的任务
export function getMyTasks(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: MutualTask[]; total: number }>> {
  return get(`/api/task/my-tasks?page=${page}&limit=${limit}`)
}

// 获取可接子任务列表
export function getAvailableSubTasks(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: SubTask[]; total: number }>> {
  return get(`/api/task/subtask/available?page=${page}&limit=${limit}`)
}

// 获取我接的子任务
export function getMySubTasks(page: number = 1, limit: number = 10): Promise<ApiResponse<{ list: SubTask[]; total: number }>> {
  return get(`/api/task/subtask/my?page=${page}&limit=${limit}`)
}

// 获取子任务详情
export function getSubTaskDetail(sub_task_id: number): Promise<ApiResponse<SubTask>> {
  return get(`/api/task/subtask/detail?sub_task_id=${sub_task_id}`)
}

// 接受子任务
export function acceptSubTask(form: AcceptSubTaskForm): Promise<ApiResponse<null>> {
  return post('/api/task/subtask/accept', form)
}

// 上传支付凭证
export function uploadProof(form: UploadProofForm): Promise<ApiResponse<null>> {
  return post('/api/task/subtask/upload-proof', form)
}

// 取消任务
export function cancelTask(task_id: number): Promise<ApiResponse<null>> {
  return post('/api/task/cancel', { task_id })
}
