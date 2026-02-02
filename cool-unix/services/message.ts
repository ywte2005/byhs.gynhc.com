import { request } from "@/.cool/service";
import type { MessageInfo, MessageQuery } from "@/types/message";

/**
 * 消息服务
 */

// 获取消息列表
export function getMessageList(params: MessageQuery): Promise<{ list: MessageInfo[]; total: number; unread: number }> {
	return request({
		url: "/message/list",
		method: "GET",
		data: params
	});
}

// 获取消息详情
export function getMessageDetail(messageId: number): Promise<MessageInfo> {
	return request({
		url: "/message/detail",
		method: "GET",
		data: { id: messageId }
	});
}

// 标记已读
export function markAsRead(messageIds: number[]): Promise<void> {
	return request({
		url: "/message/markRead",
		method: "POST",
		data: { ids: messageIds }
	});
}

// 全部标记已读
export function markAllAsRead(type?: string): Promise<void> {
	return request({
		url: "/message/markAllRead",
		method: "POST",
		data: { type }
	});
}

// 删除消息
export function deleteMessage(messageIds: number[]): Promise<void> {
	return request({
		url: "/message/delete",
		method: "POST",
		data: { ids: messageIds }
	});
}

// 获取未读数量
export function getUnreadCount(): Promise<{
	total: number;
	system: number;
	task: number;
	wallet: number;
	promo: number;
}> {
	return request({
		url: "/message/unreadCount",
		method: "GET"
	});
}
