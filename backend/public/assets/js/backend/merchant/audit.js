define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'merchant/audit/index',
                    table: 'merchant_audit',
                }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: 'ID', sortable: true},
                        {field: 'merchant_id', title: '商户ID'},
                        {field: 'merchant.name', title: '商户名称'},
                        {field: 'admin_id', title: '管理员ID'},
                        {field: 'admin.nickname', title: '管理员'},
                        {field: 'action', title: '操作', searchList: {"approve":"通过","reject":"拒绝"}, formatter: Table.api.formatter.normal},
                        {field: 'remark', title: '备注'},
                        {field: 'createtime', title: '操作时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime}
                    ]
                ]
            });
            Table.api.bindevent(table);
        }
    };
    return Controller;
});
