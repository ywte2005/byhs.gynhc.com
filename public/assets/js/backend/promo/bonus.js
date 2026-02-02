define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'promo/bonus/index',
                    add_url: 'promo/bonus/add',
                    edit_url: 'promo/bonus/edit',
                    del_url: 'promo/bonus/del',
                    table: 'promo_bonus',
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
                        {field: 'id', title: __('Id')},
                        {field: 'user_id', title: '用户ID'},
                        {field: 'user.nickname', title: '用户'},
                        {field: 'month', title: '月份'},
                        {field: 'pool_amount', title: '奖池金额', operate: false},
                        {field: 'qualified_count', title: '达标人数'},
                        {field: 'amount', title: '分红金额', operate: false},
                        {field: 'status', title: '状态', searchList: {"pending":"待发放","settled":"已发放","cancelled":"已取消"}, formatter: Table.api.formatter.status},
                        {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
                    ]
                ]
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
