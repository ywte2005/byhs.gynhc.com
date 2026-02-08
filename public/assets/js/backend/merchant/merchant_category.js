define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'merchant/merchant_category/index',
                    add_url: 'merchant/merchant_category/add',
                    edit_url: 'merchant/merchant_category/edit',
                    del_url: 'merchant/merchant_category/del',
                    table: 'merchant_category'
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
                        {field: 'name', title: '类目名称', operate: 'LIKE'},
                        {field: 'code', title: '类目代码', operate: 'LIKE'},
                        {
                            field: 'parent_id',
                            title: '父级类目',
                            operate: false,
                            formatter: function (value, row, index) {
                                return value == 0 ? '<span class="label label-success">顶级类目</span>' : value;
                            }
                        },
                        {
                            field: 'level',
                            title: '层级',
                            searchList: {"1": "一级", "2": "二级"},
                            formatter: function (value, row, index) {
                                var colorArr = {1: 'primary', 2: 'success'};
                                var textArr = {1: '一级', 2: '二级'};
                                return '<span class="label label-' + colorArr[value] + '">' + textArr[value] + '</span>';
                            }
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
