define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'wallet/bankcard/index',
                    del_url: 'wallet/bankcard/del',
                    table: 'user_bankcard',
                }
            });
            var table = $("#table");
            
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                sortOrder: 'desc',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: 'ID', sortable: true},
                        {field: 'user_id', title: '用户ID', visible: false},
                        {field: 'user.nickname', title: '用户', formatter: function(value, row) {
                            if (value) {
                                return '<a href="javascript:;" data-url="user/user/detail?ids='+row.user_id+'" class="btn-dialog">'+value+'</a>';
                            }
                            return 'ID: ' + row.user_id;
                        }},
                        {field: 'bank_name', title: '银行名称'},
                        {field: 'card_no', title: '卡号', formatter: function(value) {
                            if (value && value.length > 8) {
                                return '<span class="card-no">' + value.substring(0, 4) + ' **** **** ' + value.substring(value.length - 4) + '</span>';
                            }
                            return '<span class="card-no">' + value + '</span>';
                        }},
                        {field: 'card_holder', title: '持卡人'},
                        {field: 'is_default', title: '默认卡', formatter: function(value) {
                            if (value == 1) {
                                return '<span class="label label-success">是</span>';
                            }
                            return '<span class="label label-default">否</span>';
                        }},
                        {field: 'status', title: '状态', searchList: {"normal":"正常","disabled":"已禁用"}, formatter: function(value) {
                            if (value === 'normal') {
                                return '<span class="status-badge status-normal">正常</span>';
                            }
                            return '<span class="status-badge status-disabled">已禁用</span>';
                        }},
                        {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: '操作', table: table, 
                            buttons: [
                                {name: 'detail', text: '', title: '详情', icon: 'fa fa-eye', classname: 'btn btn-xs btn-info btn-dialog', url: 'wallet/bankcard/detail'},
                                {name: 'enable', text: '启用', title: '启用', classname: 'btn btn-xs btn-success btn-enable', visible: function(row){return row.status=='disabled';}},
                                {name: 'disable', text: '禁用', title: '禁用', classname: 'btn btn-xs btn-warning btn-disable', visible: function(row){return row.status=='normal';}},
                                {name: 'del', text: '', title: '删除', icon: 'fa fa-trash', classname: 'btn btn-xs btn-danger btn-ajax', url: 'wallet/bankcard/del', confirm: '确定删除此银行卡？'}
                            ],
                            formatter: Table.api.formatter.buttons
                        }
                    ]
                ]
            });
            
            Table.api.bindevent(table);

            // Tab切换
            $('.panel-heading .nav-tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                var value = $(this).data('value');
                var options = table.bootstrapTable('getOptions');
                options.pageNumber = 1;
                options.queryParams = function(params) {
                    if (value) params.filter = JSON.stringify({status: value});
                    return params;
                };
                table.bootstrapTable('refresh');
            });
            
            // 单个启用
            $(document).on('click', '.btn-enable', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                $.post('wallet/bankcard/enable', {ids: row.id}, function(ret) {
                    if (ret.code === 1) {
                        Toastr.success(ret.msg);
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(ret.msg);
                    }
                }, 'json');
            });
            
            // 单个禁用
            $(document).on('click', '.btn-disable', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.confirm('确定禁用此银行卡？', function(index) {
                    $.post('wallet/bankcard/disable', {ids: row.id}, function(ret) {
                        Layer.close(index);
                        if (ret.code === 1) {
                            Toastr.success(ret.msg);
                            table.bootstrapTable('refresh');
                        } else {
                            Toastr.error(ret.msg);
                        }
                    }, 'json');
                });
            });
            
            // 批量启用
            $(document).on('click', '.btn-multi-enable', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要启用的记录');
                    return;
                }
                $.post('wallet/bankcard/enable', {ids: ids.join(',')}, function(ret) {
                    if (ret.code === 1) {
                        Toastr.success(ret.msg);
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(ret.msg);
                    }
                }, 'json');
            });
            
            // 批量禁用
            $(document).on('click', '.btn-multi-disable', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要禁用的记录');
                    return;
                }
                Layer.confirm('确定批量禁用选中的 '+ids.length+' 张银行卡？', function(index) {
                    $.post('wallet/bankcard/disable', {ids: ids.join(',')}, function(ret) {
                        Layer.close(index);
                        if (ret.code === 1) {
                            Toastr.success(ret.msg);
                            table.bootstrapTable('refresh');
                        } else {
                            Toastr.error(ret.msg);
                        }
                    }, 'json');
                });
            });
        },
        detail: function () {
            // 详情页无需特殊处理
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            }
        }
    };
    return Controller;
});
