define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'wallet/wallet/index',
                    add_url: 'wallet/wallet/add',
                    edit_url: 'wallet/wallet/edit',
                    del_url: 'wallet/wallet/del',
                    table: 'wallet'
                }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id', sortName: 'id',
                columns: [[
                    {checkbox: true},
                    {field: 'id', title: __('Id')},
                    {field: 'user_id', title: '用户ID', visible: false},
                    {field: 'user.nickname', title: '用户'},
                    {field: 'balance', title: '可用余额', operate: false},
                    {field: 'deposit', title: '保证金', operate: false},
                    {field: 'frozen', title: '冻结', operate: false},
                    {field: 'mutual_balance', title: '互助余额', operate: false},
                    {field: 'total_income', title: '累计收入', operate: false},
                    {field: 'total_withdraw', title: '累计提现', operate: false},
                    {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
                ]]
            });
            Table.api.bindevent(table);
        },
        add: function () {
            Controller.api.bindevent();
        },
        edit: function () {
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
