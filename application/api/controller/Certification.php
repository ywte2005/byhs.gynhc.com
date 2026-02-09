<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\model\Certification as CertificationModel;

/**
 * 实名认证接口
 */
class Certification extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    /**
     * 获取认证状态
     */
    public function status()
    {
        $userId = $this->auth->id;
        $certification = CertificationModel::getByUserId($userId);
        
        if (!$certification) {
            $this->success('未提交认证', [
                'status' => 'none',
                'message' => '未提交认证申请'
            ]);
        }
        
        $data = [
            'id' => $certification->id,
            'status' => $certification->status,
            'status_text' => $certification->status_text,
            'type' => $certification->type,
            'type_text' => $certification->type_text,
            'name' => $certification->name,
            'id_card' => $certification->id_card ? substr($certification->id_card, 0, 6) . '********' . substr($certification->id_card, -4) : '',
            'reject_reason' => $certification->reject_reason ?? '',
            'createtime' => date('Y-m-d H:i:s', $certification->createtime),
            'audit_time' => $certification->audit_time ? date('Y-m-d H:i:s', $certification->audit_time) : ''
        ];
        
        $this->success('获取成功', $data);
    }

    /**
     * 提交认证申请
     */
    public function submit()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        // 验证规则
        $rule = [
            'type' => 'require|in:personal,enterprise',
            'name' => 'require|max:50',
            'id_card' => 'require|length:18',
            'id_card_front' => 'require',
            'id_card_back' => 'require',
            'contact_phone' => 'require|mobile'
        ];
        
        // 企业认证额外验证
        if (isset($data['type']) && $data['type'] === 'enterprise') {
            $rule['enterprise_name'] = 'require|max:100';
            $rule['credit_code'] = 'require|length:18';
            $rule['business_license'] = 'require';
        }
        
        $message = [
            'type.require' => '请选择认证类型',
            'type.in' => '认证类型不正确',
            'name.require' => '请输入真实姓名',
            'name.max' => '姓名最多50个字符',
            'id_card.require' => '请输入身份证号',
            'id_card.length' => '身份证号格式不正确',
            'id_card_front.require' => '请上传身份证正面照片',
            'id_card_back.require' => '请上传身份证反面照片',
            'contact_phone.require' => '请输入联系电话',
            'contact_phone.mobile' => '联系电话格式不正确',
            'enterprise_name.require' => '请输入企业名称',
            'enterprise_name.max' => '企业名称最多100个字符',
            'credit_code.require' => '请输入统一社会信用代码',
            'credit_code.length' => '统一社会信用代码格式不正确',
            'business_license.require' => '请上传营业执照'
        ];
        
        $validate = $this->validate($data, $rule, $message);
        if ($validate !== true) {
            $this->error($validate);
        }
        
        try {
            $certification = CertificationModel::submit($userId, $data);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
        
        $this->success('提交成功，等待审核', [
            'id' => $certification->id,
            'status' => $certification->status
        ]);
    }

    /**
     * 获取认证详情
     */
    public function detail()
    {
        $userId = $this->auth->id;
        $certification = CertificationModel::getByUserId($userId);
        
        if (!$certification) {
            $this->error('未找到认证记录');
        }
        
        $data = [
            'id' => $certification->id,
            'type' => $certification->type,
            'type_text' => $certification->type_text,
            'name' => $certification->name,
            'id_card' => $certification->id_card ? substr($certification->id_card, 0, 6) . '********' . substr($certification->id_card, -4) : '',
            'id_card_front' => $certification->id_card_front ? cdnurl($certification->id_card_front, true) : '',
            'id_card_back' => $certification->id_card_back ? cdnurl($certification->id_card_back, true) : '',
            'contact_phone' => $certification->contact_phone,
            'enterprise_name' => $certification->enterprise_name ?? '',
            'credit_code' => $certification->credit_code ?? '',
            'business_license' => $certification->business_license ? cdnurl($certification->business_license, true) : '',
            'status' => $certification->status,
            'status_text' => $certification->status_text,
            'reject_reason' => $certification->reject_reason ?? '',
            'createtime' => date('Y-m-d H:i:s', $certification->createtime),
            'audit_time' => $certification->audit_time ? date('Y-m-d H:i:s', $certification->audit_time) : ''
        ];
        
        $this->success('获取成功', $data);
    }
}
