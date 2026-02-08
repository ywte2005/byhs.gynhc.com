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
        
        $this->success('获取成功', ['merchant' => $merchant]);
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
        
        try {
            $merchant = MerchantService::register($userId, $data);
            $this->success('提交成功，等待审核', ['merchant' => $merchant]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
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
        
        try {
            $merchant = MerchantService::payEntryFee($userId, $payMethod);
            $this->success('支付成功', ['merchant' => $merchant]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function update()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        try {
            $merchant = MerchantService::updateMerchant($userId, $data);
            $this->success('更新成功', ['merchant' => $merchant]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }
}
