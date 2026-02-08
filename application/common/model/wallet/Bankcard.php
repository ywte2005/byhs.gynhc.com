<?php
namespace app\common\model\wallet;

use think\Model;

class Bankcard extends Model
{
    protected $name = 'user_bankcard';
    protected $autoWriteTimestamp = true;

    // 关联用户
    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }

    public static function getUserBankcards($userId)
    {
        return self::where('user_id', $userId)
            ->where('status', 'normal')
            ->order('is_default', 'desc')
            ->order('id', 'desc')
            ->select();
    }

    public static function getDefaultBankcard($userId)
    {
        return self::where('user_id', $userId)
            ->where('status', 'normal')
            ->where('is_default', 1)
            ->find();
    }

    public static function addBankcard($userId, $data)
    {
        $exists = self::where('user_id', $userId)
            ->where('card_no', $data['card_no'])
            ->where('status', 'normal')
            ->find();
        
        if ($exists) {
            throw new \Exception('该银行卡已添加');
        }

        $count = self::where('user_id', $userId)
            ->where('status', 'normal')
            ->count();

        $bankcard = self::create([
            'user_id' => $userId,
            'bank_name' => $data['bank_name'],
            'bank_code' => $data['bank_code'] ?? '',
            'card_no' => $data['card_no'],
            'card_holder' => $data['card_holder'],
            'bank_branch' => $data['bank_branch'] ?? '',
            'is_default' => $count == 0 ? 1 : 0
        ]);

        return $bankcard;
    }

    public static function setDefault($userId, $bankcardId)
    {
        $bankcard = self::where('id', $bankcardId)
            ->where('user_id', $userId)
            ->where('status', 'normal')
            ->find();

        if (!$bankcard) {
            throw new \Exception('银行卡不存在');
        }

        self::where('user_id', $userId)->update(['is_default' => 0]);
        
        $bankcard->is_default = 1;
        $bankcard->save();

        return $bankcard;
    }

    public static function deleteBankcard($userId, $bankcardId)
    {
        $bankcard = self::where('id', $bankcardId)
            ->where('user_id', $userId)
            ->where('status', 'normal')
            ->find();

        if (!$bankcard) {
            throw new \Exception('银行卡不存在');
        }

        $bankcard->status = 'disabled';
        $bankcard->save();

        if ($bankcard->is_default) {
            $another = self::where('user_id', $userId)
                ->where('status', 'normal')
                ->order('id', 'desc')
                ->find();
            
            if ($another) {
                $another->is_default = 1;
                $another->save();
            }
        }

        return true;
    }

    public function getMaskedCardNoAttr($value, $data)
    {
        $cardNo = $data['card_no'] ?? '';
        if (strlen($cardNo) > 8) {
            return substr($cardNo, 0, 4) . '****' . substr($cardNo, -4);
        }
        return $cardNo;
    }
}
