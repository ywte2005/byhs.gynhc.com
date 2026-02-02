define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'promo/commission/index',
                    add_url: 'promo/commission/add',
                    edit_url: 'promo/commission/edit',
                    del_url: 'promo/commission/del',
                    table: 'promo_commission',
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
                        {field: 'user_id', title: '获得者ID'},
                        {field: 'user.nickname', title: '获得者'},
                        {field: 'source_user_id', title: '来源用户ID', visible: false},
                        {field: 'sourceUser.nickname', title: '来源用户'},
                        {field: 'scene', title: '场景', searchList: {"merchant_entry":"商户入驻","order_complete":"刷单完成","level_upgrade":"等级升级"}, formatter: Table.api.formatter.normal},
                        {field: 'reward_type', title: '奖励类型', searchList: {"direct":"直推奖","indirect":"间推奖","level_diff":"等级差分润","peer":"平级奖","team":"团队奖"}, formatter: Table.api.formatter.normal},
                        {field: 'base_amount', title: '基数', operate: false},
                        {field: 'amount', title: '佣金金额', operate: false},
                        {field: 'status', title: '状态', searchList: {"pending":"待结算","settled":"已结算","cancelled":"已取消"}, formatter: Table.api.formatter.status},
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
