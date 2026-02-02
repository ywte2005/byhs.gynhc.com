define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'promo/performance/index',
                    table: 'promo_performance',
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
                        {field: 'id', title: __('Id'), sortable: true},
                        {field: 'user_id', title: __('User_id'), visible: false},
                        {field: 'user.nickname', title: __('User')},
                        {field: 'month', title: __('Month')},
                        {field: 'personal_amount', title: __('Personal_amount'), operate: false},
                        {field: 'team_amount', title: __('Team_amount'), operate: false},
                        {field: 'growth_amount', title: __('Growth_amount'), operate: false},
                        {field: 'direct_count', title: __('Direct_count')},
                        {field: 'updatetime', title: __('Updatetime'), operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime}
                    ]
                ]
            });
            Table.api.bindevent(table);
        }
    };
    return Controller;
});
