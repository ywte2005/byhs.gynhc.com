<?php
namespace app\common\model;

use think\Model;

class BankConfig extends Model
{
    protected $name = 'bank_config';
    protected $autoWriteTimestamp = true;
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    /**
     * 获取所有可用银行列表
     */
    public static function getAvailableBanks()
    {
        return self::where('status', 'normal')
            ->order('sort', 'asc')
            ->order('id', 'asc')
            ->select();
    }

    /**
     * 根据银行代码获取银行信息
     */
    public static function getByCode($bankCode)
    {
        return self::where('bank_code', $bankCode)
            ->where('status', 'normal')
            ->find();
    }

    /**
     * 根据银行名称获取银行信息
     */
    public static function getByName($bankName)
    {
        return self::where('bank_name', $bankName)
            ->where('status', 'normal')
            ->find();
    }
}
