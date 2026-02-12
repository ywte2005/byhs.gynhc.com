<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\MerchantService;

class Merchant extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    public function info()
    {
        $userId = $this->auth->id;
        $merchant = MerchantService::getMerchant($userId);
        
        if (!$merchant) {
            $this->success('未注册商户', ['merchant' => null]);
        }
        
        // 获取统计数据
        $stats = $this->getMerchantStats($merchant->id);
        
        $data = [
            'id' => $merchant->id,
            'merchant_no' => $merchant->merchant_no,
            'type' => $merchant->type,
            'name' => $merchant->name,
            'legal_name' => $merchant->legal_name,
            'contact_phone' => $merchant->contact_phone,
            'contact_address' => $merchant->contact_address ?? '',
            'category' => $merchant->category ?? '',
            'status' => $merchant->status,
            'status_text' => $merchant->status_text,
            'id_card' => $merchant->id_card ? substr($merchant->id_card, 0, 6) . '********' . substr($merchant->id_card, -4) : '',
            'id_card_front' => $merchant->id_card_front ? cdnurl($merchant->id_card_front, true) : '',
            'id_card_back' => $merchant->id_card_back ? cdnurl($merchant->id_card_back, true) : '',
            'business_license' => $merchant->business_license ? cdnurl($merchant->business_license, true) : '',
            'credit_code' => $merchant->credit_code ?? '',
            'bank_name' => $merchant->bank_name ?? '',
            'bank_account' => $merchant->bank_account ? substr($merchant->bank_account, 0, 4) . '****' . substr($merchant->bank_account, -4) : '',
            'entry_fee' => $merchant->entry_fee,
            'entry_fee_paid' => $merchant->entry_fee_paid,
            'createtime' => date('Y-m-d H:i:s', $merchant->createtime),
            'approved_time' => $merchant->approved_time ? $merchant->approved_time : null, // 审核通过时间（Unix时间戳）
            'updatetime' => $merchant->updatetime ? $merchant->updatetime : null, // 更新时间（Unix时间戳）
            // 统计数据
            'total_tasks' => $stats['total_tasks'],
            'completed_tasks' => $stats['completed_tasks'],
            'completion_rate' => $stats['completion_rate'],
            'total_income' => $stats['total_income'],
            'total_commission' => $stats['total_commission'],
            'credit_score' => $stats['credit_score'],
            'level' => $stats['level'],
        ];
        
        $this->success('获取成功', ['merchant' => $data]);
    }
    
    /**
     * 获取商户统计数据
     */
    private function getMerchantStats($merchantId)
    {
        $totalTasks = 0;
        $completedTasks = 0;
        $totalIncome = 0;
        $totalCommission = 0;
        
        // 获取任务统计（表可能不存在）
        try {
            $totalTasks = \think\Db::name('task')->where('merchant_id', $merchantId)->count();
            $completedTasks = \think\Db::name('task')->where('merchant_id', $merchantId)->where('status', 'completed')->count();
        } catch (\Exception $e) {
            // 表不存在时使用默认值
        }
        
        $completionRate = $totalTasks > 0 ? round($completedTasks / $totalTasks * 100, 1) : 0;
        
        // 获取收入统计（表可能不存在）
        try {
            $merchant = \think\Db::name('merchant')->where('id', $merchantId)->find();
            if ($merchant) {
                $totalIncome = \think\Db::name('wallet_log')
                    ->where('user_id', $merchant['user_id'])
                    ->where('change_type', 'income')
                    ->sum('amount') ?: 0;
                    
                $totalCommission = \think\Db::name('wallet_log')
                    ->where('user_id', $merchant['user_id'])
                    ->where('biz_type', 'in', ['subtask_commission', 'service_fee'])
                    ->sum('amount') ?: 0;
            }
        } catch (\Exception $e) {
            // 表不存在时使用默认值
        }
        
        return [
            'total_tasks' => $totalTasks,
            'completed_tasks' => $completedTasks,
            'completion_rate' => $completionRate,
            'total_income' => number_format(abs($totalIncome), 2),
            'total_commission' => number_format(abs($totalCommission), 2),
            'credit_score' => 98, // TODO: 实现信用分计算
            'level' => 'VIP', // TODO: 实现等级计算
        ];
    }

    public function categories()
    {
        $tree = \app\common\model\MerchantCategory::getCategoryTree();
        $this->success('获取成功', ['list' => $tree]);
    }

    public function banks()
    {
        // 常用银行列表
        $banks = [
            ['code' => 'ICBC', 'name' => '中国工商银行'],
            ['code' => 'ABC', 'name' => '中国农业银行'],
            ['code' => 'BOC', 'name' => '中国银行'],
            ['code' => 'CCB', 'name' => '中国建设银行'],
            ['code' => 'COMM', 'name' => '交通银行'],
            ['code' => 'PSBC', 'name' => '中国邮政储蓄银行'],
            ['code' => 'CMB', 'name' => '招商银行'],
            ['code' => 'SPDB', 'name' => '浦发银行'],
            ['code' => 'CIB', 'name' => '兴业银行'],
            ['code' => 'CITIC', 'name' => '中信银行'],
            ['code' => 'CEB', 'name' => '光大银行'],
            ['code' => 'HXB', 'name' => '华夏银行'],
            ['code' => 'CMBC', 'name' => '民生银行'],
            ['code' => 'GDB', 'name' => '广发银行'],
            ['code' => 'PAB', 'name' => '平安银行'],
            ['code' => 'NBCB', 'name' => '宁波银行'],
            ['code' => 'BJBANK', 'name' => '北京银行'],
            ['code' => 'SHBANK', 'name' => '上海银行'],
        ];
        $this->success('获取成功', ['list' => $banks]);
    }

    public function register()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        // 根据主体类型设置不同的验证规则
        $type = isset($data['type']) ? $data['type'] : '';
        
        // 基础验证规则（商户入驻只需要基本信息和银行信息，不需要经营类目和地址）
        $rule = [
            'type' => 'require|in:personal,individual,enterprise',
            'name' => 'require|max:100',
            'id_card' => 'require',
            'contact' => 'require|max:50',
            'contact_phone' => 'require|mobile',
            'bank_name' => 'require',
            'bank_account' => 'require'
        ];
        
        // 根据主体类型添加附件验证规则
        if ($type === 'personal') {
            $rule['id_card_front'] = 'require';
            $rule['id_card_back'] = 'require';
        } else {
            $rule['business_license'] = 'require';
        }
        
        // 验证提示信息
        $message = [
            'type.require' => '请选择主体类型',
            'type.in' => '主体类型不正确',
            'name.require' => '请输入商户名称',
            'name.max' => '商户名称最多100个字符',
            'id_card.require' => '请输入身份证号',
            'contact.require' => '请输入法人姓名',
            'contact.max' => '法人姓名最多50个字符',
            'contact_phone.require' => '请输入联系电话',
            'contact_phone.mobile' => '联系电话格式不正确',
            'bank_name.require' => '请选择开户银行',
            'bank_account.require' => '请输入银行账号',
            'business_license.require' => '请上传营业执照',
            'id_card_front.require' => '请上传身份证正面',
            'id_card_back.require' => '请上传身份证反面'
        ];
        
        $validate = $this->validate($data, $rule, $message);
        if ($validate !== true) {
            $this->error($validate);
        }
        
        $merchant = MerchantService::register($userId, $data);
        $this->success('提交成功，等待审核', ['merchant' => $merchant]);
    }

    public function auditStatus()
    {
        $userId = $this->auth->id;
        $status = MerchantService::getAuditStatus($userId);
        $this->success('获取成功', $status);
    }

    public function payEntryFee()
    {
        $userId = $this->auth->id;
        $payMethod = $this->request->post('pay_method', 'balance');
        
        $merchant = MerchantService::payEntryFee($userId, $payMethod);
        $this->success('支付成功', ['merchant' => $merchant]);
    }

    public function update()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        $merchant = MerchantService::updateMerchant($userId, $data);
        $this->success('更新成功', ['merchant' => $merchant]);
    }
}
