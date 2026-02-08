<?php
namespace app\common\model;

use think\Model;

class Message extends Model
{
    protected $name = 'message';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = false;

    // 关联用户
    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }

    const TYPE_SYSTEM = 'system';
    const TYPE_TASK = 'task';
    const TYPE_WALLET = 'wallet';
    const TYPE_PROMO = 'promo';

    public static function getUserMessages($userId, $type = null, $page = 1, $limit = 20)
    {
        $query = self::where('user_id', $userId);
        if ($type) {
            $query->where('type', $type);
        }
        return $query->order('id', 'desc')->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function getUnreadCount($userId, $type = null)
    {
        $query = self::where('user_id', $userId)->where('is_read', 0);
        if ($type) {
            $query->where('type', $type);
        }
        return $query->count();
    }

    public static function markAsRead($userId, $messageId = null)
    {
        $query = self::where('user_id', $userId);
        if ($messageId) {
            $query->where('id', $messageId);
        }
        return $query->update(['is_read' => 1]);
    }

    public static function send($userId, $type, $title, $content = '', $extra = [])
    {
        return self::create([
            'user_id' => $userId,
            'type' => $type,
            'title' => $title,
            'content' => $content,
            'extra' => $extra ? json_encode($extra) : null,
            'is_read' => 0
        ]);
    }

    public function getExtraAttr($value)
    {
        return $value ? json_decode($value, true) : [];
    }

    public function setExtraAttr($value)
    {
        return $value ? json_encode($value) : null;
    }
}
