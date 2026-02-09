<?php
namespace app\common\model\task;

use think\Model;

class MutualTask extends Model
{
    protected $name = 'mutual_task';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['status_text', 'category_text', 'receipt_type_text'];

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['task_no'])) {
                $row['task_no'] = self::generateTaskNo();
            }
        });
    }

    public function getReceiptTypeList()
    {
        return ['entry' => '进件二维码', 'collection' => '收款码'];
    }

    public function getReceiptTypeTextAttr($value, $data)
    {
        $value = $value ?: ($data['receipt_type'] ?? '');
        $list = $this->getReceiptTypeList();
        return isset($list[$value]) ? $list[$value] : '';
    }

    public function getStatusTextAttr($value, $data)
    {
        $list = [
            'pending' => '待审核',
            'approved' => '已审核',
            'rejected' => '已拒绝',
            'running' => '进行中',
            'paused' => '已暂停',
            'completed' => '已完成',
            'cancelled' => '已取消'
        ];
        $status = $data['status'] ?? '';
        return isset($list[$status]) ? $list[$status] : '';
    }

    public function getCategoryTextAttr($value, $data)
    {
        $category = $data['category'] ?? '';
        if (empty($category)) {
            return '互助任务';
        }
        // 尝试从任务类型表获取名称
        $taskType = \app\common\model\TaskType::getByCode($category);
        if ($taskType) {
            return $taskType->name;
        }
        // 默认映射
        $list = [
            'ecommerce' => '电商互助',
            'payment' => '支付流水',
            'alipay' => '支付宝',
            'wechat' => '微信支付',
            'meituan' => '美团外卖',
            'eleme' => '饿了么',
            'jd' => '京东',
            'taobao' => '淘宝',
            'pinduoduo' => '拼多多',
            'douyin' => '抖音',
            'other' => '其他'
        ];
        return isset($list[$category]) ? $list[$category] : $category;
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function subTasks()
    {
        return $this->hasMany('app\common\model\task\SubTask', 'task_id', 'id');
    }

    public static function generateTaskNo()
    {
        return 'T' . date('YmdHis') . str_pad(mt_rand(1, 9999), 4, '0', STR_PAD_LEFT);
    }

    public static function getByUserId($userId, $status = null)
    {
        $query = self::where('user_id', $userId);
        if ($status !== null) {
            $query->where('status', $status);
        }
        return $query->order('id', 'desc')->select();
    }

    public static function getRunningTasks()
    {
        return self::where('status', 'running')->select();
    }

    public function canDispatch()
    {
        return $this->status === 'running' && 
               bccomp(bcsub($this->deposit_amount, $this->frozen_amount, 2), '0', 2) > 0;
    }

    public function getAvailableDeposit()
    {
        return bcsub($this->deposit_amount, $this->frozen_amount, 2);
    }

    public function updateProgress()
    {
        $completed = SubTask::where('task_id', $this->id)->where('status', 'completed')->sum('amount');
        $pending = SubTask::where('task_id', $this->id)->whereIn('status', ['pending', 'assigned', 'accepted', 'paid', 'verified'])->sum('amount');
        
        $this->completed_amount = $completed;
        $this->pending_amount = $pending;
        
        if (bccomp($this->completed_amount, $this->total_amount, 2) >= 0) {
            $this->status = 'completed';
        }
        
        $this->save();
    }
}
