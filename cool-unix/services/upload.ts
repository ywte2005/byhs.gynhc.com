import { config } from "@/config";

/**
 * 上传服务
 */

// 上传文件
export function uploadFile(filePath: string): Promise<{ url: string; fullurl: string }> {
	return new Promise((resolve, reject) => {
		const token = uni.getStorageSync('token') || ''
		const uploadUrl = config.baseUrl + '/common/upload'
		
		uni.uploadFile({
			url: uploadUrl,
			filePath: filePath,
			name: 'file',
			header: {
				token: token
			},
			success: (res) => {
				try {
					const data = JSON.parse(res.data)
					if (data.code === 1) {
						resolve(data.data)
					} else {
						reject(new Error(data.msg || '上传失败'))
					}
				} catch (err) {
					reject(new Error('上传响应解析失败'))
				}
			},
			fail: (err) => {
				reject(err)
			}
		})
	})
}

// 上传结果类型
export interface UploadResult {
	url: string      // 相对路径，用于提交给后端
	fullurl: string  // 完整URL，用于前端展示
}

// 批量上传文件
export async function uploadFiles(filePaths: string[]): Promise<UploadResult[]> {
	const results: UploadResult[] = []
	for (const filePath of filePaths) {
		if (filePath) {
			const result = await uploadFile(filePath)
			results.push(result)
		}
	}
	return results
}
