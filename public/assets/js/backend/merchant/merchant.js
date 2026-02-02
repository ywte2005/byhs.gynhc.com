define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'merchant/merchant/index',
                    add_url: 'merchant/merchant/add',
                    edit_url: 'merchant/merchant/edit',
                    del_url: 'merchant/merchant/del',
                    table: 'merchant',
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
                        {field: 'merchant_no', title: '商户编号', formatter: function(value, row) {
                            return '<a href="merchant/merchant/detail/ids/'+row.id+'" class="addtabsit text-primary" title="商户详情">'+value+'</a>';
                        }},
                        {field: 'user.nickname', title: '用户'},
                        {field: 'name', title: '商户名称'},
                        {field: 'legal_name', title: '法人'},
                        {field: 'contact_phone', title: '联系电话'},
                        {field: 'entry_fee', title: '入驻费', operate: false, formatter: function(value) {
                            return '<span class="text-success">¥' + parseFloat(value).toFixed(2) + '</span>';
                        }},
                        {field: 'entry_fee_paid', title: '已支付', formatter: function(value) {
                            return value == 1 ? '<span class="label label-success">已支付</span>' : '<span class="label label-default">未支付</span>';
                        }},
                        {field: 'status', title: '状态', searchList: {"pending":"待审核","approved":"已通过","rejected":"已拒绝","disabled":"已禁用"}, formatter: function(value) {
                            var cls = {'pending':'status-pending','approved':'status-approved','rejected':'status-rejected','disabled':'status-disabled'};
                            var txt = {'pending':'待审核','approved':'已通过','rejected':'已拒绝','disabled':'已禁用'};
                            return '<span class="status-badge '+(cls[value]||'')+'">'+(txt[value]||value)+'</span>';
                        }},
                        {field: 'createtime', title: '申请时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: '操作', table: table, 
                            buttons: [
                                {name: 'detail', text: '', title: '查看详情', icon: 'fa fa-eye', classname: 'btn btn-xs btn-info addtabsit', url: 'merchant/merchant/detail'},
                                {name: 'approve', text: '', title: '通过', icon: 'fa fa-check', classname: 'btn btn-xs btn-success btn-approve', visible: function(row){return row.status=='pending';}},
                                {name: 'reject', text: '', title: '拒绝', icon: 'fa fa-times', classname: 'btn btn-xs btn-danger btn-reject', visible: function(row){return row.status=='pending';}}
                            ],
                            formatter: Table.api.formatter.buttons
                        }
                    ]
                ],
                onLoadSuccess: function(data) {
                    var pending = 0;
                    if (data.rows) {
                        data.rows.forEach(function(row) {
                            if (row.status === 'pending') pending++;
                        });
                    }
                    $('#pending-count').text(pending);
                }
            });
            
            Table.api.bindevent(table);
            
            // Tab切换筛选
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
            
            // 查看详情已由 addtabsit 处理，此处移除冗余的 btn-detail 点击事件
            
            // 单个审核通过
            $(document).on('click', '.btn-approve', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.confirm('确定审核通过商户【'+row.name+'】？', function(index) {
                    $.post('merchant/merchant/approve', {ids: row.id}, function(ret) {
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
            var rejectIds = null;
            $(document).on('click', '.btn-reject', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                rejectIds = row.id;
                $('#rejectReason').val('');
                $('#rejectModal').modal('show');
            });
            
            // 批量通过
            $(document).on('click', '.btn-multi-approve', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要审核的商户');
                    return;
                }
                Layer.confirm('确定批量通过选中的 '+ids.length+' 个商户？', function(index) {
                    $.post('merchant/merchant/approve', {ids: ids.join(',')}, function(ret) {
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
                    Toastr.error('请先选择要拒绝的商户');
                    return;
                }
                rejectIds = ids.join(',');
                $('#rejectReason').val('');
                $('#rejectModal').modal('show');
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
                $.post('merchant/merchant/reject', {ids: rejectIds, reason: reason}, function(ret) {
                    $('#rejectModal').modal('hide');
                    if (ret.code === 1) {
                        Toastr.success(ret.msg);
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(ret.msg);
                    }
                }, 'json');
            });
            
            // 显示商户详情
            function showMerchantDetail(id) {
                $.get('merchant/merchant/detail', {id: id}, function(ret) {
                    if (ret.code === 1) {
                        var row = ret.data.row;
                        var html = '<div class="row">';
                        html += '<div class="col-md-6">';
                        html += '<div class="info-row"><div class="info-label">商户编号</div><div class="info-value">'+row.merchant_no+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">商户名称</div><div class="info-value">'+row.name+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">法人姓名</div><div class="info-value">'+row.legal_name+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">身份证号</div><div class="info-value">'+(row.id_card||'-')+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">联系电话</div><div class="info-value">'+row.contact_phone+'</div></div>';
                        html += '</div>';
                        html += '<div class="col-md-6">';
                        html += '<div class="info-row"><div class="info-label">开户银行</div><div class="info-value">'+(row.bank_name||'-')+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">银行账号</div><div class="info-value">'+(row.bank_account||'-')+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">入驻费</div><div class="info-value text-success">¥'+parseFloat(row.entry_fee).toFixed(2)+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">申请时间</div><div class="info-value">'+new Date(row.createtime*1000).toLocaleString()+'</div></div>';
                        html += '<div class="info-row"><div class="info-label">状态</div><div class="info-value">';
                        var statusMap = {'pending':'<span class="label label-warning">待审核</span>','approved':'<span class="label label-success">已通过</span>','rejected':'<span class="label label-danger">已拒绝</span>'};
                        html += statusMap[row.status] || row.status;
                        html += '</div></div>';
                        html += '</div>';
                        html += '</div>';
                        
                        if (row.id_card_front || row.id_card_back) {
                            html += '<div class="info-row"><div class="info-label">证件照片</div></div>';
                            html += '<div class="id-card-images">';
                            if (row.id_card_front) html += '<img src="'+row.id_card_front+'" alt="身份证正面">';
                            if (row.id_card_back) html += '<img src="'+row.id_card_back+'" alt="身份证反面">';
                            html += '</div>';
                        }
                        
                        if (row.reject_reason) {
                            html += '<div class="alert alert-danger" style="margin-top:15px;"><strong>拒绝原因：</strong>'+row.reject_reason+'</div>';
                        }
                        
                        $('#merchantDetailContent').html(html);
                        
                        var footerHtml = '<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>';
                        if (row.status === 'pending') {
                            footerHtml += ' <button type="button" class="btn btn-success" onclick="quickApprove('+row.id+')"><i class="fa fa-check"></i> 审核通过</button>';
                            footerHtml += ' <button type="button" class="btn btn-danger" onclick="quickReject('+row.id+')"><i class="fa fa-times"></i> 拒绝</button>';
                        }
                        $('#merchantDetailFooter').html(footerHtml);
                        
                        $('#merchantDetailModal').modal('show');
                    }
                }, 'json');
            }
            
            window.quickApprove = function(id) {
                $.post('merchant/merchant/approve', {ids: id}, function(ret) {
                    $('#merchantDetailModal').modal('hide');
                    if (ret.code === 1) {
                        Toastr.success(ret.msg);
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(ret.msg);
                    }
                }, 'json');
            };
            
            window.quickReject = function(id) {
                $('#merchantDetailModal').modal('hide');
                rejectIds = id;
                $('#rejectReason').val('');
                $('#rejectModal').modal('show');
            };
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
