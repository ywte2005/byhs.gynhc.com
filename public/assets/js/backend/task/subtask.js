define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'task/subtask/index',
                    add_url: 'task/subtask/add',
                    edit_url: 'task/subtask/edit',
                    del_url: 'task/subtask/del',
                    table: 'sub_task',
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
                        {field: 'task_no', title: '子任务编号'},
                        {field: 'task_id', title: '主任务ID'},
                        {field: 'from_user_id', title: '发起方ID', visible: false},
                        {field: 'fromUser.nickname', title: '发起方'},
                        {field: 'to_user_id', title: '执行方ID', visible: false},
                        {field: 'toUser.nickname', title: '执行方'},
                        {field: 'amount', title: '刷单金额', operate: false},
                        {field: 'commission', title: '佣金', operate: false},
                        {field: 'status', title: '状态', searchList: {"pending":"待分配","assigned":"已分配","accepted":"已接单","paid":"已支付","verified":"已验证","completed":"已完成","failed":"失败","cancelled":"已取消"}, formatter: Table.api.formatter.status},
                        {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: __('Operate'), table: table, 
                            buttons: [
                                {name: 'complete', text: '完成', title: '确认完成', icon: 'fa fa-check', classname: 'btn btn-xs btn-success btn-magic btn-ajax', url: 'task/subtask/complete', confirm: '确定标记为已完成？', visible: function(row){return ['paid', 'verified'].indexOf(row.status) > -1;}},
                                {name: 'fail', text: '失败', title: '标记失败', icon: 'fa fa-times', classname: 'btn btn-xs btn-danger btn-fail', visible: function(row){return ['paid', 'verified', 'accepted'].indexOf(row.status) > -1;}}
                            ],
                            events: Table.api.events.operate, 
                            formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });
            Table.api.bindevent(table);

            // 标记失败
            $(document).on('click', '.btn-fail', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Fast.api.open('task/subtask/fail?ids=' + row.id, '标记失败', {
                    callback: function (data) {
                        table.bootstrapTable('refresh');
                    }
                });
            });
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
