
if (Config.modulename == 'index') {
    $('.weixin-scanlogin').click(function () {
        parent.Fast.api.open('/index/weixin/scan', '请使用微信扫码登录', {
            area: ["400px", "400px"],
            maxmin: false
        });
    });
}