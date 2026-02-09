define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'user/certification/index',
                    detail_url: 'user/certification/detail',
                    approve_url: 'user/certification/approve',
                    reject_url: 'user/certification/reject',
                    table: 'certification',
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
                        {field: 'type', title: __('认证类型'), searchList: {"personal": __('个人认证'), "enterprise": __('企业认证')}, formatter: Table.api.formatter.normal},
                        {field: 'name', title: __('真实姓名')},
                        {field: 'id_card', title: __('身份证号')},
                        {field: 'contact_phone', title: __('联系电话')},
                        {field: 'status', title: __('状态'), searchList: {"pending": __('待审核'), "approved": __('已通过'), "rejected": __('已拒绝')}, formatter: Table.api.formatter.status},
                        {field: 'createtime', title: __('提交时间'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'audit_time', title: __('审核时间'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {
                            field: 'operate', 
                            title: __('Operate'), 
                            table: table, 
                            events: Table.api.events.operate, 
                            formatter: function(value, row, index) {
                                var that = $.extend({}, this);
                                var table = $(that.table).clone(true);
                                
                                // 只有待审核状态才显示审核按钮
                                if (row.status === 'pending') {
                                    $(table).data("operate-approve", true);
                                    $(table).data("operate-reject", true);
                                } else {
                                    $(table).data("operate-approve", false);
                                    $(table).data("operate-reject", false);
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
                                    url: 'user/certification/detail'
                                },
                                {
                                    name: 'approve',
                                    text: __('通过'),
                                    title: __('审核通过'),
                                    classname: 'btn btn-xs btn-success btn-ajax',
                                    icon: 'fa fa-check',
                                    url: 'user/certification/approve',
                                    confirm: '确定要审核通过吗？',
                                    success: function(data, ret) {
                                        table.bootstrapTable('refresh');
                                    },
                                    visible: function(row) {
                                        return row.status === 'pending';
                                    }
                                },
                                {
                                    name: 'reject',
                                    text: __('拒绝'),
                                    title: __('审核拒绝'),
                                    classname: 'btn btn-xs btn-danger btn-dialog',
                                    icon: 'fa fa-times',
                                    url: 'user/certification/reject',
                                    visible: function(row) {
                                        return row.status === 'pending';
                                    }
                                }
                            ]
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            // 批量审核通过
            $(document).on('click', '.btn-approve', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要审核的记录');
                    return;
                }
                Layer.confirm('确定要批量审核通过吗？', function() {
                    Fast.api.ajax({
                        url: 'user/certification/approve',
                        data: {ids: ids.join(',')}
                    }, function() {
                        table.bootstrapTable('refresh');
                        Layer.closeAll();
                    });
                });
            });

            // 批量审核拒绝
            $(document).on('click', '.btn-reject', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要审核的记录');
                    return;
                }
                Fast.api.open('user/certification/reject?ids=' + ids.join(','), '审核拒绝', {
                    callback: function() {
                        table.bootstrapTable('refresh');
                    }
                });
            });
        },
        detail: function () {
            Controller.api.bindevent();
        },
        reject: function () {
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
