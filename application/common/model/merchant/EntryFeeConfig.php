<?php
namespace app\common\model\merchant;

use think\Model;

class EntryFeeConfig extends Model
{
    protected $name = 'merchant_entry_fee_config';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    protected $append = ['type_text'];

    public function getTypeTextAttr($value, $data)
    {
        $list = [
            'personal' => '个人',
            'individual' => '个体工商户',
            'enterprise' => '企业'
        ];
        return isset($list[$data['merchant_type']]) ? $list[$data['merchant_type']] : '';
    }

    /**
     * 获取指定类型的入驻费
     */
    public static function getEntryFee($merchantType)
    {
        $config = self::where('merchant_type', $merchantType)
            ->where('status', 'normal')
            ->find();
        
        return $config ? $config->entry_fee : '0.00';
    }

    /**
     * 获取所有配置
     */
    public static function getAllConfigs()
    {
        return self::where('status', 'normal')->select();
    }
}
