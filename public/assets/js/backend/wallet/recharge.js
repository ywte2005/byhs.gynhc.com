define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: { index_url: 'wallet/recharge/index', table: 'recharge' }
            });
            var table = $("#table");
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id', sortName: 'id', sortOrder: 'desc',
                columns: [[
                    {checkbox: true},
                    {field: 'id', title: 'ID', sortable: true},
                    {field: 'order_no', title: '订单号', formatter: function(value, row) {
                        return '<a href="wallet/recharge/detail/ids/'+row.id+'" class="addtabsit text-primary" title="充值详情">'+value+'</a>';
                    }},
                    {field: 'user_id', title: '用户ID'},
                    {field: 'amount', title: '金额', formatter: function(value) {
                        return '<span class="text-success">¥' + parseFloat(value).toFixed(2) + '</span>';
                    }},
                    {field: 'target', title: '充值目标', searchList: {"balance":"余额","deposit":"保证金"}, formatter: Table.api.formatter.normal},
                    {field: 'status', title: '状态', searchList: {"pending":"待支付","paid":"已支付","failed":"失败","cancelled":"已取消"}, formatter: function(value) {
                        var cls = {'pending':'status-pending','paid':'status-paid','failed':'status-failed','cancelled':'status-cancelled'};
                        var txt = {'pending':'待支付','paid':'已支付','failed':'失败','cancelled':'已取消'};
                        return '<span class="status-badge '+(cls[value]||'')+'">'+(txt[value]||value)+'</span>';
                    }},
                    {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                    {field: 'operate', title: __('Operate'), table: table, 
                        buttons: [
                            {name: 'detail', text: '', title: __('Detail'), icon: 'fa fa-eye', classname: 'btn btn-xs btn-info addtabsit', url: 'wallet/recharge/detail'},
                            {name: 'confirm', text: '补单', title: '确认到账', classname: 'btn btn-xs btn-success btn-confirm', visible: function(row){return row.status=='pending';}}
                        ],
                        formatter: Table.api.formatter.buttons
                    }
                ]]
            });
            Table.api.bindevent(table);

            // 查看详情已由 addtabsit 处理
            
            // Tab切换
            $('.panel-heading .nav-tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                var value = $(this).data('value');
                var options = table.bootstrapTable('getOptions');
                options.pageNumber = 1;
                options.queryParams = function(params) {
                    if (value) params.filter = JSON.stringify({status: value});
                    return params;
                };
                table.bootstrapTable('refresh');
            });
            
            // 补单确认
            $(document).on('click', '.btn-confirm', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.confirm('确定手动确认订单【'+row.order_no+'】到账？<br>金额: ¥'+parseFloat(row.amount).toFixed(2), function(index) {
                    $.post('wallet/recharge/confirm', {ids: row.id}, function(ret) {
                        Layer.close(index);
                        if (ret.code === 1) {
                            Toastr.success(ret.msg);
                            table.bootstrapTable('refresh');
                        } else {
                            Toastr.error(ret.msg);
                        }
                    }, 'json');
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
