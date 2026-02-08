<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\library\WalletService;

class Wallet extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    public function info()
    {
        $userId = $this->auth->id;
        $wallet = WalletService::getWallet($userId);
        
        $this->success('获取成功', [
            'wallet' => [
                'balance' => $wallet->balance,
                'deposit' => $wallet->deposit,
                'frozen' => $wallet->frozen,
                'mutual_balance' => $wallet->mutual_balance,
                'total_income' => $wallet->total_income,
                'total_withdraw' => $wallet->total_withdraw,
                'available_deposit' => $wallet->getAvailableDeposit()
            ]
        ]);
    }

    public function logs()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        $walletType = $this->request->get('wallet_type', null);
        
        $userId = $this->auth->id;
        $list = WalletService::getLogs($userId, $walletType, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function recharge()
    {
        $amount = $this->request->post('amount');
        $target = $this->request->post('target', 'balance');
        $payMethod = $this->request->post('pay_method', '');
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        
        $userId = $this->auth->id;
        
        if ($target === 'deposit') {
            $recharge = WalletService::rechargeDeposit($userId, $amount, $payMethod);
        } else {
            $recharge = WalletService::rechargeBalance($userId, $amount, $payMethod);
        }
        
        $this->success('创建成功', ['recharge' => $recharge]);
    }

    public function withdraw()
    {
        $amount = $this->request->post('amount');
        $bankInfo = [
            'bank_name' => $this->request->post('bank_name'),
            'bank_account' => $this->request->post('bank_account'),
            'bank_branch' => $this->request->post('bank_branch', ''),
            'account_name' => $this->request->post('account_name')
        ];
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        if (!$bankInfo['bank_name'] || !$bankInfo['bank_account'] || !$bankInfo['account_name']) {
            $this->error('银行信息不完整');
        }
        
        $userId = $this->auth->id;
        
        $withdraw = WalletService::createWithdraw($userId, $amount, $bankInfo);
        
        $this->success('提现申请已提交', ['withdraw' => $withdraw]);
    }

    public function withdrawRecords()
    {
        $page = $this->request->get('page', 1);
        $limit = $this->request->get('limit', 20);
        
        $userId = $this->auth->id;
        $list = WalletService::getWithdrawRecords($userId, $page, $limit);
        
        $this->success('获取成功', ['list' => $list->items(), 'total' => $list->total()]);
    }

    public function depositPay()
    {
        $amount = $this->request->post('amount');
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        
        $userId = $this->auth->id;
        
        WalletService::changeBalance($userId, '-' . $amount, 'deposit_pay', 0, '充值保证金');
        WalletService::changeDeposit($userId, $amount, 'deposit_pay', 0, '充值保证金');
        
        $wallet = WalletService::getWallet($userId);
        $this->success('充值成功', ['wallet' => $wallet]);
    }

    public function depositWithdraw()
    {
        $amount = $this->request->post('amount');
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        
        $userId = $this->auth->id;
        
        $wallet = WalletService::getWallet($userId);
        $available = $wallet->getAvailableDeposit();
        
        if (bccomp($available, $amount, 2) < 0) {
            $this->error('可用保证金不足');
        }
        
        WalletService::changeDeposit($userId, '-' . $amount, 'deposit_withdraw', 0, '提取保证金');
        WalletService::changeBalance($userId, $amount, 'deposit_withdraw', 0, '提取保证金');
        
        $wallet = WalletService::getWallet($userId);
        $this->success('提取成功', ['wallet' => $wallet]);
    }

    public function withdrawConfig()
    {
        $config = \think\Db::name('system_config_ext')
            ->where('group', 'wallet')
            ->column('value', 'key');
        
        $this->success('获取成功', [
            'min_amount' => floatval($config['withdraw_min_amount'] ?? 100),
            'max_amount' => floatval($config['withdraw_max_amount'] ?? 50000),
            'fee_rate' => floatval($config['withdraw_fee_rate'] ?? 0.006),
            'fee_min' => floatval($config['withdraw_fee_min'] ?? 2)
        ]);
    }

    public function bankcards()
    {
        $userId = $this->auth->id;
        $list = \app\common\model\wallet\Bankcard::getUserBankcards($userId);
        
        $result = [];
        foreach ($list as $item) {
            $result[] = [
                'id' => $item->id,
                'bank_name' => $item->bank_name,
                'bank_code' => $item->bank_code,
                'card_no' => $item->masked_card_no,
                'card_holder' => $item->card_holder,
                'bank_branch' => $item->bank_branch,
                'is_default' => $item->is_default
            ];
        }
        
        $this->success('获取成功', ['list' => $result]);
    }

    public function bankList()
    {
        $list = \app\common\model\BankConfig::getAvailableBanks();
        
        $result = [];
        foreach ($list as $item) {
            $result[] = [
                'id' => $item->id,
                'bank_name' => $item->bank_name,
                'bank_code' => $item->bank_code,
                'bank_logo' => $item->bank_logo
            ];
        }
        
        $this->success('获取成功', ['list' => $result]);
    }

    public function addBankcard()
    {
        $data = [
            'bank_name' => $this->request->post('bank_name'),
            'bank_code' => $this->request->post('bank_code', ''),
            'card_no' => $this->request->post('card_no'),
            'card_holder' => $this->request->post('card_holder'),
            'bank_branch' => $this->request->post('bank_branch', '')
        ];
        
        if (!$data['bank_name'] || !$data['card_no'] || !$data['card_holder']) {
            $this->error('参数不完整');
        }
        
        $userId = $this->auth->id;
        
        $bankcard = \app\common\model\wallet\Bankcard::addBankcard($userId, $data);
        
        $this->success('添加成功', ['bankcard' => [
            'id' => $bankcard->id,
            'bank_name' => $bankcard->bank_name,
            'card_no' => $bankcard->masked_card_no,
            'is_default' => $bankcard->is_default
        ]]);
    }

    public function deleteBankcard()
    {
        $bankcardId = $this->request->post('bankcard_id');
        if (!$bankcardId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        \app\common\model\wallet\Bankcard::deleteBankcard($userId, $bankcardId);
        
        $this->success('删除成功');
    }

    public function setDefaultBankcard()
    {
        $bankcardId = $this->request->post('bankcard_id');
        if (!$bankcardId) {
            $this->error('参数缺失');
        }
        
        $userId = $this->auth->id;
        
        $bankcard = \app\common\model\wallet\Bankcard::setDefault($userId, $bankcardId);
        
        $this->success('设置成功', ['bankcard' => [
            'id' => $bankcard->id,
            'is_default' => $bankcard->is_default
        ]]);
    }
}
