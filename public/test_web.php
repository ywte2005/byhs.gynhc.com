<?php
/**
 * Web版测试页面
 * 通过浏览器访问进行测试
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

// 获取操作类型
$action = isset($_GET['action']) ? $_GET['action'] : 'index';

// 设置响应头
header('Content-Type: text/html; charset=utf-8');

?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商户互助平台 - 测试工具</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .header h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .header p {
            color: #666;
        }
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .card h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
        }
        .btn:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .btn-success {
            background: #10b981;
        }
        .btn-success:hover {
            background: #059669;
        }
        .btn-danger {
            background: #ef4444;
        }
        .btn-danger:hover {
            background: #dc2626;
        }
        .result {
            background: #f3f4f6;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.6;
        }
        .success {
            color: #10b981;
        }
        .error {
            color: #ef4444;
        }
        .info {
            color: #3b82f6;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        .table th {
            background: #f9fafb;
            font-weight: 600;
            color: #374151;
        }
        .table tr:hover {
            background: #f9fafb;
        }
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }
        .badge-error {
            background: #fee2e2;
            color: #991b1b;
        }
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .loading.show {
            display: block;
        }
        .spinner {
            border: 4px solid #f3f4f6;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 商户互助平台 - 测试工具</h1>
            <p>通过Web界面进行数据库检查、创建测试用户和API测试</p>
        </div>

        <?php if ($action === 'index'): ?>
            <!-- 主页 -->
            <div class="card">
                <h2>📋 测试步骤</h2>
                <ol style="line-height: 2; color: #666;">
                    <li>检查数据库连接和初始化</li>
                    <li>创建测试用户（3个用户及推广关系）</li>
                    <li>使用Postman测试API接口</li>
                    <li>在HBuilderX中运行前端进行联调</li>
                </ol>
            </div>

            <div class="card">
                <h2>🔧 测试工具</h2>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-top: 20px;">
                    <a href="?action=check_database" class="btn">1. 检查数据库</a>
                    <a href="?action=create_users" class="btn btn-success">2. 创建测试用户</a>
                    <a href="?action=view_users" class="btn">3. 查看测试用户</a>
                </div>
            </div>

            <div class="card">
                <h2>📚 测试文档</h2>
                <ul style="line-height: 2; color: #666;">
                    <li><a href="线上服务器测试指南.md" target="_blank" style="color: #667eea;">线上服务器测试指南</a></li>
                    <li><a href="接口测试指南.md" target="_blank" style="color: #667eea;">接口测试指南</a></li>
                    <li><a href="前后端联调指南.md" target="_blank" style="color: #667eea;">前后端联调指南</a></li>
                </ul>
            </div>

        <?php elseif ($action === 'check_database'): ?>
            <!-- 检查数据库 -->
            <div class="card">
                <h2>🔍 数据库检查结果</h2>
                <?php
                try {
                    // 测试数据库连接
                    $result = Db::query('SELECT 1');
                    echo '<div class="result">';
                    echo '<div class="success">✓ 数据库连接成功</div><br>';
                    
                    // 检查数据表
                    $tables = [
                        'fa_promo_level' => '等级配置表',
                        'fa_promo_relation' => '推广关系表',
                        'fa_promo_commission' => '佣金记录表',
                        'fa_promo_bonus_config' => '分红配置表',
                        'fa_promo_bonus' => '分红记录表',
                        'fa_promo_performance' => '业绩统计表',
                        'fa_merchant' => '商户信息表',
                        'fa_merchant_audit' => '商户审核记录表',
                        'fa_mutual_task' => '互助主任务表',
                        'fa_sub_task' => '子任务表',
                        'fa_wallet' => '用户钱包表',
                        'fa_wallet_log' => '钱包流水表',
                        'fa_wallet_withdraw' => '提现记录表',
                        'fa_wallet_recharge' => '充值记录表',
                        'fa_reward_rule' => '奖励规则表',
                        'fa_profit_rule' => '分润规则表',
                    ];
                    
                    echo '<strong>数据表检查：</strong><br>';
                    $existTables = 0;
                    foreach ($tables as $table => $desc) {
                        $exists = Db::query("SHOW TABLES LIKE '{$table}'");
                        if ($exists) {
                            echo '<span class="success">✓</span> ' . $desc . ' (' . $table . ')<br>';
                            $existTables++;
                        } else {
                            echo '<span class="error">✗</span> ' . $desc . ' (' . $table . ') - 不存在<br>';
                        }
                    }
                    echo '<br><strong>共检查 ' . count($tables) . ' 张表，存在 ' . $existTables . ' 张</strong><br><br>';
                    
                    // 检查初始化数据
                    echo '<strong>初始化数据检查：</strong><br>';
                    $levelCount = Db::table('fa_promo_level')->count();
                    echo '等级配置: ' . $levelCount . ' 条<br>';
                    
                    $bonusCount = Db::table('fa_promo_bonus_config')->count();
                    echo '分红配置: ' . $bonusCount . ' 条<br>';
                    
                    $rewardCount = Db::table('fa_reward_rule')->count();
                    echo '奖励规则: ' . $rewardCount . ' 条<br>';
                    
                    $profitCount = Db::table('fa_profit_rule')->count();
                    echo '分润规则: ' . $profitCount . ' 条<br>';
                    
                    $userCount = Db::table('fa_user')->count();
                    echo '用户总数: ' . $userCount . ' 个<br><br>';
                    
                    if ($existTables == count($tables) && $levelCount >= 6 && $bonusCount >= 4 && $rewardCount >= 6 && $profitCount >= 5) {
                        echo '<div class="success"><strong>✓ 数据库初始化完整，可以开始测试！</strong></div>';
                    } else {
                        echo '<div class="error"><strong>✗ 数据库初始化不完整，请先导入SQL文件！</strong></div>';
                        echo '<br><strong>导入步骤：</strong><br>';
                        echo '1. 登录phpMyAdmin<br>';
                        echo '2. 选择数据库<br>';
                        echo '3. 点击"导入"标签<br>';
                        echo '4. 按顺序导入backend/database/目录下的SQL文件<br>';
                    }
                    
                    echo '</div>';
                } catch (\Exception $e) {
                    echo '<div class="result">';
                    echo '<div class="error">✗ 错误: ' . htmlspecialchars($e->getMessage()) . '</div>';
                    echo '</div>';
                }
                ?>
                <div style="margin-top: 20px;">
                    <a href="?action=index" class="btn">返回首页</a>
                </div>
            </div>

        <?php elseif ($action === 'create_users'): ?>
            <!-- 创建测试用户 -->
            <div class="card">
                <h2>👥 创建测试用户</h2>
                <?php
                try {
                    Db::startTrans();
                    
                    echo '<div class="result">';
                    
                    // 创建用户A
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
                        echo '<span class="success">✓</span> 用户A创建成功 (ID: ' . $userA->id . ')<br>';
                    } else {
                        echo '<span class="info">ℹ</span> 用户A已存在 (ID: ' . $userA->id . ')<br>';
                    }
                    
                    // 创建推广关系A
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
                    }
                    
                    // 创建钱包A
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
                    }
                    
                    // 创建用户B
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
                        echo '<span class="success">✓</span> 用户B创建成功 (ID: ' . $userB->id . ')<br>';
                    } else {
                        echo '<span class="info">ℹ</span> 用户B已存在 (ID: ' . $userB->id . ')<br>';
                    }
                    
                    // 创建推广关系B
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
                    }
                    
                    // 创建钱包B
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
                    }
                    
                    // 创建用户C
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
                        echo '<span class="success">✓</span> 用户C创建成功 (ID: ' . $userC->id . ')<br>';
                    } else {
                        echo '<span class="info">ℹ</span> 用户C已存在 (ID: ' . $userC->id . ')<br>';
                    }
                    
                    // 创建推广关系C
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
                    }
                    
                    // 创建钱包C
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
                    }
                    
                    Db::commit();
                    
                    echo '<br><div class="success"><strong>✓ 测试用户创建完成！</strong></div>';
                    echo '</div>';
                    
                    // 显示用户信息表格
                    echo '<table class="table">';
                    echo '<thead><tr><th>用户</th><th>账号</th><th>密码</th><th>手机号</th><th>Token</th><th>邀请码</th></tr></thead>';
                    echo '<tbody>';
                    echo '<tr>';
                    echo '<td>用户A</td>';
                    echo '<td>testuser_a</td>';
                    echo '<td>123456</td>';
                    echo '<td>13800000001</td>';
                    echo '<td><code>' . substr($userA->token, 0, 20) . '...</code></td>';
                    echo '<td>' . $relationA->invite_code . '</td>';
                    echo '</tr>';
                    echo '<tr>';
                    echo '<td>用户B</td>';
                    echo '<td>testuser_b</td>';
                    echo '<td>123456</td>';
                    echo '<td>13800000002</td>';
                    echo '<td><code>' . substr($userB->token, 0, 20) . '...</code></td>';
                    echo '<td>' . $relationB->invite_code . '</td>';
                    echo '</tr>';
                    echo '<tr>';
                    echo '<td>用户C</td>';
                    echo '<td>testuser_c</td>';
                    echo '<td>123456</td>';
                    echo '<td>13800000003</td>';
                    echo '<td><code>' . substr($userC->token, 0, 20) . '...</code></td>';
                    echo '<td>' . $relationC->invite_code . '</td>';
                    echo '</tr>';
                    echo '</tbody>';
                    echo '</table>';
                    
                } catch (\Exception $e) {
                    Db::rollback();
                    echo '<div class="result">';
                    echo '<div class="error">✗ 错误: ' . htmlspecialchars($e->getMessage()) . '</div>';
                    echo '</div>';
                }
                ?>
                <div style="margin-top: 20px;">
                    <a href="?action=view_users" class="btn btn-success">查看用户详情</a>
                    <a href="?action=index" class="btn">返回首页</a>
                </div>
            </div>

        <?php elseif ($action === 'view_users'): ?>
            <!-- 查看测试用户 -->
            <div class="card">
                <h2>👥 测试用户列表</h2>
                <?php
                try {
                    $users = Db::table('fa_user')
                        ->where('mobile', 'in', ['13800000001', '13800000002', '13800000003'])
                        ->select();
                    
                    if (empty($users)) {
                        echo '<div class="result">';
                        echo '<div class="info">ℹ 还没有创建测试用户，请先创建。</div>';
                        echo '</div>';
                        echo '<div style="margin-top: 20px;">';
                        echo '<a href="?action=create_users" class="btn btn-success">创建测试用户</a>';
                        echo '</div>';
                    } else {
                        echo '<table class="table">';
                        echo '<thead><tr><th>ID</th><th>用户名</th><th>昵称</th><th>手机号</th><th>余额</th><th>Token</th><th>状态</th></tr></thead>';
                        echo '<tbody>';
                        foreach ($users as $user) {
                            echo '<tr>';
                            echo '<td>' . $user['id'] . '</td>';
                            echo '<td>' . $user['username'] . '</td>';
                            echo '<td>' . $user['nickname'] . '</td>';
                            echo '<td>' . $user['mobile'] . '</td>';
                            echo '<td>¥' . number_format($user['money'], 2) . '</td>';
                            echo '<td><code style="font-size: 12px;">' . substr($user['token'], 0, 30) . '...</code></td>';
                            echo '<td><span class="badge badge-success">正常</span></td>';
                            echo '</tr>';
                        }
                        echo '</tbody>';
                        echo '</table>';
                        
                        // 显示推广关系
                        echo '<h3 style="margin-top: 30px; margin-bottom: 15px;">推广关系</h3>';
                        $relations = Db::table('fa_promo_relation')
                            ->alias('r')
                            ->join('fa_user u', 'r.user_id = u.id')
                            ->where('u.mobile', 'in', ['13800000001', '13800000002', '13800000003'])
                            ->field('r.*, u.username, u.nickname')
                            ->order('r.depth', 'asc')
                            ->select();
                        
                        echo '<div class="result">';
                        foreach ($relations as $relation) {
                            $indent = str_repeat('&nbsp;&nbsp;&nbsp;&nbsp;', $relation['depth']);
                            $arrow = $relation['depth'] > 0 ? '└─ ' : '';
                            echo $indent . $arrow . $relation['nickname'] . ' (' . $relation['username'] . ') - 邀请码: ' . $relation['invite_code'] . '<br>';
                        }
                        echo '</div>';
                    }
                } catch (\Exception $e) {
                    echo '<div class="result">';
                    echo '<div class="error">✗ 错误: ' . htmlspecialchars($e->getMessage()) . '</div>';
                    echo '</div>';
                }
                ?>
                <div style="margin-top: 20px;">
                    <a href="?action=index" class="btn">返回首页</a>
                </div>
            </div>

        <?php endif; ?>

        <div class="card">
            <h2>📞 技术支持</h2>
            <p style="color: #666; line-height: 1.8;">
                如果遇到问题，请查看：<br>
                1. <a href="线上服务器测试指南.md" target="_blank" style="color: #667eea;">线上服务器测试指南</a><br>
                2. 检查数据库配置：application/database.php<br>
                3. 查看错误日志：runtime/log/<br>
            </p>
        </div>
    </div>
</body>
</html>
