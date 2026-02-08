<?php
namespace app\common\model\task;

use think\Model;

class SubTask extends Model
{
    protected $name = 'sub_task';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text'];

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['task_no'])) {
                $row['task_no'] = self::generateTaskNo();
            }
        });
    }

    public function getStatusTextAttr($value, $data)
    {
        $list = [
            'pending' => '待分配',
            'assigned' => '已分配',
            'accepted' => '已接单',
            'paid' => '已支付',
            'verified' => '已验证',
            'completed' => '已完成',
            'failed' => '失败',
            'cancelled' => '已取消'
        ];
        return isset($list[$data['status']]) ? $list[$data['status']] : '';
    }

    public function task()
    {
        return $this->belongsTo('app\common\model\task\MutualTask', 'task_id', 'id');
    }

    public function fromUser()
    {
        return $this->belongsTo('app\common\model\User', 'from_user_id', 'id');
    }

    public function toUser()
    {
        return $this->belongsTo('app\common\model\User', 'to_user_id', 'id');
    }

    public static function generateTaskNo()
    {
        return 'ST' . date('YmdHis') . str_pad(mt_rand(1, 9999), 4, '0', STR_PAD_LEFT);
    }

    public static function getAvailableForUser($userId, $category = null, $page = 1, $limit = 20)
    {
        $query = self::with(['task' => function($query) {
                $query->field('id,title,category,platform,createtime');
            }])
            ->where('status', 'assigned')
            ->where('to_user_id', 0)
            ->where('from_user_id', '<>', $userId);
        
        // 如果指定了分类，则关联主任务表进行筛选
        if ($category && $category !== 'all') {
            $query->hasWhere('task', function($query) use ($category) {
                $query->where('category', $category);
            });
        }
        
        return $query->order('id', 'asc')
            ->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function getUserAccepted($userId, $status = '', $page = 1, $limit = 20)
    {
        $query = self::where('to_user_id', $userId);
        
        if (!empty($status)) {
            $query->where('status', $status);
        } else {
            $query->whereIn('status', ['accepted', 'paid', 'verified', 'completed', 'failed']);
        }
        
        return $query->order('id', 'desc')
            ->paginate(['page' => $page, 'list_rows' => $limit]);
    }

    public static function getByTaskId($taskId)
    {
        return self::where('task_id', $taskId)->select();
    }

    public function accept($userId)
    {
        if ($this->status !== 'assigned') {
            throw new \Exception('当前状态不允许接单');
        }
        if ($this->to_user_id > 0) {
            throw new \Exception('该任务已被接单');
        }
        
        $this->to_user_id = $userId;
        $this->status = 'accepted';
        $this->accepted_time = time();
        $this->save();
        
        return true;
    }

    public function uploadProof($proofImage, $thirdOrderNo = '')
    {
        if ($this->status !== 'accepted') {
            throw new \Exception('当前状态不允许上传凭证');
        }
        
        $this->proof_image = $proofImage;
        $this->third_order_no = $thirdOrderNo;
        $this->status = 'paid';
        $this->paid_time = time();
        $this->save();
        
        return true;
    }

    public function verify()
    {
        if ($this->status !== 'paid') {
            throw new \Exception('当前状态不允许验证');
        }
        
        $this->status = 'verified';
        $this->save();
        
        return true;
    }

    public function complete()
    {
        if (!in_array($this->status, ['paid', 'verified'])) {
            throw new \Exception('当前状态不允许完成');
        }
        
        $this->status = 'completed';
        $this->completed_time = time();
        $this->save();
        
        return true;
    }

    public function fail($reason)
    {
        $this->status = 'failed';
        $this->fail_reason = $reason;
        $this->save();
        
        return true;
    }
}
