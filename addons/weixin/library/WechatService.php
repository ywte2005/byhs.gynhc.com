<?php

namespace addons\weixin\library;
use EasyWeChat\Kernel\Exceptions\Exception;
use EasyWeChat\Factory;

class WechatService
{
    private static $instance = null;

    /**
     * @notes EasyWeChat公众号应用实例
     * @author Xing <464401240@qq.com>
     */
    public static function application($cache = false)
    {
        if (self::$instance === null || $cache === true) {
            $config = ConfigService::getOaConfig();
            if (empty($config['app_id']) || empty($config['secret'])) {
                throw new Exception('请先设置公众号配置');
            }
            self::$instance = Factory::officialAccount($config);
        }
        return self::$instance;
    }

    /**
     * @notes 微信公众号回调事件监听
     * @author Xing <464401240@qq.com>
     */
    public static function observe()
    {
        self::application()->server->push(WechatEvent::class);//事件监听
        return self::application()->server->serve();
    }

    /**
     * 微信公众号菜单接口
     * @return object
     */
    public static function menuService()
    {
        return self::application()->menu;
    }

    /**
     * 用户标签接口
     * @return object
     */
    public static function userTagService()
    {
        return self::application()->user_tag;
    }

    /**
     * 用户授权
     * @return object
     */
    public static function oauthService()
    {
        return self::application()->oauth;
    }

    /**
     * 用户接口
     * @return object
     */
    public static function userService()
    {
        return self::application()->user;
    }

    /**
     * 获得用户信息
     * @param array|string $openid
     * @return object
     */
    public static function getUserInfo($openid)
    {
        $userService = self::userService();
        $userInfo = $userService->get($openid);
        return $userInfo;
    }

    /**
     * 获得用户openid列表
     * @param array|string $openid
     * @return object
     */
    public static function getUserList($next_openid = null)
    {
        $userService = self::userService();
        $userList = $userService->list($next_openid);
        return $userList;
    }

    /**
     * @notes 获得用户列表信息
     * @author 兴
     * @date 2022/10/31 22:57
     */
    public static function getUserListInfo($list = [])
    {
        $userService = self::userService();
        if (empty($list)) {
            $list = self::getUserList();
        } else {
            $list['data']['openid'] = $list;
        }
        if (!isset($list['data']['openid'])) {
            return [];
        }
        $userList = $userService->select($list['data']['openid']);
        return $userList;
    }

    /**
     * 上传临时素材接口
     * @return object
     */
    public static function material($type, $data)
    {
        //上传素材
        switch ($type) {
            case 'image':
                $material = self::application()->media->uploadImage(self::pathFormat($data));
                break;
            case 'voice':
                $material = self::application()->media->uploadVoice(self::pathFormat($data));
                break;
            case 'video':
                $material = self::application()->media->uploadVideo(self::pathFormat($data['file']), $data['title'], $data['description']);
                break;
        }
        if (isset($material['errcode']) && $material['errcode'] > 0) {
            throw new Exception(json_encode($material));
        }
        return isset($material['media_id']) ? $material['media_id'] : '';
    }

    /**
     * @notes 下载文件
     * @param $url
     * @param $saveDir
     * @param $fileName
     * @return string
     * @author Xing <464401240@qq.com>
     */
    public static function download_file($url, $saveDir, $fileName): string
    {
        if (!file_exists($saveDir)) {
            mkdir($saveDir, 0775, true);
        }
        $fileSrc = $saveDir . $fileName;
        file_exists($fileSrc) && unlink($fileSrc);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
        $file = curl_exec($ch);
        curl_close($ch);
        $resource = fopen($fileSrc, 'a');
        fwrite($resource, $file);
        fclose($resource);
        if (filesize($fileSrc) == 0) {
            unlink($fileSrc);
            return '';
        }
        return '/' . $fileSrc;
    }

    /**
     * @notes 处理素材路径
     * @author Xing <464401240@qq.com>
     */
    public static function pathFormat($url)
    {
        if (strpos($url, 'http://') !== false || strpos($url, 'https://') !== false) {
            $extension = pathinfo($url, PATHINFO_EXTENSION);
            $url = self::download_file($url, 'uploads/weixin/material/', md5($url) . '.' . $extension);
        }
        $url = realpath(trim($url, '/'));
        if ($url !== false) {
            return $url;
        }
        throw new \Exception('素材文件无效或不存在');
    }

    /**
     * @notes jsSdk
     * @author 兴
     * @date 2022/10/31 22:48
     */
    public function jsSdk($url = '')
    {
        $apiList = [
            'onMenuShareTimeline',
            'onMenuShareAppMessage',
            'onMenuShareQQ',
            'onMenuShareWeibo',
            'onMenuShareQZone',
            'openLocation',
            'getLocation',
            'chooseWXPay',
            'updateAppMessageShareData',
            'updateTimelineShareData',
            'openAddress',
            'scanQRCode'
        ];
        $jsService = self::application()->jssdk;
        if ($url) {
            $jsService->setUrl($url);
        }
        return $jsService->buildConfig($apiList, $debug = false, $beta = false, $json = false);
    }

}
