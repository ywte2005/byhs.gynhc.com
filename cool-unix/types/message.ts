/**
 * 消息模块类型定义
 */

// 消息类型
export type MessageType = 'system' | 'task' | 'wallet' | 'promo'

// 消息状态
export type MessageStatus = 'unread' | 'read'

// 消息信息
export type MessageInfo = {
	id: number
	user_id: number
	type: MessageType
	title: string
	content: string
	status: MessageStatus
	createtime: number
}

// 消息列表查询参数
export type MessageQuery = {
	type?: MessageType
	status?: MessageStatus
	page: number
	limit: number
}
