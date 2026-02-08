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

    public function register()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        $rule = [
            'name' => 'require|max:100',
            'legal_name' => 'require|max:50',
            'id_card' => 'require|length:18',
            'contact_phone' => 'require|mobile'
        ];
        
        $validate = $this->validate($data, $rule);
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
