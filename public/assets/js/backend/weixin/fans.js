define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var repeat_flag = false;//防重复标识
    var page_index = 0,
        page_count = 0,
        page_next_openid = null,
        speed_of_progress = '准备中...';
    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'weixin/fans/index' + location.search,
                    table: 'weixin_fans',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'fans_id',
                sortName: 'fans_id',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'fans_id', title: __('fans_id')},
                        {field: 'openid', title: __('Openid')},
                        {field: 'nickname', title: __('Nickname')},
                        {field: 'remark', title: __('Remark')},
                        {field: 'headimgurl', title: __('Headimgurl'), events: Table.api.events.image, formatter: Table.api.formatter.image, operate: false},
                        {field: 'sex', title: __('Sex'), searchList: {"0":__('Sex 0'),"1":__('Sex 1'),"2":__('Sex 2')}, formatter: Table.api.formatter.flag, custom: {'0': 'info', '1': 'warning', '2': 'danger'}},
                        {field: 'province', title: __('Province')},
                        {field: 'city', title: __('City')},
                        {field: 'is_subscribe', title: __('Is_subscribe'), searchList: {"0":__('Is_subscribe 0'),"1":__('Is_subscribe 1')}, formatter: Table.api.formatter.flag, custom: {'0': 'info', '1': 'warning'}},
                        {field: 'subscribe_time', title: __('Subscribe_time'), operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                    ]
                ]
            });

            $('#refresh').click(function(){
                Controller.api.refresh();
            });

            // 获取选中项
            $(document).on("click", ".btn-selected", function () {
                var ids = '';
                $.each(table.bootstrapTable('getSelections'), function (index, row) {
                    ids += row.fans_id + ',';
                });
                var that = this;
                var options = $.extend({}, $(that).data() || {});
                var url = Backend.api.replaceids(that, $(that).data("url") || $(that).attr('href'));
                var title = $(that).attr("title") || $(that).data("title") || $(that).data('original-title');
                var button = Backend.api.gettablecolumnbutton(options);
                if (button && typeof button.callback === 'function') {
                    options.callback = button.callback;
                }
                url += '/ids/' + ids;
                if (typeof options.confirm !== 'undefined') {
                    Layer.confirm(options.confirm, function (index) {
                        Backend.api.open(url, title, options);
                        Layer.close(index);
                    });
                } else {
                    window[$(that).data("window") || 'self'].Backend.api.open(url, title, options);
                }
                return false;
            });

            // 为表格绑定事件
            Table.api.bindevent(table);
        },
        sendmsg: function () {
            Form.api.bindevent($("form[role=form]"));
            $(document).ready(function () {
                $('.form-horizontal').removeClass('hide');
            });
        },
        api: {
            // 更新粉丝列表
            refresh: function () {
                if(repeat_flag) return;
                repeat_flag = true;
                $.ajax({
                    type : "post",
                    url : "syncWechatFans",
                    data : {
                        "page" : page_index,
                        "next_openid" : page_next_openid,
                    },
                    dataType : "JSON",
                    beforeSend : function() {
                        //开始同步--转圈
                        $('#refresh').text(speed_of_progress);
                    },
                    success : function(data) {
                        repeat_flag = false;
                        if (data.code == 1) {
                            if (data.data == null) {
                                speed_of_progress = '同步粉丝信息';
                            }
                            if (page_index == 0) {
                                page_count = data['data']["page_count"] ? data['data']["page_count"] : page_count;
                                page_next_openid = data['data']["next_openid"] ? data['data']["next_openid"] : null;
                            }
                            if (page_index <= page_count) {
                                speed_of_progress = '正在同步中(' + (page_index / page_count * 100).toFixed(2) + '%)';
                            }
                            if (page_index < page_count) {
                                page_index = parseInt(page_index) + 1;
                                Controller.api.refresh();
                            } else {
                                if (page_next_openid != null) {
                                    //下一个1万
                                    page_index = 0;
                                    Controller.api.refresh();
                                } else {
                                    $('#refresh').text('同步粉丝信息');
                                    layer.msg('更新完成');
                                    $("#table").bootstrapTable('refresh');
                                }
                            }
                        } else {
                            $('#refresh').text('同步粉丝信息');
                            layer.msg(data.msg);
                        }
                    }
                })
            }
        }
    };
    return Controller;
});