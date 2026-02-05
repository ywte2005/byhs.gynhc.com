<?php
/**
 * 数据库连接测试脚本
 * 用于验证数据库是否正确初始化
 */

// 引入ThinkPHP框架
define('APP_PATH', __DIR__ . '/application/');
define('RUNTIME_PATH', __DIR__ . '/runtime/');
define('ROOT_PATH', __DIR__ . '/');
define('EXTEND_PATH', __DIR__ . '/extend/');
define('VENDOR_PATH', __DIR__ . '/vendor/');
define('CONF_PATH', __DIR__ . '/application/');

// 加载框架引导文件
require __DIR__ . '/thinkphp/start.php';

use think\Db;

echo "=================================\n";
echo "数据库连接测试\n";
echo "=================================\n\n";

try {
    // 测试数据库连接
    echo "1. 测试数据库连接...\n";
    $result = Db::query('SELECT 1');
    echo "   ✓ 数据库连接成功\n\n";
    
    // 检查数据表是否存在
    echo "2. 检查数据表...\n";
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
    
    $existTables = 0;
    foreach ($tables as $table => $desc) {
        $exists = Db::query("SHOW TABLES LIKE '{$table}'");
        if ($exists) {
            echo "   ✓ {$desc} ({$table})\n";
            $existTables++;
        } else {
            echo "   ✗ {$desc} ({$table}) - 不存在\n";
        }
    }
    echo "\n   共检查 " . count($tables) . " 张表，存在 {$existTables} 张\n\n";
    
    // 检查初始化数据
    echo "3. 检查初始化数据...\n";
    
    // 检查等级配置
    $levelCount = Db::table('fa_promo_level')->count();
    echo "   等级配置: {$levelCount} 条\n";
    
    // 检查分红配置
    $bonusCount = Db::table('fa_promo_bonus_config')->count();
    echo "   分红配置: {$bonusCount} 条\n";
    
    // 检查奖励规则
    $rewardCount = Db::table('fa_reward_rule')->count();
    echo "   奖励规则: {$rewardCount} 条\n";
    
    // 检查分润规则
    $profitCount = Db::table('fa_profit_rule')->count();
    echo "   分润规则: {$profitCount} 条\n";
    
    echo "\n";
    
    // 检查用户表
    echo "4. 检查用户数据...\n";
    $userCount = Db::table('fa_user')->count();
    echo "   用户总数: {$userCount} 个\n\n";
    
    echo "=================================\n";
    echo "测试完成！\n";
    echo "=================================\n";
    
    if ($existTables == count($tables) && $levelCount >= 6 && $bonusCount >= 4 && $rewardCount >= 6 && $profitCount >= 5) {
        echo "\n✓ 数据库初始化完整，可以开始测试！\n\n";
        exit(0);
    } else {
        echo "\n✗ 数据库初始化不完整，请先执行SQL文件！\n\n";
        exit(1);
    }
    
} catch (\Exception $e) {
    echo "\n✗ 错误: " . $e->getMessage() . "\n\n";
    exit(1);
}
