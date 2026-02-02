define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: { index_url: 'config/reward/index', add_url: 'config/reward/add', edit_url: 'config/reward/edit', del_url: 'config/reward/del', table: 'reward_rule' }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id', sortName: 'id',
                columns: [[
                    {checkbox: true},
                    {field: 'id', title: __('Id')},
                    {field: 'name', title: '规则名称'},
                    {field: 'scene', title: '触发场景', searchList: {"merchant_entry":"商户入驻","order_complete":"刷单完成","level_upgrade":"等级升级"}, formatter: Table.api.formatter.normal},
                    {field: 'reward_type', title: '奖励类型', searchList: {"direct":"直推奖","indirect":"间推奖","level_diff":"等级差分润","peer":"平级奖","team":"团队奖"}, formatter: Table.api.formatter.normal},
                    {field: 'target_depth', title: '目标层级'},
                    {field: 'amount_type', title: '金额类型', searchList: {"fixed":"固定金额","percent":"比例"}, formatter: Table.api.formatter.normal},
                    {field: 'amount_value', title: '金额值', operate: false},
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
