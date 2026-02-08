<?php
namespace app\common\model\task;

use think\Model;

/**
 * 任务保证金缴纳日志
 */
class TaskDepositLog extends Model
{
    protected $name = 'task_deposit_log';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = false;

    protected $append = ['type_text'];

    public function getTypeTextAttr($value, $data)
    {
        $list = [
            'pay' => '首次缴纳',
            'topup' => '补缴',
            'refund' => '退还'
        ];
        return isset($list[$data['type']]) ? $list[$data['type']] : '';
    }

    public function task()
    {
        return $this->belongsTo('app\common\model\task\MutualTask', 'task_id', 'id');
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    /**
     * 获取任务的保证金缴纳记录
     */
    public static function getByTaskId($taskId)
    {
        return self::where('task_id', $taskId)
            ->order('id', 'desc')
            ->select();
    }
}
