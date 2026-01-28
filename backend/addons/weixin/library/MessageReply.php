<?php

namespace addons\weixin\library;
use EasyWeChat\Kernel\Messages\{Text, Image, Material, News, NewsItem, Video, Voice, Transfer};
use app\admin\model\weixin\Reply as ModelReply;
use app\admin\model\weixin\News  as ModelNews;

/**
 * 公众号消息回复类
 */
class MessageReply
{

    /**
     * @notes 回复内容
     * @author Xing <464401240@qq.com>
     */
    private $content = [];

    /**
     * @notes 消息回复入口（任务分发）
     * @author Xing <464401240@qq.com>
     */
    public function handle($keyword = '', $item = [])
    {
        //未指定回复内容时，则通过关键词查找
        if (empty($item)) {
            $keyword = trim($keyword);
            $replyList = ModelReply::where('status', 'normal')->select();
            foreach ($replyList as $reply) {
                $keyword_arr = explode(',', $reply['keyword']);
                switch ($reply['matching_type']) {
                    //全词匹配
                    case 1:
                        in_array($keyword, $keyword_arr) && $item = $reply;
                        break;
                    //模糊匹配
                    case 2:
                        foreach ($keyword_arr as $val) {
                            stripos($keyword, $val) !== false && $item = $reply;
                        }
                        break;
                }
                if ($item) {
                    break; // 得到回复，中止循环
                }
            }
        }

        // 未指定或通过关键词也没有找到回复内容时，则查询默认回复
        if (empty($item)) {
            $item = ModelReply::where('keyword', 'default')->where('status', 'normal')->find();
        }

        // 找到回复的内容
        if (!empty($item)) {
            $this->content = json_decode($item->content, true);
            //根据回复类型调用不同的方法推送
            $action = $item['reply_type'];
            if (method_exists($this, $action)) {
                return $this->$action();
            }
        }

        // 没有任何回复时，转发收到的消息给客服
        return new Transfer();
    }

    /**
     * 回复文本消息
     */
    public function text($msg = '')
    {
        if ($msg) {
            return new Text($msg);
        }
        if (isset($this->content['text']) && $this->content['text']) {
            return new Text($this->content['text']);
        }
        return false;
    }

    /**
     * 回复图文消息
     */
    private function news()
    {
        if (!isset($this->content['news']) || !$this->content['news'] || !is_numeric($this->content['news'])) {
            return false;
        }
        $data = ModelNews::get($this->content['news']);
        $items = [
            new NewsItem([
                'title' => $data['title'] ?? '',
                'description' => $data['description'] ?? '',
                'url' => $data['url'] ?? '',
                'image' => cdnurl($data['pic'], true),
            ]),
        ];
        return new News($items);
    }

    /**
     * 回复图片消息
     */
    private function image()
    {
        if (!isset($this->content['image_media_id']) || !$this->content['image_media_id']) {
            return false;
        }
        return new Image($this->content['image_media_id']);
    }

    /**
     * 回复视频消息
     */
    private function video()
    {
        if (!isset($this->content['video_media_id']) || !$this->content['video_media_id']) {
            return false;
        }
        return new Video(
            $this->content['video_media_id'],
            [
                'title' => $this->content['video_title'],
                'description' => $this->content['video_description'],
                'thumb_media_id' => null
            ]
        );
    }

    /**
     * 回复声音消息
     */
    private function voice()
    {
        if (!isset($this->content['voice_media_id']) || !$this->content['voice_media_id']) {
            return false;
        }
        return new Voice($this->content['voice_media_id']);
    }

    /**
     * 作为客服消息发送
     * @return object
     */
    public function staff($item, $openid)
    {
        if (!empty($item)) {
            $message = $this->handle('', $item);
            return (new WechatService)->application()->customer_service->message($message)->to($openid)->send();
        } else {
            return false;
        }
    }

}