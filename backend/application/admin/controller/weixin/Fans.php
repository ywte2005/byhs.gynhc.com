<?php

namespace app\admin\controller\weixin;
use app\common\controller\Backend;
use addons\weixin\library\WechatService;
use addons\weixin\library\MessageReply;

/**
 * 微信粉丝用户
 *
 * @icon fa fa-circle-o
 */
class Fans extends Backend
{
    /**
     * User模型对象
     * @var \app\admin\model\weixin\Fans
     */
    protected $model = null;

    /**
     * 快速搜索时执行查找的字段
     */
    protected $searchFields = 'fans_id';

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\weixin\Fans;
        //内容过滤
        $this->request->filter('trim,strip_tags,htmlspecialchars');
    }
    
    /**
     * 查看
     */
    public function index()
    {
        //当前是否为关联查询
        $this->relationSearch = true;
        //设置过滤方法
        $this->request->filter(['strip_tags', 'trim']);
        if ($this->request->isAjax()) {
            //如果发送的来源是Selectpage，则转发到Selectpage
            if ($this->request->request('keyField')) {
                return $this->selectpage();
            }
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            $total = $this->model
                ->where($where)
                ->order($sort, $order)
                ->count();

            $list = $this->model
                ->where($where)
                ->order($sort, $order)
                ->limit($offset, $limit)
                ->select();
            $list = collection($list)->toArray();
            $result = array("total" => $total, "rows" => $list);
            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 更新粉丝信息
     */
    public function syncWechatFans()
    {
        $page_index = input('page', 0);
        $page_size  = input('limit', 50);
        $next_openid = input('next_openid', null);

        if ($page_index == 0) {
            //建立连接，同时获取所有用户openid  拉去粉丝信息列表(一次拉取调用最多拉取10000个关注者的OpenID，可以通过多次拉取的方式来满足需求。)
            $item_result = WechatService::getUserList($next_openid);
            if (empty($item_result['data']['openid'])) {
                $this->error('公众号暂无粉丝');
            }
            $next_openid = $item_result["next_openid"];
            $openid_list = $item_result['data']["openid"];

            //将粉丝列表存入缓存
            \think\Cache::set('wechat_openid_list', $openid_list, 0);
            $total = count($openid_list);
            if ($openid_list % $page_size == 0) {
                $page_count = (int)($total / $page_size);
            } else {
                $page_count = ceil($total / $page_size);
            }
            $data = array(
                'total' => $total,
                'page_count' => $page_count,
                'next_openid' => $item_result['count'] == 10000 ? $next_openid : null,
            );
            $this->success('ok', '', $data);
        } else {
            //对应页数更新用户粉丝信息
            $openid_list = \think\Cache::get('wechat_openid_list');
            if (empty($openid_list)) {
                $this->error('');
            }
            $start = ($page_index - 1) * $page_size;
            $page_fans_openid_list = array_slice($openid_list, $start, $page_size);

            if (empty($page_fans_openid_list)) {
                $this->error('');
            }

            //2021年12月27日之后，不再输出头像、昵称信息
            $result = WechatService::getUserListInfo($page_fans_openid_list);

            if (isset($result['user_info_list'])) {
                foreach ($result['user_info_list'] as $k => $v) {
                    if (!isset($v['nickname'])) continue;
                    $nickname_decode = preg_replace('/[\x{10000}-\x{10FFFF}]/u', '', $v['nickname']);
                    $nickname        = preg_replace_callback('/./u',
                        function (array $match) {
                            return strlen($match[0]) >= 4 ? '' : $match[0];
                        },
                        $v['nickname']
                    );
                    $add_data = [
                        'nickname'         => $nickname ? $nickname : '微信用户',
                        'nickname_decode'  => $nickname_decode,
                        'headimgurl'       => $v['headimgurl'] ? $v['headimgurl'] : '/assets/img/avatar.png',
                        'sex'              => $v['sex'],
                        'language'         => $v['language'],
                        'country'          => $v['country'] ? $v['country'] : '未知',
                        'province'         => $v['province'] ? $v['province'] : '未知',
                        'city'             => $v['city'] ? $v['city'] : '未知',
                        'openid'           => $v['openid'],
                        'unionid'          => $v['unionid'] ?? '',
                        'groupid'          => '',
                        'is_subscribe'     => $v['subscribe'],
                        'remark'           => $v['remark'],
                        'subscribe_time'   => $v['subscribe_time'] ?? 0,
                        'subscribe_scene'  => $v['subscribe_scene'] ?? 0,
                        'unsubscribe_time' => $v['unsubscribe_time'] ?? 0,
                        'update_date'      => time()
                    ];
                    $info = $this->model->where(['openid' => $v['openid']])->field('openid')->find();
                    if (!empty($info)) {
                        $this->model->where(['openid' => $v['openid']])->update($add_data);
                    } else {
                        $this->model->insert($add_data);
                    }
                }
            } else {
                $this->error(isset($result['errmsg']) ? $result['errmsg'] : '');
            }
            $this->success('ok');
        }
    }

    /**
     * 推送消息
     * @author Created by Xing <464401240@qq.com>
     */
    public function sendmsg($ids = null)
    {
        $ids = trim($ids, ',');
        if ($this->request->isAjax()) {
            $params = $this->request->post("row/a");
            $params['ids'] = $ids;
            if ($params) {
                $list = $this->model->where(['fans_id' => ['in', $ids], 'is_subscribe' => 1])->select();
                if (empty($list)) {
                    $this->error('发送失败，参数不正确');
                }
                $model = new \app\admin\model\weixin\Reply;
                foreach ($list as $v) {
                    try {
                        $id = isset($params[$params['reply_type']]) ? $params[$params['reply_type']] : 0;
                        $item = $model->where(['reply_type' => $params['reply_type'], 'id' => $id])->find();
                        (new MessageReply)->staff($item, $v['openid']);
                    } catch (\Exception $e) {
                        $this->error($e->getMessage());
                    }
                }
                $this->success('发送成功');
            }
        }

        //加载当前控制器语言包
        $this->loadlang('weixin/reply');
        $model = new \app\admin\model\weixin\Reply;
        $this->view->assign("replyTypeList", $model->getReplyTypeList());
        return $this->view->fetch();
    }
}