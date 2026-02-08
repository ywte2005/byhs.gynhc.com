define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'message/index',
                    add_url: 'message/add',
                    del_url: 'message/del',
                    table: 'message',
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
                        {field: 'id', title: 'ID', sortable: true},
                        {field: 'user_id', title: '用户ID', visible: false},
                        {field: 'user.nickname', title: '用户', formatter: function(value, row) {
                            if (value) {
                                return '<a href="javascript:;" data-url="user/user/detail?ids='+row.user_id+'" class="btn-dialog">'+value+'</a>';
                            }
                            return 'ID: ' + row.user_id;
                        }},
                        {field: 'type', title: '消息类型', searchList: {"system":"系统消息","task":"任务消息","wallet":"钱包消息","promo":"推广消息"}, formatter: function(value) {
                            var cls = {'system':'type-system','task':'type-task','wallet':'type-wallet','promo':'type-promo'};
                            var txt = {'system':'系统消息','task':'任务消息','wallet':'钱包消息','promo':'推广消息'};
                            return '<span class="status-badge '+(cls[value]||'')+'">'+(txt[value]||value)+'</span>';
                        }},
                        {field: 'title', title: '标题', formatter: function(value, row) {
                            return '<a href="javascript:;" data-url="message/detail?ids='+row.id+'" class="btn-dialog text-primary">'+value+'</a>';
                        }},
                        {field: 'content', title: '内容', formatter: function(value) {
                            if (value && value.length > 50) {
                                return value.substring(0, 50) + '...';
                            }
                            return value;
                        }},
                        {field: 'is_read', title: '状态', searchList: {"0":"未读","1":"已读"}, formatter: function(value) {
                            if (value == 1) {
                                return '<span class="status-badge status-read">已读</span>';
                            }
                            return '<span class="status-badge status-unread">未读</span>';
                        }},
                        {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: '操作', table: table, 
                            buttons: [
                                {name: 'detail', text: '', title: '详情', icon: 'fa fa-eye', classname: 'btn btn-xs btn-info btn-dialog', url: 'message/detail'},
                                {name: 'del', text: '', title: '删除', icon: 'fa fa-trash', classname: 'btn btn-xs btn-danger btn-ajax', url: 'message/del', confirm: '确定删除此消息？'}
                            ],
                            formatter: Table.api.formatter.buttons
                        }
                    ]
                ]
            });
            
            Table.api.bindevent(table);

            // Tab切换
            $('.panel-heading .nav-tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                var value = $(this).data('value');
                var options = table.bootstrapTable('getOptions');
                options.pageNumber = 1;
                options.queryParams = function(params) {
                    if (value) params.filter = JSON.stringify({type: value});
                    return params;
                };
                table.bootstrapTable('refresh');
            });
            
            // 批量标记已读
            $(document).on('click', '.btn-multi-markread', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要标记的记录');
                    return;
                }
                $.post('message/markread', {ids: ids.join(',')}, function(ret) {
                    if (ret.code === 1) {
                        Toastr.success(ret.msg);
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(ret.msg);
                    }
                }, 'json');
            });
        },
        add: function () {
            Controller.api.bindevent();
            // 发送对象切换
            $('input[name="send_all"]').change(function(){
                if($(this).val() == '0'){
                    $('#user-select-group').show();
                } else {
                    $('#user-select-group').hide();
                }
            });
        },
        detail: function () {
            // 详情页无需特殊处理
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            }
        }
    };
    return Controller;
});
