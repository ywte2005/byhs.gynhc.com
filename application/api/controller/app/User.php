<?php

namespace app\api\controller\app;

use app\common\controller\Api;
use think\Db;

/**
 * 用户接口（RESTful风格）
 */
class User extends Api
{
    protected $noNeedLogin = ['login'];
    protected $noNeedRight = '*';

    /**
     * 获取用户信息
     */
    public function info()
    {
        $action = $this->request->param('action', 'person');
        
        if ($action === 'person') {
            return $this->getPerson();
        } elseif ($action === 'updatePerson') {
            return $this->updatePerson();
        }
        
        $this->error('无效的操作');
    }

    /**
     * 获取个人信息
     */
    protected function getPerson()
    {
        $userInfo = $this->auth->getUserinfo();
        $this->success('获取成功', $userInfo);
    }

    /**
     * 更新个人信息
     */
    protected function updatePerson()
    {
        if (!$this->request->isPost()) {
            $this->error('请使用POST请求');
        }

        $user = $this->auth->getUser();
        $data = $this->request->post();

        // 允许更新的字段
        $allowFields = ['nickname', 'avatar', 'bio'];
        
        foreach ($allowFields as $field) {
            if (isset($data[$field])) {
                $user->$field = $data[$field];
            }
        }

        $user->save();
        $this->success('更新成功');
    }

    /**
     * 用户登录
     */
    public function login()
    {
        $action = $this->request->param('action');
        
        if ($action === 'phone') {
            return $this->phoneLogin();
        } elseif ($action === 'captcha') {
            return $this->getCaptcha();
        } elseif ($action === 'smsCode') {
            return $this->sendSmsCode();
        } elseif ($action === 'refreshToken') {
            return $this->refreshToken();
        } elseif ($action === 'mini') {
            return $this->miniLogin();
        }
        
        $this->error('无效的登录方式');
    }

    /**
     * 手机号登录
     */
    protected function phoneLogin()
    {
        $phone = $this->request->post('phone');
        $smsCode = $this->request->post('smsCode');

        if (!$phone || !$smsCode) {
            $this->error('参数错误', null, 1001);
        }

        // 验证手机号格式
        if (!\think\Validate::regex($phone, "^1\d{10}$")) {
            $this->error('手机号格式不正确', null, 1002);
        }

        // 验证短信验证码
        if (!\app\common\library\Sms::check($phone, $smsCode, 'mobilelogin')) {
            $this->error('验证码不正确或已过期', null, 1002);
        }

        // 查找用户
        $user = \app\common\model\User::getByMobile($phone);
        
        if ($user) {
            // 用户已存在，直接登录
            if ($user->status != 'normal') {
                $this->error('账号已被锁定', null, 3001);
            }
            $ret = $this->auth->direct($user->id);
        } else {
            // 用户不存在，自动注册
            $ret = $this->auth->register($phone, \fast\Random::alnum(), '', $phone, []);
        }

        if ($ret) {
            // 清除验证码
            \app\common\library\Sms::flush($phone, 'mobilelogin');
            
            // 返回用户信息和token
            $userInfo = $this->auth->getUserinfo();
            $this->success('登录成功', [
                'token' => $userInfo['token'],
                'expire' => 7200,
                'refreshToken' => $userInfo['token'], // 简化处理，实际应该生成refresh token
                'refreshExpire' => 2592000, // 30天
                'userinfo' => $userInfo
            ]);
        } else {
            $this->error($this->auth->getError() ?: '登录失败', null, 5001);
        }
    }

    /**
     * 获取图片验证码
     */
    protected function getCaptcha()
    {
        $phone = $this->request->param('phone');
        $width = $this->request->param('width', 200);
        $height = $this->request->param('height', 70);
        $color = $this->request->param('color', '#2c3142');

        if (!$phone) {
            $this->error('请提供手机号', null, 1001);
        }

        // 生成验证码
        $captcha = new \think\captcha\Captcha([
            'length' => 4,
            'useNoise' => false,
            'fontSize' => 30,
            'imageW' => $width,
            'imageH' => $height,
            'bg' => [255, 255, 255],
        ]);

        // 生成验证码ID
        $captchaId = md5($phone . time() . mt_rand());
        
        // 生成验证码图片
        ob_start();
        $captcha->entry();
        $imageData = ob_get_clean();
        
        // 将验证码保存到session或缓存
        $code = $captcha->getCode();
        cache($captchaId, $code, 300); // 5分钟有效期

        // 返回base64编码的图片
        $base64 = 'data:image/png;base64,' . base64_encode($imageData);

        $this->success('获取成功', [
            'captchaId' => $captchaId,
            'data' => $base64
        ]);
    }

    /**
     * 发送短信验证码
     */
    protected function sendSmsCode()
    {
        $phone = $this->request->post('phone');
        $code = $this->request->post('code');
        $captchaId = $this->request->post('captchaId');

        if (!$phone || !$code || !$captchaId) {
            $this->error('参数错误', null, 1001);
        }

        // 验证图片验证码
        $cachedCode = cache($captchaId);
        if (!$cachedCode || strtolower($code) !== strtolower($cachedCode)) {
            $this->error('图片验证码不正确', null, 1002);
        }

        // 验证手机号格式
        if (!\think\Validate::regex($phone, "^1\d{10}$")) {
            $this->error('手机号格式不正确', null, 1002);
        }

        // 检查发送频率
        $last = \app\common\library\Sms::get($phone, 'mobilelogin');
        if ($last && time() - $last['createtime'] < 60) {
            $this->error('发送过于频繁，请稍后再试', null, 3001);
        }

        // 检查IP发送次数
        $ipSendTotal = \app\common\model\Sms::where(['ip' => $this->request->ip()])
            ->whereTime('createtime', '-1 hours')
            ->count();
        if ($ipSendTotal >= 5) {
            $this->error('发送过于频繁，请稍后再试', null, 3001);
        }

        // 发送短信
        $ret = \app\common\library\Sms::send($phone, null, 'mobilelogin');
        if ($ret) {
            // 清除图片验证码
            cache($captchaId, null);
            $this->success('短信已发送');
        } else {
            $this->error('短信发送失败，请稍后重试', null, 5001);
        }
    }

    /**
     * 刷新Token
     */
    protected function refreshToken()
    {
        $refreshToken = $this->request->post('refreshToken');

        if (!$refreshToken) {
            $this->error('参数错误', null, 1001);
        }

        // 简化处理：验证token并返回新token
        // 实际应该验证refreshToken的有效性
        $userInfo = $this->auth->getUserinfo();
        
        if (!$userInfo) {
            $this->error('Token已失效，请重新登录', null, 401);
        }

        $this->success('刷新成功', [
            'token' => $userInfo['token'],
            'expire' => 7200,
            'refreshToken' => $userInfo['token'],
            'refreshExpire' => 2592000
        ]);
    }

    /**
     * 微信小程序登录
     */
    protected function miniLogin()
    {
        $code = $this->request->post('code');
        $encryptedData = $this->request->post('encryptedData');
        $iv = $this->request->post('iv');

        if (!$code) {
            $this->error('参数错误', null, 1001);
        }

        // TODO: 实现微信小程序登录逻辑
        // 1. 使用code换取openid和session_key
        // 2. 解密用户信息
        // 3. 查找或创建用户
        // 4. 返回token

        $this->error('微信小程序登录功能待实现', null, 5001);
    }
}
