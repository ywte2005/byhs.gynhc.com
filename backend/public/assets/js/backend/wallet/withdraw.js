define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'wallet/withdraw/index',
                    add_url: 'wallet/withdraw/add',
                    edit_url: 'wallet/withdraw/edit',
                    del_url: 'wallet/withdraw/del',
                    table: 'withdraw',
                }
            });
            var table = $("#table");
            var rejectIds = null;
            var paidIds = null;
            
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                sortOrder: 'desc',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: 'ID', sortable: true},
                        {field: 'withdraw_no', title: '提现单号', formatter: function(value, row) {
                            return '<a href="wallet/withdraw/detail/ids/'+row.id+'" class="addtabsit text-primary" title="提现详情">'+value+'</a>';
                        }},
                        {field: 'user_id', title: '用户ID', visible: false},
                        {field: 'user.nickname', title: '用户'},
                        {field: 'amount', title: '提现金额', formatter: function(value, row) {
                            var html = '<div class="amount-text">¥' + parseFloat(value).toFixed(2) + '</div>';
                            if (row.fee > 0) {
                                html += '<div class="text-muted" style="font-size:11px;">手续费: ¥'+parseFloat(row.fee).toFixed(2)+' | 实付: ¥'+parseFloat(row.actual_amount).toFixed(2)+'</div>';
                            }
                            return html;
                        }},
                        {field: 'account_name', title: '收款信息', formatter: function(value, row) {
                            return '<div><strong>'+value+'</strong></div><div class="bank-info">'+row.bank_name+' '+row.bank_account+'</div>';
                        }},
                        {field: 'status', title: '状态', searchList: {"pending":"待审核","approved":"待打款","paid":"已打款","rejected":"已拒绝","failed":"失败"}, formatter: function(value) {
                            var cls = {'pending':'status-pending','approved':'status-approved','paid':'status-paid','rejected':'status-rejected','failed':'status-failed'};
                            var txt = {'pending':'待审核','approved':'待打款','paid':'已打款','rejected':'已拒绝','failed':'失败'};
                            return '<span class="status-badge '+(cls[value]||'')+'">'+(txt[value]||value)+'</span>';
                        }},
                        {field: 'createtime', title: '申请时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: '操作', table: table, 
                            buttons: [
                                {name: 'detail', text: '', title: '详情', icon: 'fa fa-eye', classname: 'btn btn-xs btn-info addtabsit', url: 'wallet/withdraw/detail'},
                                {name: 'approve', text: '通过', title: '审核通过', classname: 'btn btn-xs btn-success btn-approve', visible: function(row){return row.status=='pending';}},
                                {name: 'reject', text: '拒绝', title: '拒绝', classname: 'btn btn-xs btn-danger btn-reject', visible: function(row){return row.status=='pending';}},
                                {name: 'paid', text: '打款', title: '确认打款', classname: 'btn btn-xs btn-info btn-paid', visible: function(row){return row.status=='approved';}}
                            ],
                            formatter: Table.api.formatter.buttons
                        }
                    ]
                ],
                onLoadSuccess: function(data) {
                    var pendingCount = 0, pendingAmount = 0;
                    var approvedCount = 0, approvedAmount = 0;
                    if (data.rows) {
                        data.rows.forEach(function(row) {
                            if (row.status === 'pending') {
                                pendingCount++;
                                pendingAmount += parseFloat(row.amount);
                            } else if (row.status === 'approved') {
                                approvedCount++;
                                approvedAmount += parseFloat(row.actual_amount);
                            }
                        });
                    }
                    $('#pending-count').text(pendingCount);
                    $('#sum-pending-count').text(pendingCount);
                    $('#sum-pending-amount').text('¥' + pendingAmount.toFixed(2));
                    $('#sum-approved-count').text(approvedCount);
                    $('#sum-approved-amount').text('¥' + approvedAmount.toFixed(2));
                }
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
            
            // 单个审核通过
            $(document).on('click', '.btn-approve', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.confirm('确定审核通过？<br>用户: '+row.user_id+'<br>金额: ¥'+parseFloat(row.amount).toFixed(2), function(index) {
                    $.post('wallet/withdraw/approve', {ids: row.id}, function(ret) {
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
            
            // 单个拒绝
            $(document).on('click', '.btn-reject', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                rejectIds = row.id;
                $('#rejectReason').val('');
                $('#rejectModal').modal('show');
            });
            
            // 单个打款
            $(document).on('click', '.btn-paid', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                paidIds = row.id;
                $('#paidInfo').html('收款人: '+row.account_name+'<br>银行: '+row.bank_name+'<br>账号: '+row.bank_account+'<br>金额: <strong class="text-danger">¥'+parseFloat(row.actual_amount).toFixed(2)+'</strong>');
                $('#paidRemark').val('');
                $('#paidModal').modal('show');
            });
            
            // 批量审核通过
            $(document).on('click', '.btn-multi-approve', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要审核的记录');
                    return;
                }
                Layer.confirm('确定批量通过选中的 '+ids.length+' 条提现申请？', function(index) {
                    $.post('wallet/withdraw/approve', {ids: ids.join(',')}, function(ret) {
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
            
            // 批量拒绝
            $(document).on('click', '.btn-multi-reject', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要拒绝的记录');
                    return;
                }
                rejectIds = ids.join(',');
                $('#rejectReason').val('');
                $('#rejectModal').modal('show');
            });
            
            // 批量打款
            $(document).on('click', '.btn-multi-paid', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要打款的记录');
                    return;
                }
                paidIds = ids.join(',');
                $('#paidInfo').html('选中 <strong>'+ids.length+'</strong> 条记录');
                $('#paidRemark').val('');
                $('#paidModal').modal('show');
            });
            
            // 快捷原因
            $(document).on('click', '.quick-reason', function() {
                $('#rejectReason').val($(this).text());
            });
            
            // 确认拒绝
            $('#confirmReject').on('click', function() {
                var reason = $('#rejectReason').val().trim();
                if (!reason) {
                    Toastr.error('请输入拒绝原因');
                    return;
                }
                $.post('wallet/withdraw/reject', {ids: rejectIds, reason: reason}, function(ret) {
                    $('#rejectModal').modal('hide');
                    if (ret.code === 1) {
                        Toastr.success(ret.msg);
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(ret.msg);
                    }
                }, 'json');
            });
            
            // 确认打款
            $('#confirmPaid').on('click', function() {
                var remark = $('#paidRemark').val().trim();
                $.post('wallet/withdraw/paid', {ids: paidIds, remark: remark}, function(ret) {
                    $('#paidModal').modal('hide');
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
