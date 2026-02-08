<?php
namespace app\common\model\wallet;

use think\Model;

class WalletLog extends Model
{
    protected $name = 'wallet_log';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = false;

    protected $append = ['wallet_type_text', 'change_type_text', 'biz_type_text'];

    // 钱包类型
    public static $walletTypes = [
        'balance' => '余额',
        'deposit' => '保证金',
        'frozen' => '冻结',
        'mutual' => '互助余额'
    ];

    // 变动类型
    public static $changeTypes = [
        'income' => '收入',
        'expense' => '支出',
        'freeze' => '冻结',
        'unfreeze' => '解冻'
    ];

    // 业务类型
    public static $bizTypes = [
        'recharge' => '充值',
        'withdraw' => '提现',
        'deposit_pay' => '保证金充值',
        'deposit_withdraw' => '保证金提取',
        'subtask_amount' => '刷单金额',
        'subtask_commission' => '刷单佣金',
        'subtask_complete' => '刷单收入',
        'service_fee' => '服务费',
        'bonus' => '分红',
        'reward' => '奖励',
        'deposit_freeze' => '保证金冻结',
        'deposit_unfreeze' => '保证金解冻',
        'mutual_income' => '互助收入',
        'mutual_expense' => '互助支出',
        'level_purchase' => '等级购买',
        'merchant_fee' => '商户入驻费',
        'task_deposit' => '任务保证金',
        'task_deposit_topup' => '任务保证金补缴'
    ];

    // 需要根据钱包类型区分转入/转出的业务类型
    public static $transferTypes = [
        'task_deposit' => ['balance' => '任务保证金（转出）', 'deposit' => '任务保证金（转入）'],
        'task_deposit_topup' => ['balance' => '任务保证金补缴（转出）', 'deposit' => '任务保证金补缴（转入）'],
    ];

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function getWalletTypeTextAttr($value, $data)
    {
        $key = $data['wallet_type'] ?? '';
        return isset(self::$walletTypes[$key]) ? self::$walletTypes[$key] : '';
    }

    public function getChangeTypeTextAttr($value, $data)
    {
        $key = $data['change_type'] ?? '';
        return isset(self::$changeTypes[$key]) ? self::$changeTypes[$key] : '';
    }

    public function getBizTypeTextAttr($value, $data)
    {
        $bizType = $data['biz_type'] ?? '';
        $walletType = $data['wallet_type'] ?? '';
        
        // 检查是否需要根据钱包类型区分转入/转出
        if (isset(self::$transferTypes[$bizType][$walletType])) {
            return self::$transferTypes[$bizType][$walletType];
        }
        
        return isset(self::$bizTypes[$bizType]) ? self::$bizTypes[$bizType] : ($bizType ?: '其他');
    }

    /**
     * 获取所有类型配置（供前端API调用）
     */
    public static function getTypeConfigs()
    {
        return [
            'wallet_types' => self::$walletTypes,
            'change_types' => self::$changeTypes,
            'biz_types' => self::$bizTypes,
            'transfer_types' => self::$transferTypes
        ];
    }

    public static function getUserLogs($userId, $walletType = null, $page = 1, $limit = 20)
    {
        $query = self::where('user_id', $userId);
        if ($walletType !== null) {
            $query->where('wallet_type', $walletType);
        }
        return $query->order('id', 'desc')->paginate(['page' => $page, 'list_rows' => $limit]);
    }
}
