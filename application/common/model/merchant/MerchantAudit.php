<?php
namespace app\common\model\merchant;

use think\Model;

class MerchantAudit extends Model
{
    protected $name = 'merchant_audit';
    protected $autoWriteTimestamp = 'int';
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    public function merchant()
    {
        return $this->belongsTo('app\common\model\merchant\Merchant', 'merchant_id', 'id');
    }

    public function admin()
    {
        return $this->belongsTo('app\admin\model\Admin', 'admin_id', 'id');
    }
}
