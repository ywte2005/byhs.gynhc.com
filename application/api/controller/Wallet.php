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
        
        try {
            if ($target === 'deposit') {
                $recharge = WalletService::rechargeDeposit($userId, $amount, $payMethod);
            } else {
                $recharge = WalletService::rechargeBalance($userId, $amount, $payMethod);
            }
            $this->success('创建成功', ['recharge' => $recharge]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
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
        
        try {
            $withdraw = WalletService::createWithdraw($userId, $amount, $bankInfo);
            $this->success('提现申请已提交', ['withdraw' => $withdraw]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
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
        
        try {
            WalletService::changeBalance($userId, '-' . $amount, 'deposit_pay', 0, '充值保证金');
            WalletService::changeDeposit($userId, $amount, 'deposit_pay', 0, '充值保证金');
            
            $wallet = WalletService::getWallet($userId);
            $this->success('充值成功', ['wallet' => $wallet]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function depositWithdraw()
    {
        $amount = $this->request->post('amount');
        
        if (!$amount || $amount <= 0) {
            $this->error('金额必须大于0');
        }
        
        $userId = $this->auth->id;
        
        try {
            $wallet = WalletService::getWallet($userId);
            $available = $wallet->getAvailableDeposit();
            
            if (bccomp($available, $amount, 2) < 0) {
                $this->error('可用保证金不足');
            }
            
            WalletService::changeDeposit($userId, '-' . $amount, 'deposit_withdraw', 0, '提取保证金');
            WalletService::changeBalance($userId, $amount, 'deposit_withdraw', 0, '提取保证金');
            
            $wallet = WalletService::getWallet($userId);
            $this->success('提取成功', ['wallet' => $wallet]);
        } catch (\Exception $e) {
            $this->error($e->getMessage());
        }
    }
}
