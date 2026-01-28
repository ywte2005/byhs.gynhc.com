define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'promo/level/index',
                    add_url: 'promo/level/add',
                    edit_url: 'promo/level/edit',
                    del_url: 'promo/level/del',
                    table: 'promo_level',
                }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'sort',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
                        {field: 'name', title: '等级名称'},
                        {field: 'sort', title: '排序'},
                        {field: 'upgrade_type', title: '升级方式', searchList: {"purchase":"购买升级","performance":"业绩升级","both":"两者皆可"}, formatter: Table.api.formatter.normal},
                        {field: 'upgrade_price', title: '购买价格', operate: false},
                        {field: 'personal_performance_min', title: '个人业绩要求', operate: false},
                        {field: 'team_performance_min', title: '团队业绩要求', operate: false},
                        {field: 'direct_invite_min', title: '直推人数要求'},
                        {field: 'commission_rate', title: '佣金比例', operate: false},
                        {field: 'status', title: '状态', searchList: {"normal":"正常","hidden":"隐藏"}, formatter: Table.api.formatter.status},
                        {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
                    ]
                ]
            });
            Table.api.bindevent(table);
        },
        add: function () { Controller.api.bindevent(); },
        edit: function () { Controller.api.bindevent(); },
        api: { bindevent: function () { Form.api.bindevent($("form[role=form]")); } }
    };
    return Controller;
});
