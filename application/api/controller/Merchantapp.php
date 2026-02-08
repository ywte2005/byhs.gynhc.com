<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\model\merchant\MerchantApplication as ApplicationModel;
use app\common\model\merchant\Merchant;

/**
 * 商户进件申请接口
 */
class Merchantapp extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    /**
     * 获取进件列表
     */
    public function list()
    {
        $userId = $this->auth->id;
        $status = $this->request->get('status', 'all');
        $page = $this->request->get('page', 1);
        $pageSize = $this->request->get('page_size', 10);
        
        $result = ApplicationModel::getListByUser($userId, $status, $page, $pageSize);
        
        $this->success('获取成功', $result);
    }

    /**
     * 获取进件详情
     */
    public function detail()
    {
        $userId = $this->auth->id;
        $id = $this->request->get('id');
        
        if (!$id) {
            $this->error('参数错误');
        }
        
        $application = ApplicationModel::where('id', $id)
            ->where('user_id', $userId)
            ->find();
        
        if (!$application) {
            $this->error('进件不存在');
        }
        
        $this->success('获取成功', ['application' => $application]);
    }

    /**
     * 提交进件申请
     */
    public function submit()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        // 检查用户是否已是商户
        $merchant = Merchant::getByUserId($userId);
        if (!$merchant) {
            $this->error('请先完成商户入驻');
        }
        
        if ($merchant->status !== 'approved') {
            $this->error('商户审核未通过，无法提交进件');
        }
        
        // 验证规则
        $rule = [
            'type' => 'require|in:personal,individual,enterprise',
            'name' => 'require|max:100',
            'id_card' => 'require',
            'contact_name|contact' => 'require|max:50',
            'contact_phone' => 'require|mobile',
            'category' => 'require',
            'category_code' => 'require',
            'address' => 'require'
        ];
        
        $message = [
            'type.require' => '请选择主体类型',
            'type.in' => '主体类型不正确',
            'name.require' => '请输入主体名称',
            'name.max' => '主体名称最多100个字符',
            'id_card.require' => '请输入证件号码',
            'contact_name.require' => '请输入联系人姓名',
            'contact.require' => '请输入联系人姓名',
            'contact_name.max' => '联系人姓名最多50个字符',
            'contact.max' => '联系人姓名最多50个字符',
            'contact_phone.require' => '请输入联系电话',
            'contact_phone.mobile' => '联系电话格式不正确',
            'category.require' => '请选择经营类目',
            'category_code.require' => '请选择经营类目',
            'address.require' => '请选择经营地址'
        ];
        
        $validate = $this->validate($data, $rule, $message);
        if ($validate !== true) {
            $this->error($validate);
        }
        
        $application = ApplicationModel::submit($userId, $merchant->id, $data);
        if (!$application) {
            $this->error('提交失败');
        }
        $this->success('提交成功，等待审核', ['application' => $application]);
    }

    /**
     * 重新提交进件（被驳回后）
     */
    public function resubmit()
    {
        $userId = $this->auth->id;
        $id = $this->request->post('id');
        $data = $this->request->post();
        
        if (!$id) {
            $this->error('参数错误');
        }
        
        $application = ApplicationModel::where('id', $id)
            ->where('user_id', $userId)
            ->find();
        
        if (!$application) {
            $this->error('进件不存在');
        }
        
        if ($application->status !== 'rejected') {
            $this->error('只有被驳回的进件才能重新提交');
        }
        
        // 更新进件信息
        $application->type = $data['type'] ?? $application->type;
        $application->name = $data['name'] ?? $application->name;
        $application->id_card = $data['id_card'] ?? $application->id_card;
        $application->contact_name = $data['contact_name'] ?? $data['contact'] ?? $application->contact_name;
        $application->contact_phone = $data['contact_phone'] ?? $application->contact_phone;
        $application->category = $data['category'] ?? $application->category;
        $application->category_code = $data['category_code'] ?? $application->category_code;
        $application->address = $data['address'] ?? $application->address;
        $application->business_license = $data['business_license'] ?? $application->business_license;
        $application->id_card_front = $data['id_card_front'] ?? $application->id_card_front;
        $application->id_card_back = $data['id_card_back'] ?? $application->id_card_back;
        $application->shop_front = $data['shop_front'] ?? $application->shop_front;
        $application->other_files = $data['other_files'] ?? $application->other_files;
        $application->status = 'pending';
        $application->reject_reason = '';
        $application->save();
        
        $this->success('重新提交成功，等待审核', ['application' => $application]);
    }
}
