<?php
/**
 * API接口测试脚本
 * 访问：http://localhost/test_api.php
 */

header('Content-Type: text/html; charset=utf-8');

?>
<!DOCTYPE html>
<html>
<head>
    <title>API接口测试</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .test-section h3 { margin-top: 0; color: #333; }
        button { padding: 10px 20px; margin: 5px; cursor: pointer; background: #007bff; color: white; border: none; border-radius: 3px; }
        button:hover { background: #0056b3; }
        .result { margin-top: 10px; padding: 10px; background: #f5f5f5; border-radius: 3px; white-space: pre-wrap; font-family: monospace; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        input { padding: 8px; margin: 5px; width: 200px; }
    </style>
</head>
<body>
    <h1>API接口测试工具</h1>
    <p>测试前端需要的RESTful接口</p>

    <!-- 测试1：获取图片验证码 -->
    <div class="test-section">
        <h3>1. 获取图片验证码</h3>
        <input type="text" id="phone1" placeholder="手机号" value="18000000000">
        <button onclick="testGetCaptcha()">获取验证码</button>
        <div id="result1" class="result"></div>
        <div id="captcha-img"></div>
    </div>

    <!-- 测试2：发送短信验证码 -->
    <div class="test-section">
        <h3>2. 发送短信验证码</h3>
        <input type="text" id="phone2" placeholder="手机号" value="18000000000">
        <input type="text" id="code2" placeholder="图片验证码">
        <input type="text" id="captchaId2" placeholder="验证码ID">
        <button onclick="testSendSms()">发送短信</button>
        <div id="result2" class="result"></div>
    </div>

    <!-- 测试3：手机号登录 -->
    <div class="test-section">
        <h3>3. 手机号登录</h3>
        <input type="text" id="phone3" placeholder="手机号" value="18000000000">
        <input type="text" id="smsCode3" placeholder="短信验证码" value="6666">
        <button onclick="testPhoneLogin()">登录</button>
        <div id="result3" class="result"></div>
    </div>

    <!-- 测试4：获取用户信息 -->
    <div class="test-section">
        <h3>4. 获取用户信息</h3>
        <input type="text" id="token4" placeholder="Token">
        <button onclick="testGetUserInfo()">获取信息</button>
        <div id="result4" class="result"></div>
    </div>

    <!-- 测试5：更新用户信息 -->
    <div class="test-section">
        <h3>5. 更新用户信息</h3>
        <input type="text" id="token5" placeholder="Token">
        <input type="text" id="nickname5" placeholder="昵称" value="测试用户">
        <button onclick="testUpdateUserInfo()">更新信息</button>
        <div id="result5" class="result"></div>
    </div>

    <script>
        const baseUrl = '/api/app/user';
        let globalToken = '';

        function showResult(elementId, data, isSuccess = true) {
            const el = document.getElementById(elementId);
            el.className = 'result ' + (isSuccess ? 'success' : 'error');
            el.textContent = JSON.stringify(data, null, 2);
        }

        async function testGetCaptcha() {
            const phone = document.getElementById('phone1').value;
            try {
                const response = await fetch(`${baseUrl}/login/captcha?phone=${phone}`);
                const data = await response.json();
                showResult('result1', data, data.code === 0);
                
                if (data.code === 0 && data.data) {
                    document.getElementById('captchaId2').value = data.data.captchaId;
                    document.getElementById('captcha-img').innerHTML = 
                        `<img src="${data.data.data}" alt="验证码">`;
                }
            } catch (error) {
                showResult('result1', { error: error.message }, false);
            }
        }

        async function testSendSms() {
            const phone = document.getElementById('phone2').value;
            const code = document.getElementById('code2').value;
            const captchaId = document.getElementById('captchaId2').value;
            
            try {
                const response = await fetch(`${baseUrl}/login/smsCode`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ phone, code, captchaId })
                });
                const data = await response.json();
                showResult('result2', data, data.code === 0);
            } catch (error) {
                showResult('result2', { error: error.message }, false);
            }
        }

        async function testPhoneLogin() {
            const phone = document.getElementById('phone3').value;
            const smsCode = document.getElementById('smsCode3').value;
            
            try {
                const response = await fetch(`${baseUrl}/login/phone`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ phone, smsCode })
                });
                const data = await response.json();
                showResult('result3', data, data.code === 0);
                
                if (data.code === 0 && data.data && data.data.token) {
                    globalToken = data.data.token;
                    document.getElementById('token4').value = globalToken;
                    document.getElementById('token5').value = globalToken;
                    alert('登录成功！Token已自动填充');
                }
            } catch (error) {
                showResult('result3', { error: error.message }, false);
            }
        }

        async function testGetUserInfo() {
            const token = document.getElementById('token4').value || globalToken;
            
            try {
                const response = await fetch(`${baseUrl}/info/person`, {
                    headers: { 'Authorization': token }
                });
                const data = await response.json();
                showResult('result4', data, data.code === 0);
            } catch (error) {
                showResult('result4', { error: error.message }, false);
            }
        }

        async function testUpdateUserInfo() {
            const token = document.getElementById('token5').value || globalToken;
            const nickname = document.getElementById('nickname5').value;
            
            try {
                const response = await fetch(`${baseUrl}/info/updatePerson`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': token
                    },
                    body: JSON.stringify({ nickname })
                });
                const data = await response.json();
                showResult('result5', data, data.code === 0);
            } catch (error) {
                showResult('result5', { error: error.message }, false);
            }
        }
    </script>
</body>
</html>
