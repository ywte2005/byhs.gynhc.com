define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: { index_url: 'config/profit/index', add_url: 'config/profit/add', edit_url: 'config/profit/edit', del_url: 'config/profit/del', table: 'profit_rule' }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id', sortName: 'level_diff',
                columns: [[
                    {checkbox: true},
                    {field: 'id', title: __('Id')},
                    {field: 'name', title: '规则名称'},
                    {field: 'level_diff', title: '等级差'},
                    {field: 'profit_rate', title: '分润比例', operate: false},
                    {field: 'growth_min', title: '增量门槛', operate: false},
                    {field: 'status', title: '状态', searchList: {"normal":"正常","hidden":"隐藏"}, formatter: Table.api.formatter.status},
                    {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
                ]]
            });
            Table.api.bindevent(table);
        },
        add: function () { Controller.api.bindevent(); },
        edit: function () { Controller.api.bindevent(); },
        api: { bindevent: function () { Form.api.bindevent($("form[role=form]")); } }
    };
    return Controller;
});
