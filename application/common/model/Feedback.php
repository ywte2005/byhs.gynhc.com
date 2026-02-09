<?php
namespace app\common\model;

use think\Model;

/**
 * 工单反馈模型
 */
class Feedback extends Model
{
    protected $name = 'feedback';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text', 'type_text'];

    // 反馈类型
    public static $types = [
        'suggestion' => '功能建议',
        'bug' => '系统故障',
        'complaint' => '投诉举报',
        'question' => '咨询问题',
        'other' => '其他'
    ];

    // 反馈状态
    public static $statuses = [
        'pending' => '待处理',
        'processing' => '处理中',
        'replied' => '已回复',
        'closed' => '已关闭'
    ];

    public function getStatusTextAttr($value, $data)
    {
        return self::$statuses[$data['status']] ?? '';
    }

    public function getTypeTextAttr($value, $data)
    {
        return self::$types[$data['type']] ?? $data['type'];
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    /**
     * 提交反馈
     */
    public static function submit($userId, $data)
    {
        return self::create([
            'user_id' => $userId,
            'type' => $data['type'] ?? 'other',
            'title' => $data['title'] ?? '',
            'content' => $data['content'] ?? '',
            'images' => $data['images'] ?? '',
            'contact' => $data['contact'] ?? '',
            'status' => 'pending'
        ]);
    }

    /**
     * 回复反馈
     */
    public function reply($content, $adminId = 0)
    {
        $this->reply = $content;
        $this->reply_time = time();
        $this->admin_id = $adminId;
        $this->status = 'replied';
        $this->save();

        return true;
    }

    /**
     * 关闭反馈
     */
    public function close($adminId = 0)
    {
        $this->admin_id = $adminId;
        $this->status = 'closed';
        $this->save();

        return true;
    }
}
