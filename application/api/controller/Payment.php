<?php

namespace app\api\controller;

use app\common\controller\Api;
use app\common\model\wallet\Recharge;
use app\common\library\WalletService;
use addons\epay\library\Service as EpayService;
use think\Db;

/**
 * 支付接口
 */
class Payment extends Api
{
    protected $noNeedLogin = ['notify', 'returnUrl'];
    protected $noNeedRight = ['*'];

    /**
     * 发起微信支付
     * @ApiMethod (POST)
     * @ApiParams (name="order_no", type="string", required=true, description="订单号")
     * @ApiParams (name="method", type="string", required=false, description="支付方式:app/miniapp/mp/wap")
     */
    public function wechat()
    {
        $orderNo = $this->request->post('order_no');
        if (!$orderNo) {
            $this->error('订单号不能为空');
        }

        $recharge = Recharge::where('order_no', $orderNo)
            ->where('user_id', $this->auth->id)
            ->find();

        if (!$recharge) {
            $this->error('订单不存在');
        }

        if ($recharge->status !== 'pending') {
            $this->error('订单状态不正确');
        }

        try {
            // 从前端获取支付方式，如果未传则自动判断
            $method = $this->request->post('method', '');
            
            if (!$method) {
                // 根据请求来源自动判断支付方式
                $userAgent = $this->request->server('HTTP_USER_AGENT', '');
                if (strpos($userAgent, 'MicroMessenger') !== false) {
                    $method = 'mp'; // 微信内置浏览器
                } else {
                    $method = 'wap'; // 默认H5支付
                }
            }

            $params = [
                'amount'    => $recharge->amount,
                'orderid'   => $recharge->order_no,
                'type'      => 'wechat',
                'title'     => '余额充值',
                'notifyurl' => $this->request->root(true) . '/api/payment/notify',
                'returnurl' => $this->request->root(true) . '/api/payment/returnUrl?order_no=' . $orderNo,
                'method'    => $method,
            ];

            // 小程序/公众号需要openid
            if (in_array($method, ['miniapp', 'mp'])) {
                $openid = $this->request->post('openid', '');
                if ($openid) {
                    $params['openid'] = $openid;
                } else {
                    // 尝试从用户信息获取openid
                    $user = $this->auth->getUser();
                    if ($user && $user->openid) {
                        $params['openid'] = $user->openid;
                    }
                }
            }

            $result = EpayService::submitOrder($params);

            // 根据不同支付方式返回不同数据
            if ($method === 'app') {
                // APP支付返回支付参数（orderInfo格式）
                $this->success('获取成功', $result);
            } elseif ($method === 'miniapp') {
                // 小程序支付返回JSAPI参数
                $this->success('获取成功', $result);
            } elseif ($method === 'mp') {
                // 微信公众号H5返回JSAPI参数
                $this->success('获取成功', $result);
            } else {
                // 普通H5支付返回跳转URL
                if (is_object($result) && method_exists($result, 'getTargetUrl')) {
                    $this->success('获取成功', ['mweb_url' => $result->getTargetUrl()]);
                } elseif (is_object($result) && method_exists($result, 'getContent')) {
                    // 返回表单内容（用于自动提交）
                    $this->success('获取成功', ['form' => $result->getContent()]);
                } elseif (is_array($result) && isset($result['mweb_url'])) {
                    $this->success('获取成功', $result);
                } else {
                    $this->success('获取成功', $result);
                }
            }
        } catch (\Exception $e) {
            $this->error('支付发起失败：' . $e->getMessage());
        }
    }

    /**
     * 支付回调通知
     */
    public function notify()
    {
        $paytype = $this->request->param('paytype', 'wechat');
        
        try {
            $pay = EpayService::checkNotify($paytype);
            if (!$pay) {
                return 'fail';
            }

            $data = $pay->verify();
            $orderNo = $data['out_trade_no'] ?? '';

            if (!$orderNo) {
                return 'fail';
            }

            Db::startTrans();
            try {
                $recharge = Recharge::lock(true)->where('order_no', $orderNo)->find();
                
                if ($recharge && $recharge->status === 'pending') {
                    // 更新订单状态
                    $recharge->status = 'paid';
                    $recharge->paid_time = time();
                    $recharge->trade_no = $data['transaction_id'] ?? '';
                    $recharge->pay_method = 'wechat';
                    $recharge->save();

                    // 增加用户余额
                    if ($recharge->target === 'balance') {
                        WalletService::changeBalance(
                            $recharge->user_id,
                            $recharge->amount,
                            'recharge',
                            $recharge->id,
                            '充值到账'
                        );
                    } elseif ($recharge->target === 'deposit') {
                        // 充值到保证金
                        WalletService::changeBalance(
                            $recharge->user_id,
                            $recharge->amount,
                            'recharge',
                            $recharge->id,
                            '充值'
                        );
                        WalletService::changeBalance(
                            $recharge->user_id,
                            '-' . $recharge->amount,
                            'deposit_pay',
                            $recharge->id,
                            '保证金充值'
                        );
                        WalletService::changeDeposit(
                            $recharge->user_id,
                            $recharge->amount,
                            'deposit_pay',
                            $recharge->id,
                            '保证金充值'
                        );
                    }
                }

                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                \think\Log::error('支付回调处理失败：' . $e->getMessage());
            }

            return $pay->success();
        } catch (\Exception $e) {
            \think\Log::error('支付回调验证失败：' . $e->getMessage());
            return 'fail';
        }
    }

    /**
     * 支付返回页面
     */
    public function returnUrl()
    {
        $orderNo = $this->request->param('order_no');
        
        // 重定向到前端页面
        $frontendUrl = config('site.frontend_url') ?: '';
        if ($frontendUrl) {
            header('Location: ' . $frontendUrl . '/pages/wallet/index?from=recharge');
        } else {
            echo '<script>window.close();</script>';
            echo '支付完成，请返回APP查看';
        }
        exit;
    }

    /**
     * 查询支付状态
     * @ApiMethod (GET)
     * @ApiParams (name="order_no", type="string", required=true, description="订单号")
     */
    public function query()
    {
        $orderNo = $this->request->get('order_no');
        if (!$orderNo) {
            $this->error('订单号不能为空');
        }

        $recharge = Recharge::where('order_no', $orderNo)
            ->where('user_id', $this->auth->id)
            ->find();

        if (!$recharge) {
            $this->error('订单不存在');
        }

        $this->success('查询成功', [
            'order_no' => $recharge->order_no,
            'status' => $recharge->status,
            'paid' => $recharge->status === 'paid',
            'amount' => $recharge->amount
        ]);
    }
}
