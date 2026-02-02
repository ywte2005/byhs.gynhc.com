define(['jquery', 'bootstrap', 'frontend', 'template', 'form'], function ($, undefined, Frontend, Template, Form) {
    var Controller = {
        tm: null,
        ticket: '',
        expire_seconds: 0,
        scan: function () {
            Controller.api.getQrcode()
            return false;
        },
        api: {
            getQrcode: function() {
                $.ajax({
                    url: "/weixin/login/getOaScanCode",
                    method: "get",
                    success: function(response) {
                        if (response.code == 1) {
                            Controller.expire_seconds = response.data.expire_seconds
                            Controller.ticket = response.data.ticket
                            $('.qrcode').attr('src', response.data.image)
                            $('.qrcode').show()
                            Controller.api.checkLogin();
                        } else {
                            $('.title').text(response.msg)
                        }
                    },
                    error: function(error) {
                        // 当请求失败时执行这里的代码，error 包含错误信息
                        $('.title').text('获取失败，请检查微信配置！')
                    }
                });
            },
            checkLogin: function () {
                this.tm = setInterval(function () {
                    if (Controller.expire_seconds <= 0) {
                        Controller.api.getQrcode()//重新获取
                    } else {
                        $('.title').text(Controller.expire_seconds + '秒后刷新')
                        Controller.expire_seconds--;

                        $.ajax({
                            url: "/index/weixin/weixin/oaScanLogin?ticket=" + Controller.ticket + '&r=' + Math.random(),
                            method: "get",
                            success: function(response) {
                                if (response.code == 1) {
                                    parent.location.href = "/index/user/index";
                                }
                            },
                            error: function(error) {
                                // 当请求失败时执行这里的代码，error 包含错误信息
                            }
                        });
                    }

                }, 1000);
            }
        }
    };
    return Controller;
});