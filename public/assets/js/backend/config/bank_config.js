define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'config/bank_config/index',
                    add_url: 'config/bank_config/add',
                    edit_url: 'config/bank_config/edit',
                    del_url: 'config/bank_config/del',
                    table: 'bank_config'
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'sort',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id'), sortable: true},
                        {field: 'bank_name', title: '银行名称', operate: 'LIKE'},
                        {field: 'bank_code', title: '银行代码', operate: 'LIKE'},
                        {
                            field: 'bank_logo',
                            title: '银行Logo',
                            operate: false,
                            events: Table.api.events.image,
                            formatter: Table.api.formatter.image
                        },
                        {field: 'sort', title: '排序', sortable: true},
                        {
                            field: 'status',
                            title: '状态',
                            searchList: {"normal": "正常", "disabled": "禁用"},
                            formatter: Table.api.formatter.status
                        },
                        {
                            field: 'createtime',
                            title: '创建时间',
                            operate: 'RANGE',
                            addclass: 'datetimerange',
                            formatter: Table.api.formatter.datetime,
                            sortable: true
                        },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            events: Table.api.events.operate,
                            formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });

            // 为表格绑定事件
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
