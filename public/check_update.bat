@echo off
chcp 65001 >nul
echo ========================================
echo 数据库字段更新检查工具
echo ========================================
echo.

echo [1/3] 检查缓存是否已清除...
if exist "..\runtime\cache\*" (
    echo ✗ 缓存目录不为空，正在清除...
    del /s /q ..\runtime\cache\* >nul 2>&1
    echo ✓ 缓存已清除
) else (
    echo ✓ 缓存目录为空
)
echo.

echo [2/3] 检查临时文件是否已清除...
if exist "..\runtime\temp\*" (
    echo ✗ 临时目录不为空，正在清除...
    del /s /q ..\runtime\temp\* >nul 2>&1
    echo ✓ 临时文件已清除
) else (
    echo ✓ 临时目录为空
)
echo.

echo [3/3] 检查更新的文件...
set count=0

if exist "..\application\common\model\promo\Performance.php" (
    set /a count+=1
    echo ✓ Performance.php 存在
) else (
    echo ✗ Performance.php 不存在
)

if exist "..\application\common\library\PromoService.php" (
    set /a count+=1
    echo ✓ PromoService.php 存在
) else (
    echo ✗ PromoService.php 不存在
)

if exist "..\application\common\library\SettlementService.php" (
    set /a count+=1
    echo ✓ SettlementService.php 存在
) else (
    echo ✗ SettlementService.php 不存在
)

if exist "..\application\command\Performance.php" (
    set /a count+=1
    echo ✓ Performance Command 存在
) else (
    echo ✗ Performance Command 不存在
)

if exist "..\application\api\controller\Promo.php" (
    set /a count+=1
    echo ✓ Promo Controller 存在
) else (
    echo ✗ Promo Controller 不存在
)

if exist "..\application\admin\controller\Statistics.php" (
    set /a count+=1
    echo ✓ Statistics Controller 存在
) else (
    echo ✗ Statistics Controller 不存在
)

if exist "..\application\admin\controller\promo\Relation.php" (
    set /a count+=1
    echo ✓ Relation Controller 存在
) else (
    echo ✗ Relation Controller 不存在
)

if exist "..\application\admin\lang\zh-cn\promo\performance.php" (
    set /a count+=1
    echo ✓ performance 语言包存在
) else (
    echo ✗ performance 语言包不存在
)

if exist "..\application\admin\lang\zh-cn\promo\bonus.php" (
    set /a count+=1
    echo ✓ bonus 语言包存在
) else (
    echo ✗ bonus 语言包不存在
)

echo.
echo ========================================
echo 检查完成！已更新文件：%count%/9
echo ========================================
echo.
echo 下一步操作：
echo 1. 访问 http://你的域名/test_field_update.php 运行完整测试
echo 2. 测试核心功能（推广、业绩、分红）
echo 3. 检查错误日志 ..\runtime\log\error_*.log
echo 4. 测试完成后删除 public\test_field_update.php
echo.
pause
