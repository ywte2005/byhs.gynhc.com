<?php

namespace app\admin\model\weixin;
use think\Model;
use think\Cache;
use addons\weixin\library\WechatService;

class User extends Model
{
	// 表名
	protected $name = 'weixin_user';
	
	// 自动写入时间戳字段
	protected $autoWriteTimestamp = 'int';
	
	// 定义时间戳字段名
	protected $createTime = 'createtime';
	protected $updateTime = false;
	protected $deleteTime = false;
	
	public function fauser()
	{
		return $this->belongsTo('app\admin\model\User', 'user_id', 'id', [], 'LEFT')->setEagerlyType(0);
	}

	/**
	 * 得到微信标签
	 * @author Created by Xing <464401240@qq.com>
	 */
	public static function getTag()
	{
        $list = Cache::tag('_system_wechat')->remember('_wechat_taglist', function () {
            $result = WechatService::userTagService()->list();
            if (isset($result['errcode']) && $result['errcode'] != 0) {
                throw new \Exception(json_encode($result));
            }
            $tag = $result['tags'] ?? array();
            $list = [];
            foreach ($tag as $g) {
                $list[$g['id']] = $g;
            }
            Cache::tag('_system_wechat', ['_wechat_taglist']);
            return $list;
        }, 3600);
        return $list;
	}
}
