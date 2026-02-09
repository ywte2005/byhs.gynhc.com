define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'user/feedback/index',
                    detail_url: 'user/feedback/detail',
                    reply_url: 'user/feedback/reply',
                    close_url: 'user/feedback/close',
                    processing_url: 'user/feedback/processing',
                    table: 'feedback',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                sortOrder: 'desc',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
                        {field: 'user.nickname', title: __('用户昵称'), operate: false},
                        {field: 'type', title: __('反馈类型'), searchList: {"suggestion": __('功能建议'), "bug": __('系统故障'), "complaint": __('投诉举报'), "question": __('咨询问题'), "other": __('其他')}, formatter: Table.api.formatter.normal},
                        {field: 'title', title: __('标题'), operate: 'LIKE'},
                        {field: 'content', title: __('内容'), operate: 'LIKE', formatter: function(value) {
                            return value && value.length > 30 ? value.substring(0, 30) + '...' : value;
                        }},
                        {field: 'status', title: __('状态'), searchList: {"pending": __('待处理'), "processing": __('处理中'), "replied": __('已回复'), "closed": __('已关闭')}, formatter: Table.api.formatter.status},
                        {field: 'createtime', title: __('提交时间'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'reply_time', title: __('回复时间'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {
                            field: 'operate', 
                            title: __('Operate'), 
                            table: table, 
                            events: Table.api.events.operate, 
                            formatter: function(value, row, index) {
                                var that = $.extend({}, this);
                                var table = $(that.table).clone(true);
                                
                                // 根据状态显示不同按钮
                                if (row.status === 'pending' || row.status === 'processing') {
                                    $(table).data("operate-reply", true);
                                    $(table).data("operate-close", true);
                                } else {
                                    $(table).data("operate-reply", false);
                                    $(table).data("operate-close", false);
                                }
                                that.table = table;
                                return Table.api.formatter.operate.call(that, value, row, index);
                            },
                            buttons: [
                                {
                                    name: 'detail',
                                    text: __('详情'),
                                    title: __('详情'),
                                    classname: 'btn btn-xs btn-info btn-dialog',
                                    icon: 'fa fa-eye',
                                    url: 'user/feedback/detail'
                                },
                                {
                                    name: 'reply',
                                    text: __('回复'),
                                    title: __('回复反馈'),
                                    classname: 'btn btn-xs btn-success btn-dialog',
                                    icon: 'fa fa-reply',
                                    url: 'user/feedback/reply',
                                    visible: function(row) {
                                        return row.status === 'pending' || row.status === 'processing';
                                    }
                                },
                                {
                                    name: 'close',
                                    text: __('关闭'),
                                    title: __('关闭反馈'),
                                    classname: 'btn btn-xs btn-danger btn-ajax',
                                    icon: 'fa fa-times',
                                    url: 'user/feedback/close',
                                    confirm: '确定要关闭此反馈吗？',
                                    success: function(data, ret) {
                                        table.bootstrapTable('refresh');
                                    },
                                    visible: function(row) {
                                        return row.status !== 'closed';
                                    }
                                }
                            ]
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            // 批量设为处理中
            $(document).on('click', '.btn-processing', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要处理的记录');
                    return;
                }
                Layer.confirm('确定要将选中的反馈设为处理中吗？', function() {
                    Fast.api.ajax({
                        url: 'user/feedback/processing',
                        data: {ids: ids.join(',')}
                    }, function() {
                        table.bootstrapTable('refresh');
                        Layer.closeAll();
                    });
                });
            });

            // 批量关闭
            $(document).on('click', '.btn-close-feedback', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要关闭的记录');
                    return;
                }
                Layer.confirm('确定要批量关闭选中的反馈吗？', function() {
                    Fast.api.ajax({
                        url: 'user/feedback/close',
                        data: {ids: ids.join(',')}
                    }, function() {
                        table.bootstrapTable('refresh');
                        Layer.closeAll();
                    });
                });
            });
        },
        detail: function () {
            Controller.api.bindevent();
        },
        reply: function () {
            Controller.api.bindevent();
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            }
        }
    };
    return Controller;
});
