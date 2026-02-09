<?php

namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\Ems;
use app\common\library\Sms;
use fast\Random;
use think\Config;
use think\Validate;

/**
 * 会员接口
 */
class User extends Api
{
    protected $noNeedLogin = ['login', 'mobilelogin', 'register', 'resetpwd', 'changeemail', 'changemobile', 'third', 'wechatLogin', 'wechatMiniLogin', 'getWechatConfig'];
    protected $noNeedRight = '*';

    public function _initialize()
    {
        parent::_initialize();

        if (!Config::get('fastadmin.usercenter')) {
            $this->error(__('User center already closed'));
        }

    }

    /**
     * 会员中心
     */
    public function index()
    {
        $this->success('', ['welcome' => $this->auth->nickname]);
    }

    /**
     * 获取用户个人信息
     */
    public function person()
    {
        $user = $this->auth->getUser();
        
        // 检查是否已实名认证（通过Certification表判断）
        $certification = \app\common\model\Certification::getByUserId($user->id);
        $isVerified = $certification && $certification->status === 'approved';
        
        // 检查是否为商户
        $merchant = \app\common\model\merchant\Merchant::getByUserId($user->id);
        $isMerchant = $merchant && $merchant->status === 'approved';
        $merchantStatus = $merchant ? $merchant->status : 'none';
        
        // 安全获取用户扩展字段（可能不存在于数据库中）
        $userData = $user->getData();
        
        $data = [
            'id' => $user->id,
            'unionid' => $user->id, // 使用id作为unionid
            'nickName' => $user->nickname ?: $user->username,
            'avatarUrl' => $user->avatar ?: '',
            'phone' => $user->mobile ?: '',
            'gender' => isset($userData['gender']) ? $userData['gender'] : 0,
            'status' => $user->status == 'normal' ? 1 : 0,
            'description' => $user->bio ?: '',
            'loginType' => 1,
            'province' => isset($userData['province']) ? $userData['province'] : '',
            'city' => isset($userData['city']) ? $userData['city'] : '',
            'district' => isset($userData['district']) ? $userData['district'] : '',
            'birthday' => isset($userData['birthday']) ? $userData['birthday'] : '',
            'isVerified' => $isVerified,
            'isMerchant' => $isMerchant,
            'merchantStatus' => $merchantStatus,
            'createTime' => date('Y-m-d H:i:s', $user->createtime),
            'updateTime' => date('Y-m-d H:i:s', $user->updatetime)
        ];
        
        $this->success('获取成功', $data);
    }

    /**
     * 会员登录
     *
     * @ApiMethod (POST)
     * @ApiParams (name="account", type="string", required=true, description="账号")
     * @ApiParams (name="password", type="string", required=true, description="密码")
     */
    public function login()
    {
        $account = $this->request->post('account');
        $password = $this->request->post('password');
        if (!$account || !$password) {
            $this->error(__('Invalid parameters'));
        }
        $ret = $this->auth->login($account, $password);
        if ($ret) {
            $data = ['userinfo' => $this->auth->getUserinfo()];
            $this->success(__('Logged in successful'), $data);
        } else {
            $this->error($this->auth->getError());
        }
    }

    /**
     * 手机验证码登录
     *
     * @ApiMethod (POST)
     * @ApiParams (name="mobile", type="string", required=true, description="手机号")
     * @ApiParams (name="captcha", type="string", required=true, description="验证码")
     * @ApiParams (name="phone", type="string", required=false, description="手机号(兼容前端)")
     * @ApiParams (name="smsCode", type="string", required=false, description="验证码(兼容前端)")
     */
    public function mobilelogin()
    {
        // 兼容两种参数名
        $mobile = $this->request->post('mobile') ?: $this->request->post('phone');
        $captcha = $this->request->post('captcha') ?: $this->request->post('smsCode');
        
        if (!$mobile || !$captcha) {
            $this->error('参数错误', null, 1001);
        }
        if (!Validate::regex($mobile, "^1\d{10}$")) {
            $this->error('手机号格式不正确', null, 1002);
        }
        
        // 测试环境：允许使用固定验证码 6666
        $isTestCode = ($captcha === '6666' && config('app_debug'));
        
        if (!$isTestCode && !Sms::check($mobile, $captcha, 'mobilelogin')) {
            $this->error('验证码不正确或已过期', null, 1002);
        }
        
        $user = \app\common\model\User::getByMobile($mobile);
        if ($user) {
            if ($user->status != 'normal') {
                $this->error('账号已被锁定', null, 3001);
            }
            //如果已经有账号则直接登录
            $ret = $this->auth->direct($user->id);
        } else {
            $ret = $this->auth->register($mobile, Random::alnum(), '', $mobile, []);
        }
        if ($ret) {
            if (!$isTestCode) {
                Sms::flush($mobile, 'mobilelogin');
            }
            $userInfo = $this->auth->getUserinfo();
            
            // 返回格式兼容前端
            $data = [
                'token' => $userInfo['token'],
                'expire' => 7200,
                'refreshToken' => $userInfo['token'],
                'refreshExpire' => 2592000,
                'userinfo' => $userInfo
            ];
            $this->success('登录成功', $data);
        } else {
            $this->error($this->auth->getError() ?: '登录失败', null, 5001);
        }
    }

    /**
     * 注册会员
     *
     * @ApiMethod (POST)
     * @ApiParams (name="username", type="string", required=true, description="用户名")
     * @ApiParams (name="password", type="string", required=true, description="密码")
     * @ApiParams (name="email", type="string", required=true, description="邮箱")
     * @ApiParams (name="mobile", type="string", required=true, description="手机号")
     * @ApiParams (name="code", type="string", required=true, description="验证码")
     */
    public function register()
    {
        $username = $this->request->post('username');
        $password = $this->request->post('password');
        $email = $this->request->post('email');
        $mobile = $this->request->post('mobile');
        $code = $this->request->post('code');
        if (!$username || !$password) {
            $this->error(__('Invalid parameters'));
        }
        if ($email && !Validate::is($email, "email")) {
            $this->error(__('Email is incorrect'));
        }
        if ($mobile && !Validate::regex($mobile, "^1\d{10}$")) {
            $this->error(__('Mobile is incorrect'));
        }
        $ret = Sms::check($mobile, $code, 'register');
        if (!$ret) {
            $this->error(__('Captcha is incorrect'));
        }
        $ret = $this->auth->register($username, $password, $email, $mobile, []);
        if ($ret) {
            $data = ['userinfo' => $this->auth->getUserinfo()];
            $this->success(__('Sign up successful'), $data);
        } else {
            $this->error($this->auth->getError());
        }
    }

    /**
     * 退出登录
     * @ApiMethod (POST)
     */
    public function logout()
    {
        if (!$this->request->isPost()) {
            $this->error(__('Invalid parameters'));
        }
        $this->auth->logout();
        $this->success(__('Logout successful'));
    }

    /**
     * 修改会员个人信息
     *
     * @ApiMethod (POST)
     * @ApiParams (name="avatar", type="string", required=false, description="头像地址")
     * @ApiParams (name="username", type="string", required=false, description="用户名")
     * @ApiParams (name="nickname", type="string", required=false, description="昵称")
     * @ApiParams (name="bio", type="string", required=false, description="个人简介")
     * @ApiParams (name="gender", type="integer", required=false, description="性别 0保密 1男 2女")
     * @ApiParams (name="birthday", type="string", required=false, description="生日 YYYY-MM-DD")
     * @ApiParams (name="province", type="string", required=false, description="省份")
     * @ApiParams (name="city", type="string", required=false, description="城市")
     * @ApiParams (name="district", type="string", required=false, description="区县")
     */
    public function profile()
    {
        $user = $this->auth->getUser();
        $username = $this->request->post('username');
        $nickname = $this->request->post('nickname');
        $bio = $this->request->post('bio');
        $avatar = $this->request->post('avatar', '', 'trim,strip_tags,htmlspecialchars');
        $gender = $this->request->post('gender');
        $birthday = $this->request->post('birthday');
        $province = $this->request->post('province');
        $city = $this->request->post('city');
        $district = $this->request->post('district');
        
        if ($username) {
            $exists = \app\common\model\User::where('username', $username)->where('id', '<>', $this->auth->id)->find();
            if ($exists) {
                $this->error(__('Username already exists'));
            }
            $user->username = $username;
        }
        if ($nickname) {
            $exists = \app\common\model\User::where('nickname', $nickname)->where('id', '<>', $this->auth->id)->find();
            if ($exists) {
                $this->error(__('Nickname already exists'));
            }
            $user->nickname = $nickname;
        }
        if ($bio !== null) {
            $user->bio = $bio;
        }
        if ($avatar) {
            $user->avatar = $avatar;
        }
        // 使用setData安全设置可能不存在的字段
        $extendFields = [];
        if ($gender !== null) {
            $extendFields['gender'] = intval($gender);
        }
        if ($birthday !== null) {
            $extendFields['birthday'] = $birthday;
        }
        if ($province !== null) {
            $extendFields['province'] = $province;
        }
        if ($city !== null) {
            $extendFields['city'] = $city;
        }
        if ($district !== null) {
            $extendFields['district'] = $district;
        }
        
        // 尝试更新扩展字段（如果数据库字段存在）
        if (!empty($extendFields)) {
            try {
                \think\Db::name('user')->where('id', $user->id)->update($extendFields);
            } catch (\Exception $e) {
                // 字段不存在时忽略错误
            }
        }
        
        $user->save();
        $this->success('修改成功');
    }

    /**
     * 修改邮箱
     *
     * @ApiMethod (POST)
     * @ApiParams (name="email", type="string", required=true, description="邮箱")
     * @ApiParams (name="captcha", type="string", required=true, description="验证码")
     */
    public function changeemail()
    {
        $user = $this->auth->getUser();
        $email = $this->request->post('email');
        $captcha = $this->request->post('captcha');
        if (!$email || !$captcha) {
            $this->error(__('Invalid parameters'));
        }
        if (!Validate::is($email, "email")) {
            $this->error(__('Email is incorrect'));
        }
        if (\app\common\model\User::where('email', $email)->where('id', '<>', $user->id)->find()) {
            $this->error(__('Email already exists'));
        }
        $result = Ems::check($email, $captcha, 'changeemail');
        if (!$result) {
            $this->error(__('Captcha is incorrect'));
        }
        $verification = $user->verification;
        $verification->email = 1;
        $user->verification = $verification;
        $user->email = $email;
        $user->save();

        Ems::flush($email, 'changeemail');
        $this->success();
    }

    /**
     * 修改手机号
     *
     * @ApiMethod (POST)
     * @ApiParams (name="mobile", type="string", required=true, description="手机号")
     * @ApiParams (name="captcha", type="string", required=true, description="验证码")
     */
    public function changemobile()
    {
        $user = $this->auth->getUser();
        $mobile = $this->request->post('mobile');
        $captcha = $this->request->post('captcha');
        if (!$mobile || !$captcha) {
            $this->error(__('Invalid parameters'));
        }
        if (!Validate::regex($mobile, "^1\d{10}$")) {
            $this->error(__('Mobile is incorrect'));
        }
        if (\app\common\model\User::where('mobile', $mobile)->where('id', '<>', $user->id)->find()) {
            $this->error(__('Mobile already exists'));
        }
        $result = Sms::check($mobile, $captcha, 'changemobile');
        if (!$result) {
            $this->error(__('Captcha is incorrect'));
        }
        $verification = $user->verification;
        $verification->mobile = 1;
        $user->verification = $verification;
        $user->mobile = $mobile;
        $user->save();

        Sms::flush($mobile, 'changemobile');
        $this->success();
    }

    /**
     * 第三方登录
     *
     * @ApiMethod (POST)
     * @ApiParams (name="platform", type="string", required=true, description="平台名称")
     * @ApiParams (name="code", type="string", required=true, description="Code码")
     */
    public function third()
    {
        $url = url('user/index');
        $platform = $this->request->post("platform");
        $code = $this->request->post("code");
        $config = get_addon_config('third');
        if (!$config || !isset($config[$platform])) {
            $this->error(__('Invalid parameters'));
        }
        $app = new \addons\third\library\Application($config);
        //通过code换access_token和绑定会员
        $result = $app->{$platform}->getUserInfo(['code' => $code]);
        if ($result) {
            $loginret = \addons\third\library\Service::connect($platform, $result);
            if ($loginret) {
                $data = [
                    'userinfo'  => $this->auth->getUserinfo(),
                    'thirdinfo' => $result
                ];
                $this->success(__('Logged in successful'), $data);
            }
        }
        $this->error(__('Operation failed'), $url);
    }

    /**
     * 获取微信登录配置
     * 
     * @ApiMethod (GET)
     */
    public function getWechatConfig()
    {
        $config = get_addon_config('third');
        if (!$config) {
            $this->error('第三方登录未配置');
        }
        
        $data = [
            'h5_appid' => $config['wechat']['app_id'] ?? '',
            'mini_appid' => $config['wechatmini']['app_id'] ?? '',
        ];
        
        $this->success('获取成功', $data);
    }

    /**
     * 微信登录（APP/H5端）
     * 
     * @ApiMethod (POST)
     * @ApiParams (name="code", type="string", required=true, description="微信授权code")
     * @ApiParams (name="platform", type="string", required=false, description="平台：app/h5，默认app")
     */
    public function wechatLogin()
    {
        $code = $this->request->post('code');
        $platform = $this->request->post('platform', 'app');
        
        if (!$code) {
            $this->error(__('Invalid parameters'));
        }
        
        $config = get_addon_config('third');
        if (!$config) {
            $this->error('第三方登录未配置');
        }
        
        // 根据平台选择配置
        if ($platform === 'h5') {
            // H5端使用微信公众号配置
            $appId = $config['wechat']['app_id'] ?? '';
            $appSecret = $config['wechat']['app_secret'] ?? '';
        } else {
            // APP端优先使用wechatapp配置，其次使用wechatweb配置
            $appId = $config['wechatapp']['app_id'] ?? $config['wechatweb']['app_id'] ?? '';
            $appSecret = $config['wechatapp']['app_secret'] ?? $config['wechatweb']['app_secret'] ?? '';
        }
        
        if (!$appId || !$appSecret) {
            $this->error('微信登录配置不完整');
        }
        
        // 通过code获取access_token
        $tokenUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid={$appId}&secret={$appSecret}&code={$code}&grant_type=authorization_code";
        $tokenResult = json_decode(file_get_contents($tokenUrl), true);
        
        if (!$tokenResult || isset($tokenResult['errcode'])) {
            $this->error($tokenResult['errmsg'] ?? '获取access_token失败');
        }
        
        $accessToken = $tokenResult['access_token'];
        $openid = $tokenResult['openid'];
        $unionid = $tokenResult['unionid'] ?? '';
        
        // 获取用户信息
        $userInfoUrl = "https://api.weixin.qq.com/sns/userinfo?access_token={$accessToken}&openid={$openid}&lang=zh_CN";
        $userInfo = json_decode(file_get_contents($userInfoUrl), true);
        
        if (!$userInfo || isset($userInfo['errcode'])) {
            $this->error($userInfo['errmsg'] ?? '获取用户信息失败');
        }
        
        // 组装参数
        $params = [
            'openid' => $openid,
            'unionid' => $unionid ?: ($userInfo['unionid'] ?? ''),
            'nickname' => $userInfo['nickname'] ?? '',
            'avatar' => $userInfo['headimgurl'] ?? '',
            'access_token' => $accessToken,
            'refresh_token' => $tokenResult['refresh_token'] ?? '',
            'expires_in' => $tokenResult['expires_in'] ?? 7200,
        ];
        
        // 调用第三方登录服务
        $loginret = \addons\third\library\Service::connect('wechat', $params);
        if (!$loginret) {
            $this->error('登录失败');
        }
        
        $userinfo = $this->auth->getUserinfo();
        $data = [
            'token' => $userinfo['token'],
            'expire' => 7200,
            'refreshToken' => $userinfo['token'],
            'refreshExpire' => 2592000,
            'userinfo' => $userinfo
        ];
        $this->success('登录成功', $data);
    }
    
    /**
     * 微信小程序登录
     * 
     * @ApiMethod (POST)
     * @ApiParams (name="code", type="string", required=true, description="小程序登录code")
     * @ApiParams (name="encryptedData", type="string", required=false, description="加密数据")
     * @ApiParams (name="iv", type="string", required=false, description="加密向量")
     * @ApiParams (name="userInfo", type="object", required=false, description="用户信息")
     */
    public function wechatMiniLogin()
    {
        $code = $this->request->post('code');
        $encryptedData = $this->request->post('encryptedData');
        $iv = $this->request->post('iv');
        $userInfoData = $this->request->post('userInfo');
        
        if (!$code) {
            $this->error(__('Invalid parameters'));
        }
        
        $config = get_addon_config('third');
        if (!$config) {
            $this->error('第三方登录未配置');
        }
        
        // 小程序配置（需要在后台添加wechatmini配置）
        $appId = $config['wechatmini']['app_id'] ?? $config['wechat']['app_id'] ?? '';
        $appSecret = $config['wechatmini']['app_secret'] ?? $config['wechat']['app_secret'] ?? '';
        
        if (!$appId || !$appSecret) {
            $this->error('小程序登录配置不完整');
        }
        
        // 通过code获取session_key和openid
        $sessionUrl = "https://api.weixin.qq.com/sns/jscode2session?appid={$appId}&secret={$appSecret}&js_code={$code}&grant_type=authorization_code";
        $sessionResult = json_decode(file_get_contents($sessionUrl), true);
        
        if (!$sessionResult || isset($sessionResult['errcode'])) {
            $this->error($sessionResult['errmsg'] ?? '获取session失败');
        }
        
        $openid = $sessionResult['openid'];
        $sessionKey = $sessionResult['session_key'];
        $unionid = $sessionResult['unionid'] ?? '';
        
        // 解密用户信息（如果提供了加密数据）
        $nickname = '';
        $avatar = '';
        if ($encryptedData && $iv) {
            $decrypted = $this->decryptWxData($appId, $sessionKey, $encryptedData, $iv);
            if ($decrypted) {
                $nickname = $decrypted['nickName'] ?? '';
                $avatar = $decrypted['avatarUrl'] ?? '';
                $unionid = $decrypted['unionId'] ?? $unionid;
            }
        } elseif ($userInfoData) {
            // 使用前端传递的用户信息
            $nickname = $userInfoData['nickName'] ?? '';
            $avatar = $userInfoData['avatarUrl'] ?? '';
        }
        
        // 组装参数
        $params = [
            'openid' => $openid,
            'unionid' => $unionid,
            'nickname' => $nickname,
            'avatar' => $avatar,
            'access_token' => $sessionKey,
            'expires_in' => 7200,
        ];
        
        // 调用第三方登录服务
        $loginret = \addons\third\library\Service::connect('wechat', $params);
        if (!$loginret) {
            $this->error('登录失败');
        }
        
        $userinfo = $this->auth->getUserinfo();
        $data = [
            'token' => $userinfo['token'],
            'expire' => 7200,
            'refreshToken' => $userinfo['token'],
            'refreshExpire' => 2592000,
            'userinfo' => $userinfo
        ];
        $this->success('登录成功', $data);
    }
    
    /**
     * 解密微信小程序数据
     */
    private function decryptWxData($appId, $sessionKey, $encryptedData, $iv)
    {
        $aesKey = base64_decode($sessionKey);
        $aesIV = base64_decode($iv);
        $aesCipher = base64_decode($encryptedData);
        
        $result = openssl_decrypt($aesCipher, "AES-128-CBC", $aesKey, 1, $aesIV);
        if (!$result) {
            return null;
        }
        
        $data = json_decode($result, true);
        if (!$data || !isset($data['watermark']['appid']) || $data['watermark']['appid'] !== $appId) {
            return null;
        }
        
        return $data;
    }

    /**
     * 重置密码
     *
     * @ApiMethod (POST)
     * @ApiParams (name="mobile", type="string", required=true, description="手机号")
     * @ApiParams (name="newpassword", type="string", required=true, description="新密码")
     * @ApiParams (name="captcha", type="string", required=true, description="验证码")
     */
    public function resetpwd()
    {
        $type = $this->request->post("type", "mobile");
        $mobile = $this->request->post("mobile");
        $email = $this->request->post("email");
        $newpassword = $this->request->post("newpassword");
        $captcha = $this->request->post("captcha");
        if (!$newpassword || !$captcha) {
            $this->error(__('Invalid parameters'));
        }
        //验证Token
        if (!Validate::make()->check(['newpassword' => $newpassword], ['newpassword' => 'require|regex:\S{6,30}'])) {
            $this->error(__('Password must be 6 to 30 characters'));
        }
        if ($type == 'mobile') {
            if (!Validate::regex($mobile, "^1\d{10}$")) {
                $this->error(__('Mobile is incorrect'));
            }
            $user = \app\common\model\User::getByMobile($mobile);
            if (!$user) {
                $this->error(__('User not found'));
            }
            $ret = Sms::check($mobile, $captcha, 'resetpwd');
            if (!$ret) {
                $this->error(__('Captcha is incorrect'));
            }
            Sms::flush($mobile, 'resetpwd');
        } else {
            if (!Validate::is($email, "email")) {
                $this->error(__('Email is incorrect'));
            }
            $user = \app\common\model\User::getByEmail($email);
            if (!$user) {
                $this->error(__('User not found'));
            }
            $ret = Ems::check($email, $captcha, 'resetpwd');
            if (!$ret) {
                $this->error(__('Captcha is incorrect'));
            }
            Ems::flush($email, 'resetpwd');
        }
        //模拟一次登录
        $this->auth->direct($user->id);
        $ret = $this->auth->changepwd($newpassword, '', true);
        if ($ret) {
            $this->success(__('Reset password successful'));
        } else {
            $this->error($this->auth->getError());
        }
    }
}
