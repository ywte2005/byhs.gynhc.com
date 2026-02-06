import { request } from "@/.cool/service";

/**
 * 用户服务
 */

// 获取地址列表
export function getAddressList(params: {
	page?: number;
	size?: number;
}): Promise<{
	list: Array<{
		id: number;
		contact: string;
		phone: string;
		province: string;
		city: string;
		district: string;
		address: string;
		isDefault: number;
	}>;
	total: number;
}> {
	return request({
		url: "/app/user/address/page",
		method: "POST",
		data: params
	});
}

// 获取地址详情
export function getAddressInfo(id: number): Promise<{
	id: number;
	contact: string;
	phone: string;
	province: string;
	city: string;
	district: string;
	address: string;
	isDefault: number;
}> {
	return request({
		url: "/app/user/address/info",
		method: "GET",
		data: { id }
	});
}

// 添加地址
export function addAddress(data: {
	contact: string;
	phone: string;
	province: string;
	city: string;
	district: string;
	address: string;
	isDefault?: number;
}): Promise<void> {
	return request({
		url: "/app/user/address/add",
		method: "POST",
		data
	});
}

// 更新地址
export function updateAddress(data: {
	id: number;
	contact?: string;
	phone?: string;
	province?: string;
	city?: string;
	district?: string;
	address?: string;
	isDefault?: number;
}): Promise<void> {
	return request({
		url: "/app/user/address/update",
		method: "POST",
		data
	});
}

// 删除地址
export function deleteAddress(ids: number[]): Promise<void> {
	return request({
		url: "/app/user/address/delete",
		method: "POST",
		data: { ids }
	});
}
