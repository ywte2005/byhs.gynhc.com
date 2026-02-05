<?php
/**
 * 创建测试用户脚本
 * 用于生成测试数据
 */

// 引入ThinkPHP框架
define('APP_PATH', __DIR__ . '/application/');
define('RUNTIME_PATH', __DIR__ . '/runtime/');
define('ROOT_PATH', __DIR__ . '/');
define('EXTEND_PATH', __DIR__ . '/extend/');
define('VENDOR_PATH', __DIR__ . '/vendor/');
define('CONF_PATH', __DIR__ . '/application/');

require __DIR__ . '/thinkphp/start.php';

use think\Db;
use app\common\model\User;
use app\common\model\promo\Relation;
use app\common\model\wallet\Wallet;

echo "=================================\n";
echo "创建测试用户\n";
echo "=================================\n\n";

try {
    Db::startTrans();
    
    // 创建测试用户A（推荐人）
    echo "1. 创建测试用户A（推荐人）...\n";
    $userA = User::where('mobile', '13800000001')->find();
    if (!$userA) {
        $userA = User::create([
            'username' => 'testuser_a',
            'nickname' => '测试用户A',
            'mobile' => '13800000001',
            'password' => md5('123456' . 'testuser_a'),
            'salt' => 'testuser_a',
            'email' => 'usera@test.com',
            'avatar' => '',
            'level' => 1,
            'gender' => 1,
            'birthday' => null,
            'bio' => '测试用户A',
            'money' => 10000.00,
            'score' => 0,
            'successions' => 1,
            'maxsuccessions' => 1,
            'prevtime' => time(),
            'logintime' => time(),
            'loginip' => '127.0.0.1',
            'loginfailure' => 0,
            'joinip' => '127.0.0.1',
            'jointime' => time(),
            'createtime' => time(),
            'updatetime' => time(),
            'token' => md5(uniqid() . time()),
            'status' => 'normal',
        ]);
        echo "   ✓ 用户A创建成功 (ID: {$userA->id})\n";
    } else {
        echo "   ✓ 用户A已存在 (ID: {$userA->id})\n";
    }
    
    // 创建推广关系
    $relationA = Relation::where('user_id', $userA->id)->find();
    if (!$relationA) {
        $relationA = Relation::create([
            'user_id' => $userA->id,
            'parent_id' => 0,
            'level_id' => 1,
            'invite_code' => 'TEST' . str_pad($userA->id, 6, '0', STR_PAD_LEFT),
            'path' => '0',
            'depth' => 0,
            'createtime' => time(),
        ]);
        echo "   ✓ 推广关系创建成功\n";
    }
    
    // 创建钱包
    $walletA = Wallet::where('user_id', $userA->id)->find();
    if (!$walletA) {
        $walletA = Wallet::create([
            'user_id' => $userA->id,
            'balance' => 10000.00,
            'frozen_balance' => 0.00,
            'deposit_balance' => 5000.00,
            'frozen_deposit' => 0.00,
            'mutual_balance' => 0.00,
            'createtime' => time(),
            'updatetime' => time(),
        ]);
        echo "   ✓ 钱包创建成功\n";
    }
    
    echo "\n";
    
    // 创建测试用户B（下级）
    echo "2. 创建测试用户B（用户A的下级）...\n";
    $userB = User::where('mobile', '13800000002')->find();
    if (!$userB) {
        $userB = User::create([
            'username' => 'testuser_b',
            'nickname' => '测试用户B',
            'mobile' => '13800000002',
            'password' => md5('123456' . 'testuser_b'),
            'salt' => 'testuser_b',
            'email' => 'userb@test.com',
            'avatar' => '',
            'level' => 1,
            'gender' => 1,
            'birthday' => null,
            'bio' => '测试用户B',
            'money' => 10000.00,
            'score' => 0,
            'successions' => 1,
            'maxsuccessions' => 1,
            'prevtime' => time(),
            'logintime' => time(),
            'loginip' => '127.0.0.1',
            'loginfailure' => 0,
            'joinip' => '127.0.0.1',
            'jointime' => time(),
            'createtime' => time(),
            'updatetime' => time(),
            'token' => md5(uniqid() . time()),
            'status' => 'normal',
        ]);
        echo "   ✓ 用户B创建成功 (ID: {$userB->id})\n";
    } else {
        echo "   ✓ 用户B已存在 (ID: {$userB->id})\n";
    }
    
    // 创建推广关系（用户B是用户A的下级）
    $relationB = Relation::where('user_id', $userB->id)->find();
    if (!$relationB) {
        $relationB = Relation::create([
            'user_id' => $userB->id,
            'parent_id' => $userA->id,
            'level_id' => 1,
            'invite_code' => 'TEST' . str_pad($userB->id, 6, '0', STR_PAD_LEFT),
            'path' => '0,' . $userA->id,
            'depth' => 1,
            'createtime' => time(),
        ]);
        echo "   ✓ 推广关系创建成功（绑定到用户A）\n";
    }
    
    // 创建钱包
    $walletB = Wallet::where('user_id', $userB->id)->find();
    if (!$walletB) {
        $walletB = Wallet::create([
            'user_id' => $userB->id,
            'balance' => 10000.00,
            'frozen_balance' => 0.00,
            'deposit_balance' => 5000.00,
            'frozen_deposit' => 0.00,
            'mutual_balance' => 0.00,
            'createtime' => time(),
            'updatetime' => time(),
        ]);
        echo "   ✓ 钱包创建成功\n";
    }
    
    echo "\n";
    
    // 创建测试用户C（用户B的下级）
    echo "3. 创建测试用户C（用户B的下级）...\n";
    $userC = User::where('mobile', '13800000003')->find();
    if (!$userC) {
        $userC = User::create([
            'username' => 'testuser_c',
            'nickname' => '测试用户C',
            'mobile' => '13800000003',
            'password' => md5('123456' . 'testuser_c'),
            'salt' => 'testuser_c',
            'email' => 'userc@test.com',
            'avatar' => '',
            'level' => 1,
            'gender' => 1,
            'birthday' => null,
            'bio' => '测试用户C',
            'money' => 10000.00,
            'score' => 0,
            'successions' => 1,
            'maxsuccessions' => 1,
            'prevtime' => time(),
            'logintime' => time(),
            'loginip' => '127.0.0.1',
            'loginfailure' => 0,
            'joinip' => '127.0.0.1',
            'jointime' => time(),
            'createtime' => time(),
            'updatetime' => time(),
            'token' => md5(uniqid() . time()),
            'status' => 'normal',
        ]);
        echo "   ✓ 用户C创建成功 (ID: {$userC->id})\n";
    } else {
        echo "   ✓ 用户C已存在 (ID: {$userC->id})\n";
    }
    
    // 创建推广关系（用户C是用户B的下级）
    $relationC = Relation::where('user_id', $userC->id)->find();
    if (!$relationC) {
        $relationC = Relation::create([
            'user_id' => $userC->id,
            'parent_id' => $userB->id,
            'level_id' => 1,
            'invite_code' => 'TEST' . str_pad($userC->id, 6, '0', STR_PAD_LEFT),
            'path' => '0,' . $userA->id . ',' . $userB->id,
            'depth' => 2,
            'createtime' => time(),
        ]);
        echo "   ✓ 推广关系创建成功（绑定到用户B）\n";
    }
    
    // 创建钱包
    $walletC = Wallet::where('user_id', $userC->id)->find();
    if (!$walletC) {
        $walletC = Wallet::create([
            'user_id' => $userC->id,
            'balance' => 10000.00,
            'frozen_balance' => 0.00,
            'deposit_balance' => 5000.00,
            'frozen_deposit' => 0.00,
            'mutual_balance' => 0.00,
            'createtime' => time(),
            'updatetime' => time(),
        ]);
        echo "   ✓ 钱包创建成功\n";
    }
    
    Db::commit();
    
    echo "\n=================================\n";
    echo "测试用户创建完成！\n";
    echo "=================================\n\n";
    
    echo "用户信息：\n";
    echo "----------------------------------------\n";
    echo "用户A:\n";
    echo "  账号: testuser_a / 13800000001\n";
    echo "  密码: 123456\n";
    echo "  Token: {$userA->token}\n";
    echo "  邀请码: {$relationA->invite_code}\n";
    echo "  余额: 10000.00 元\n";
    echo "  保证金: 5000.00 元\n";
    echo "\n";
    
    echo "用户B (用户A的下级):\n";
    echo "  账号: testuser_b / 13800000002\n";
    echo "  密码: 123456\n";
    echo "  Token: {$userB->token}\n";
    echo "  邀请码: {$relationB->invite_code}\n";
    echo "  余额: 10000.00 元\n";
    echo "  保证金: 5000.00 元\n";
    echo "\n";
    
    echo "用户C (用户B的下级):\n";
    echo "  账号: testuser_c / 13800000003\n";
    echo "  密码: 123456\n";
    echo "  Token: {$userC->token}\n";
    echo "  邀请码: {$relationC->invite_code}\n";
    echo "  余额: 10000.00 元\n";
    echo "  保证金: 5000.00 元\n";
    echo "\n";
    
    echo "推广关系：\n";
    echo "  用户A (顶级)\n";
    echo "    └─ 用户B (1级下级)\n";
    echo "        └─ 用户C (2级下级)\n";
    echo "\n";
    
} catch (\Exception $e) {
    Db::rollback();
    echo "\n✗ 错误: " . $e->getMessage() . "\n";
    echo "详细信息: " . $e->getTraceAsString() . "\n\n";
    exit(1);
}
