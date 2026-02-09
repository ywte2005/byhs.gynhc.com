import { computed, ref } from "vue";
import { forInObject, isNull, isObject, parse, storage } from "../utils";
import { router } from "../router";
import { request } from "../service";
import type { UserInfo } from "../types";

export type Token = {
	token: string; // 访问token
	expire: number; // token过期时间（秒）
	refreshToken: string; // 刷新token
	refreshExpire: number; // 刷新token过期时间（秒）
};

export class User {
	/**
	 * 用户信息，响应式对象
	 */
	info = ref<UserInfo | null>(null);

	/**
	 * 当前token，字符串或null
	 */
	token: string | null = null;

	constructor() {
		// 获取本地用户信息
		const userInfo = storage.get("userInfo");

		// 获取本地token
		const token = storage.get("token") as string | null;

		// 如果token为空字符串则置为null
		this.token = token == "" ? null : token;

		// 初始化用户信息
		if (userInfo != null && isObject(userInfo)) {
			this.set(userInfo);
		}
	}

	/**
	 * 登录
	 * @param form 登录表单
	 */
	async login(form: any) {
		const res: any = await request({
			url: "/user/login",
			method: "POST",
			data: {
				account: form.phone,
				password: form.password
			}
		});

		// request 函数已经处理了响应，成功时返回 data，失败时 reject
		// 后端返回的是 { userinfo: {...} }
		if (res != null) {
			const userinfo = res.userinfo || res;
			
			this.setToken({
				token: userinfo.token,
				expire: userinfo.expire || 86400,
				refreshToken: userinfo.refreshToken || userinfo.token,
				refreshExpire: userinfo.refreshExpire || 604800
			});

			await this.get();
		}
	}

	/**
	 * 获取用户信息（从服务端拉取最新信息并更新本地）
	 * @returns Promise<void>
	 */
	async get() {
		if (this.token != null) {
			await request({
				url: "/user/person"
			})
				.then((res) => {
					if (res != null) {
						this.set(res);
					}
				})
				.catch(() => {
					// this.logout();
				});
		}
	}

	/**
	 * 设置用户信息并存储到本地
	 * @param data 用户信息对象
	 */
	set(data: any) {
		if (isNull(data)) {
			return;
		}

		// 设置
		this.info.value = parse<UserInfo>(data)!;

		// 持久化到本地存储
		storage.set("userInfo", data, 0);
	}

	/**
	 * 更新用户信息（本地与服务端同步）
	 * @param data 新的用户信息
	 */
	async update(data: any) {
		if (isNull(data) || isNull(this.info.value)) {
			return;
		}

		// 本地同步更新
		forInObject(data, (value, key) => {
			this.info.value![key] = value;
		});

		// 转换字段名适配后端API
		const postData: any = {};
		if (data.nickName !== undefined) postData.nickname = data.nickName;
		if (data.avatarUrl !== undefined) postData.avatar = data.avatarUrl;
		if (data.description !== undefined) postData.bio = data.description;
		if (data.gender !== undefined) postData.gender = data.gender;
		if (data.birthday !== undefined) postData.birthday = data.birthday;
		if (data.province !== undefined) postData.province = data.province;
		if (data.city !== undefined) postData.city = data.city;
		if (data.district !== undefined) postData.district = data.district;

		// 同步到服务端
		await request({
			url: "/user/profile",
			method: "POST",
			data: postData
		});
	}

	/**
	 * 移除用户信息
	 */
	remove() {
		this.info.value = null;
		storage.remove("userInfo");
	}

	/**
	 * 判断用户信息是否为空
	 * @returns boolean
	 */
	isNull() {
		return this.info.value == null;
	}

	/**
	 * 清除本地所有用户信息和token
	 */
	clear() {
		storage.remove("userInfo");
		storage.remove("token");
		storage.remove("refreshToken");
		this.token = null;
		this.remove();
	}

	/**
	 * 退出登录，清除所有信息并跳转到登录页
	 */
	logout() {
		this.clear();
		router.login();
	}

	/**
	 * 设置token并存储到本地
	 * @param data Token对象
	 */
	setToken(data: Token) {
		this.token = data.token;

		// 访问token，提前5秒过期，防止边界问题
		storage.set("token", data.token, data.expire - 5);
		// 刷新token，提前5秒过期
		storage.set("refreshToken", data.refreshToken, data.refreshExpire - 5);
	}

	/**
	 * 刷新token（调用服务端接口，自动更新本地token）
	 * @returns Promise<string> 新的token
	 */
	refreshToken(): Promise<string> {
		return new Promise((resolve, reject) => {
			request({
				url: "/app/user/login/refreshToken",
				method: "POST",
				data: {
					refreshToken: storage.get("refreshToken")
				}
			})
				.then((res) => {
					// request 函数已经返回 data，所以 res 就是 token 对象
					if (res != null && res.token) {
						this.setToken(res as Token);
						resolve(res.token);
					} else {
						reject(new Error("刷新token失败"));
					}
				})
				.catch((err) => {
					reject(err);
				});
		});
	}
}

/**
 * 单例用户对象，项目全局唯一
 */
export const user = new User();

/**
 * 用户信息，响应式对象
 */
export const userInfo = computed(() => user.info.value);
