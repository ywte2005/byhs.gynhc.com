#!/bin/bash

echo "========================================"
echo "商户互助平台 - 自动化测试"
echo "========================================"
echo ""

echo "[步骤1] 检查数据库连接和初始化..."
php test_database.php
if [ $? -ne 0 ]; then
    echo ""
    echo "✗ 数据库检查失败！"
    echo "请先执行以下命令初始化数据库："
    echo ""
    echo "cd backend/database"
    echo "mysql -u root -p fastadmin < 01_promo_tables.sql"
    echo "mysql -u root -p fastadmin < 02_merchant_tables.sql"
    echo "mysql -u root -p fastadmin < 03_task_tables.sql"
    echo "mysql -u root -p fastadmin < 04_wallet_tables.sql"
    echo "mysql -u root -p fastadmin < 05_config_tables.sql"
    echo "mysql -u root -p fastadmin < 06_init_data.sql"
    echo ""
    exit 1
fi

echo ""
echo "[步骤2] 创建测试用户..."
php create_test_users.php
if [ $? -ne 0 ]; then
    echo ""
    echo "✗ 创建测试用户失败！"
    exit 1
fi

echo ""
echo "[步骤3] 运行API接口测试..."
php test_api.php

echo ""
echo "========================================"
echo "测试完成！"
echo "========================================"
echo ""
echo "下一步："
echo "1. 查看测试结果"
echo "2. 在HBuilderX中打开前端项目（backend/cool-unix）"
echo "3. 运行前端项目进行联调测试"
echo ""
