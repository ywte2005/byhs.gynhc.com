<?php

namespace addons\weixin\library;
use app\admin\model\weixin\Template;

class WechatTemplate
{
    /**
     * 发送模板消息
     */
    public static function send($tempkey, $openid, array $data)
    {
        try {
            $item = Template::where('tempkey', $tempkey)->where('status', 1)->find();
            if (!$item) {
                return false;
            }
            //替换内容
            foreach ($data as $k => $v) {
                $search_replace = '{'.$k.'}';
                $item['content'] = str_replace($search_replace, $v, $item['content']);
            }
            //组装数据
            $item['content'] = json_decode($item['content'], true);
            $message = [];
            foreach ($item['content'] as $k => $v) {
                $message[$v['keyword']] = $v['content'];
            }
            $data = [
                'touser' => $openid,
                'template_id' => trim($item['tempid']),
                'data' => $message
            ];
            if ($item['open_type'] == 0) {
                $data['url'] = $item['open_url'];
            } else {
                $data['miniprogram'] = [
                    'appid' => $item['appid'],
                    'pagepath' => $item['pagepath'],
                ];
            }
            $result = (new WechatService)->application()->template_message->send($data);
            if (isset($result['errcode']) && $result['errcode'] != 0) {
                throw new \Exception($result['errmsg']);
            }
            return true;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }
}
