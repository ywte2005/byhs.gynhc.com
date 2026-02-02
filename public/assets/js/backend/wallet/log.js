define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: { index_url: 'wallet/log/index', table: 'wallet_log' }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id', sortName: 'id', sortOrder: 'desc',
                columns: [[
                    {checkbox: true},
                    {field: 'id', title: __('Id')},
                    {field: 'user_id', title: '用户ID', visible: false},
                    {field: 'user.nickname', title: '用户'},
                    {field: 'wallet_type', title: '钱包类型', searchList: {"balance":"余额","deposit":"保证金","frozen":"冻结","mutual":"互助余额"}, formatter: Table.api.formatter.normal},
                    {field: 'change_type', title: '变动类型', searchList: {"income":"收入","expense":"支出","freeze":"冻结","unfreeze":"解冻"}, formatter: Table.api.formatter.normal},
                    {field: 'amount', title: '变动金额', operate: false},
                    {field: 'before_amount', title: '变动前', operate: false},
                    {field: 'after_amount', title: '变动后', operate: false},
                    {field: 'biz_type', title: '业务类型'},
                    {field: 'remark', title: '备注', operate: false},
                    {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime}
                ]]
            });
            Table.api.bindevent(table);
        }
    };
    return Controller;
});
