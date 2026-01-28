define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'weixin/user/index' + location.search,
                    table: 'weixin_user',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'user_id', title: __('user_id')},
                        {field: 'user_type', title: __('User_type')},
                        {field: 'openid', title: __('Openid')},
                        {field: 'unionid', title: __('Unionid'), formatter: function(value){
                            return value ? value : '-'
                        }},
                        {field: 'fauser.nickname', title: __('Nickname')},
                        {field: 'fauser.avatar', title: __('Headimgurl'), events: Table.api.events.image, formatter: Table.api.formatter.image, operate: false},
                        {field: 'tagid_list_text', title: __('Tagid_list'), operate: false, formatter: Table.api.formatter.label},
                        {field: 'createtime', title: __('Createtime'), operate: 'RANGE', addclass: 'datetimerange', formatter: Table.api.formatter.datetime},
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            events: Table.api.events.operate,
                            formatter: Table.api.formatter.operate,
                            buttons: [
                                {
                                    name: 'detail',
                                    title: __('修改标签'),
                                    classname: 'btn btn-xs btn-success btn-dialog',
                                    icon: 'fa fa-tag',
                                    url: 'weixin/user/edit_user_tag'
                                }
                            ]
                        }
                    ]
                ]
            });

            // 获取选中项
            $(document).on("click", ".btn-selected", function () {
                var ids = '';
                $.each(table.bootstrapTable('getSelections'), function (index, row) {
                    ids += row.id + ',';
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
        edit: function () {
            Controller.api.bindevent();
        },
        edit_user_tag: function () {
            Controller.api.bindevent();
        },
        tag: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'weixin/user/tag' + location.search,
                    add_url: 'weixin/user/tagadd',
                    edit_url: 'weixin/user/tagedit',
                    del_url: 'weixin/user/tagdel',
                    table: 'weixin_user',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                search: false,
                commonSearch: false,
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('编号')},
                        {field: 'name', title: __('标签名')},
                        {field: 'count', title: __('人数')},
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            events: Table.api.events.operate,
                            formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);
        },
        tagadd: function () {
            Controller.api.bindevent();
        },
        tagedit: function () {
            Controller.api.bindevent();
        },
        sendmsg: function () {
            Controller.api.bindevent();
            $(document).ready(function () {
                $('.form-horizontal').removeClass('hide');
            });
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            }
        }
    };
    return Controller;
});