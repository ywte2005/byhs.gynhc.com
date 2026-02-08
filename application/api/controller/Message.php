<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\model\Message as MessageModel;

class Message extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    public function list()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        $type = $this->request->get('type', null);
        
        $userId = $this->auth->id;
        $list = MessageModel::getUserMessages($userId, $type, $page, $limit);
        
        $this->success('获取成功', [
            'list' => $list->items(),
            'total' => $list->total()
        ]);
    }

    public function unreadCount()
    {
        $userId = $this->auth->id;
        
        $counts = [
            'total' => MessageModel::getUnreadCount($userId),
            'system' => MessageModel::getUnreadCount($userId, MessageModel::TYPE_SYSTEM),
            'task' => MessageModel::getUnreadCount($userId, MessageModel::TYPE_TASK),
            'wallet' => MessageModel::getUnreadCount($userId, MessageModel::TYPE_WALLET),
            'promo' => MessageModel::getUnreadCount($userId, MessageModel::TYPE_PROMO)
        ];
        
        $this->success('获取成功', $counts);
    }

    public function detail()
    {
        $messageId = $this->request->get('message_id');
        if (!$messageId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        $message = MessageModel::where('id', $messageId)
            ->where('user_id', $userId)
            ->find();
        
        if (!$message) {
            $this->error('消息不存在');
        }
        
        if (!$message->is_read) {
            $message->is_read = 1;
            $message->save();
        }
        
        $this->success('获取成功', ['message' => $message]);
    }

    public function markRead()
    {
        $messageId = $this->request->post('message_id', null);
        $userId = $this->auth->id;
        
        MessageModel::markAsRead($userId, $messageId);
        
        $this->success('操作成功');
    }

    public function markAllRead()
    {
        $type = $this->request->post('type', null);
        $userId = $this->auth->id;
        
        $query = MessageModel::where('user_id', $userId)->where('is_read', 0);
        if ($type) {
            $query->where('type', $type);
        }
        $query->update(['is_read' => 1]);
        
        $this->success('操作成功');
    }

    public function delete()
    {
        $messageId = $this->request->post('message_id');
        if (!$messageId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        $message = MessageModel::where('id', $messageId)
            ->where('user_id', $userId)
            ->find();
        
        if (!$message) {
            $this->error('消息不存在');
        }
        
        $message->delete();
        $this->success('删除成功');
    }
}
