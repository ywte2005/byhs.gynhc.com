import { request } from "@/.cool/service";

export type PromoOverview = {
	level: {
		id: number;
		name: string;
		sort: number;
	} | null;
	relation: {
		invite_code: string;
		parent_id: number;
		depth: number;
	};
	wallet: {
		balance: string;
		deposit: string;
		frozen: string;
		total_income: string;
	};
	performance: {
		month: string;
		personal_total: string;
		team_total: string;
		growth: string;
		direct_count: number;
	};
	bonus: {
		total_bonus: string;
		month_bonus: string;
		qualified_rules: string[];
	};
};

export type PromoLevel = {
	id: number;
	name: string;
	sort: number;
	upgrade_type: string;
	upgrade_price: string;
	personal_performance_min: string;
	team_performance_min: string;
	direct_invite_min: number;
};

export type CommissionLog = {
	id: number;
	user_id: number;
	source_user_id: number;
	scene: string;
	reward_type: string;
	amount: string;
	status: string;
	createtime: number;
	remark: string;
};

export type WalletLog = {
	id: number;
	user_id: number;
	change_type: string;
	amount: string;
	before: string;
	after: string;
	biz_type: string;
	remark: string;
	createtime: number;
};

export type TeamMember = {
	id: number;
	user_id: number;
	level_id: number;
	invite_code: string;
	createtime: number;
};

export function getOverview(): Promise<PromoOverview> {
	return request({
		url: "/promo/overview",
		method: "GET",
	});
}

export function getLevels(): Promise<PromoLevel[]> {
	return request({
		url: "/promo/levels",
		method: "GET",
	});
}

export function purchaseLevel(levelId: number, payMethod: string = "balance"): Promise<object> {
	return request({
		url: "/promo/purchaseLevel",
		method: "POST",
		data: {
			level_id: levelId,
			pay_method: payMethod,
		},
	});
}

export function bindRelation(inviteCode: string): Promise<object> {
	return request({
		url: "/promo/bindRelation",
		method: "POST",
		data: {
			invite_code: inviteCode,
		},
	});
}

export function getMyInviteCode(): Promise<{ invite_code: string }> {
	return request({
		url: "/promo/myInviteCode",
		method: "GET",
	});
}

export function getMyTeam(page: number = 1, limit: number = 20): Promise<{ list: TeamMember[]; total: number }> {
	return request({
		url: "/promo/myTeam",
		method: "GET",
		data: { page, limit },
	});
}

export function getCommissionList(page: number = 1, limit: number = 20): Promise<{ list: CommissionLog[] }> {
	return request({
		url: "/promo/commissionList",
		method: "GET",
		data: { page, limit },
	});
}

export function getWalletLogs(page: number = 1, limit: number = 20): Promise<{ list: WalletLog[] }> {
	return request({
		url: "/promo/walletLogs",
		method: "GET",
		data: { page, limit },
	});
}

export function getPerformanceSummary(month: string): Promise<object> {
	return request({
		url: "/promo/performanceSummary",
		method: "GET",
		data: { month },
	});
}

export function getBonusSummary(): Promise<object> {
	return request({
		url: "/promo/bonusSummary",
		method: "GET",
	});
}

export function getBonusRecords(page: number = 1, limit: number = 20): Promise<{ list: object[] }> {
	return request({
		url: "/promo/bonusRecords",
		method: "GET",
		data: { page, limit },
	});
}
