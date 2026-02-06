import { request } from "@/.cool/service";

/**
 * 首页服务
 */

// 获取首页统计数据
export function getStatistics(): Promise<{
	wallet: {
		balance: number;
		frozen: number;
		pending: number;
	};
	todo: {
		pending_merchant: number;
		pending_task: number;
		pending_withdraw: number;
	};
	today: {
		accepted: number;
		completed: number;
		income: number;
	};
	news: Array<{
		id: number;
		title: string;
		type: string;
		createtime: number;
	}>;
}> {
	return request({
		url: "/index/statistics",
		method: "GET"
	});
}
