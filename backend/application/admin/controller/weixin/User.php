<?php

namespace app\admin\controller\weixin;
use app\common\controller\Backend;
use Exception;
use think\Db;
use think\exception\{PDOException, ValidateException};
use addons\weixin\library\{WechatService, MessageReply};

/**
 * 微信用户管理
 * @icon fa fa-circle-o
 */
class User extends Backend
{
    /**
     * User模型对象
     * @var \app\admin\model\weixin\User
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\weixin\User;
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
                    ->with(['fauser'])
                    ->where($where)
                    ->order($sort, $order)
                    ->count();

            $list = $this->model
                    ->with(['fauser'])
                    ->where($where)
                    ->order($sort, $order)
                    ->limit($offset, $limit)
                    ->select();
            $list = collection($list)->toArray();

            try {
                $list_tag = $this->model->getTag();
            } catch (Exception $e) {
                $this->error($e->getMessage());
            }
            foreach ($list as &$row) {
                $row['fauser']['avatar'] = $row['fauser']['avatar'] ? cdnurl($row['fauser']['avatar'], true) : letter_avatar($row['fauser']['nickname']);
                if (!empty($row['tagid_list'])) {
                    $tagid_list_arr = explode(',', $row['tagid_list']);
                    $tagid_list = [];
                    foreach ($tagid_list_arr as $v) {
                        if (isset($list_tag[$v])) {
                            $tagid_list[] = $list_tag[$v]['name'];
                        }
                    }
                    $row['tagid_list_text'] = $tagid_list;
                } else {
                    $row['tagid_list_text'] = ['无'];
                }
            }
            unset($row);
            $result = array("total" => $total, "rows" => $list);

            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 推送消息
     * @author Created by Xing <464401240@qq.com>
     */
    public function sendmsg($ids = null)
    {
        $ids = trim($ids, ',');
        if ($this->request->isAjax()) {
            $list = $this->model->where('id', 'in', $ids)->select();
            if (empty($list)) {
                $this->error('发送失败，参数不正确');
            }
            $params = $this->request->post("row/a");
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

        //加载当前控制器语言包
        $this->loadlang('weixin/reply');
        $this->view->assign("replyTypeList", (new \app\admin\model\weixin\Reply)->getReplyTypeList());
        return $this->view->fetch();
    }

    /**
     * 修改用户标签
     */
    public function edit_user_tag($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        if ($this->request->isAjax()) {
            $tagId = $this->request->post('tagid_list');
            if (!$tagId) {
                $this->error('请选择用户标签!');
            }
            if ($tagId) {
                $params['tagid_list'] = $tagId;
                $result = false;
                Db::startTrans();
                try {
                    $result = $row->allowField(true)->save($params);
                    Db::commit();
                } catch (ValidateException|PDOException|Exception $e) {
                    Db::rollback();
                    $this->error($e->getMessage());
                }
                if ($result !== false) {
                    $tagId = explode(',', $tagId) ?: [];
                    $tagList = explode(',', $row['tagid_list']) ?: [];
                    foreach ($tagList as $tag) {
                        if ($tag) {
                            WechatService::userTagService()->untagUsers([$row['openid']], $tag);
                        }
                    }
                    foreach ($tagId as $tag) {
                        WechatService::userTagService()->tagUsers([$row['openid']], $tag);
                    }
                    $this->success();
                } else {
                    $this->error(__('No rows were updated'));
                }
            }
        }
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }

    /**
     * 标签列表
     */
    public function tag()
    {
        if ($this->request->isAjax()) {
            try {
                $list = $this->model->getTag();
                $result = array("total" => count($list), "rows" => array_values($list));
            } catch (Exception $e) {
                $this->error($e->getMessage());
            }
            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 添加标签
     */
    public function tagadd()
    {
        if ($this->request->isPost()) {
            $tagName = $this->request->post('name');
            if (!$tagName) {
                $this->error('请输入标签名称!');
            }
            try {
                WechatService::userTagService()->create($tagName);
            } catch (\Exception $e) {
                $this->error($e->getMessage());
            }
            \think\Cache::tag('_system_wechat')->rm('_wechat_taglist');
            $this->success();
        }
        return $this->view->fetch();
    }

    /**
     * 修改标签
     */
    public function tagedit($ids = null)
    {
        $list = $this->model->getTag();
        if (!isset($list[$ids])) {
            $this->error(__('No Results were found'));
        } else {
            $row = $list[$ids];
        }
        if ($this->request->isPost()) {
            $tagName = $this->request->post('name');
            if (!$tagName) {
                $this->error('请输入标签名称!');
            }
            try {
                WechatService::userTagService()->update($ids, $tagName);
            } catch (\Exception $e) {
                $this->error($e->getMessage());
            }
            \think\Cache::tag('_system_wechat')->rm('_wechat_taglist');
            $this->success('修改标签成功!');
        }
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }

    /**
     * 删除标签
     */
    public function tagdel($ids = null)
    {
        if ($this->request->isPost()) {
            try {
                WechatService::userTagService()->delete($ids);
            } catch (\Exception $e) {
                $this->error($e->getMessage());
            }
            \think\Cache::tag('_system_wechat')->rm('_wechat_taglist');
            $this->success('删除标签成功!');
        }
    }
}
