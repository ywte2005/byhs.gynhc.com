<?php

// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

use think\Route;

// RESTful风格路由配置
// 用户登录相关
Route::post('api/app/user/login/phone', 'api/app.user/login', ['action' => 'phone']);
Route::get('api/app/user/login/captcha', 'api/app.user/login', ['action' => 'captcha']);
Route::post('api/app/user/login/smsCode', 'api/app.user/login', ['action' => 'smsCode']);
Route::post('api/app/user/login/refreshToken', 'api/app.user/login', ['action' => 'refreshToken']);
Route::post('api/app/user/login/mini', 'api/app.user/login', ['action' => 'mini']);

// 用户信息相关
Route::get('api/app/user/info/person', 'api/app.user/info', ['action' => 'person']);
Route::post('api/app/user/info/updatePerson', 'api/app.user/info', ['action' => 'updatePerson']);

return [
    //别名配置,别名只能是映射到控制器且访问时必须加上请求的方法
    '__alias__'   => [
    ],
    //变量规则
    '__pattern__' => [
    ],
//        域名绑定到模块
//        '__domain__'  => [
//            'admin' => 'admin',
//            'api'   => 'api',
//        ],
];
