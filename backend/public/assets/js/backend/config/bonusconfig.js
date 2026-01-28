define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: { index_url: 'config/bonusconfig/index', add_url: 'config/bonusconfig/add', edit_url: 'config/bonusconfig/edit', del_url: 'config/bonusconfig/del', table: 'promo_bonus_config' }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id', sortName: 'sort',
                columns: [[
                    {checkbox: true},
                    {field: 'id', title: __('Id')},
                    {field: 'name', title: '档位名称'},
                    {field: 'team_performance_min', title: '团队业绩门槛', operate: false},
                    {field: 'personal_performance_min', title: '个人业绩门槛', operate: false},
                    {field: 'qualified_count_min', title: '达标人数'},
                    {field: 'growth_min', title: '增量门槛', operate: false},
                    {field: 'pool_rate', title: '奖池比例', operate: false},
                    {field: 'sort', title: '排序'},
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
