<?php
namespace app\common\model\merchant;

use think\Model;

class MerchantAudit extends Model
{
    protected $name = 'merchant_audit';
    protected $autoWriteTimestamp = 'createtime';
    protected $updateTime = false;

    public function merchant()
    {
        return $this->belongsTo('app\common\model\merchant\Merchant', 'merchant_id', 'id');
    }

    public function admin()
    {
        return $this->belongsTo('app\admin\model\Admin', 'admin_id', 'id');
    }
}
