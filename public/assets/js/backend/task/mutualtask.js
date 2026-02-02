define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'task/mutualtask/index',
                    add_url: 'task/mutualtask/add',
                    edit_url: 'task/mutualtask/edit',
                    del_url: 'task/mutualtask/del',
                    table: 'mutual_task',
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
                        {field: 'task_no', title: '任务编号', formatter: function(value, row) {
                            return '<a href="task/mutualtask/detail/ids/'+row.id+'" class="addtabsit text-primary" title="任务详情">'+value+'</a>';
                        }},
                        {field: 'user_id', title: '用户ID', visible: false},
                        {field: 'user.nickname', title: '用户'},
                        {field: 'total_amount', title: '任务金额/完成', formatter: function(value, row) {
                            var percent = row.total_amount > 0 ? Math.round(row.completed_amount / row.total_amount * 100) : 0;
                            var html = '<div class="task-amount">';
                            html += '<span class="completed">¥' + parseFloat(row.completed_amount).toFixed(0) + '</span>';
                            html += ' / <span class="total">¥' + parseFloat(value).toFixed(0) + '</span>';
                            html += '</div>';
                            html += '<div class="progress progress-mini">';
                            html += '<div class="progress-bar progress-bar-success" style="width:'+percent+'%"></div>';
                            html += '</div>';
                            return html;
                        }},
                        {field: 'deposit_amount', title: '保证金', formatter: function(value, row) {
                            var frozen = parseFloat(row.frozen_amount) || 0;
                            var available = parseFloat(value) - frozen;
                            return '<div>总: ¥'+parseFloat(value).toFixed(0)+'</div><div class="text-muted" style="font-size:11px;">冻结: ¥'+frozen.toFixed(0)+' | 可用: ¥'+available.toFixed(0)+'</div>';
                        }},
                        {field: 'receipt_type', title: '收款类型', searchList: {"entry":"进件二维码","collection":"收款码"}, formatter: function(value, row) {
                            return row.receipt_type_text;
                        }},
                        {field: 'status', title: '状态', searchList: {"pending":"待审核","approved":"已审核","running":"进行中","paused":"已暂停","completed":"已完成","cancelled":"已取消","rejected":"已拒绝"}, formatter: function(value) {
                            var cls = {'pending':'status-pending','approved':'status-approved','running':'status-running','paused':'status-paused','completed':'status-completed','cancelled':'status-cancelled','rejected':'status-rejected'};
                            var txt = {'pending':'待审核','approved':'已审核','running':'进行中','paused':'已暂停','completed':'已完成','cancelled':'已取消','rejected':'已拒绝'};
                            return '<span class="status-badge '+(cls[value]||'')+'">'+(txt[value]||value)+'</span>';
                        }},
                        {field: 'createtime', title: '创建时间', operate:'RANGE', addclass:'datetimerange', formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: '操作', table: table, 
                            buttons: [
                                {name: 'detail', text: '', title: '详情', icon: 'fa fa-eye', classname: 'btn btn-xs btn-info addtabsit', url: 'task/mutualtask/detail'},
                                {name: 'approve', text: '', title: '审核通过', icon: 'fa fa-check', classname: 'btn btn-xs btn-success btn-approve', visible: function(row){return row.status=='pending';}},
                                {name: 'reject', text: '', title: '拒绝', icon: 'fa fa-times', classname: 'btn btn-xs btn-danger btn-reject', visible: function(row){return row.status=='pending';}},
                                {name: 'dispatch', text: '', title: '派发子任务', icon: 'fa fa-paper-plane', classname: 'btn btn-xs btn-primary btn-dispatch', visible: function(row){return row.status=='running';}}
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
            
            // 查看详情已由 addtabsit 处理
            
            // 审核通过
            $(document).on('click', '.btn-approve', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.confirm('确定审核通过任务【'+row.task_no+'】？<br>通过后将自动拆分子任务并开始派发', function(index) {
                    $.post('task/mutualtask/approve', {ids: row.id}, function(ret) {
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
            
            // 拒绝
            $(document).on('click', '.btn-reject', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.prompt({title: '请输入拒绝原因', formType: 2}, function(reason, index) {
                    $.post('task/mutualtask/reject', {ids: row.id, reason: reason}, function(ret) {
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
            
            // 派发子任务
            $(document).on('click', '.btn-dispatch', function() {
                var row = table.bootstrapTable('getData')[$(this).closest('tr').data('index')];
                Layer.confirm('确定派发任务【'+row.task_no+'】的待分配子任务？', function(index) {
                    $.post('task/mutualtask/dispatch', {ids: row.id}, function(ret) {
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
            
            // 批量审核通过
            $(document).on('click', '.btn-multi-approve', function() {
                var ids = Table.api.selectedids(table);
                if (ids.length === 0) {
                    Toastr.error('请先选择要审核的任务');
                    return;
                }
                Layer.confirm('确定批量通过选中的 '+ids.length+' 个任务？', function(index) {
                    $.post('task/mutualtask/approve', {ids: ids.join(',')}, function(ret) {
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
            
            // 一键派发
            $(document).on('click', '.btn-dispatch-all', function() {
                Layer.confirm('确定对所有进行中的任务派发子任务？', function(index) {
                    $.post('task/mutualtask/dispatchAll', {}, function(ret) {
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
            
            function showTaskDetail(id) {
                $.get('task/mutualtask/detail', {id: id}, function(ret) {
                    if (ret.code === 1) {
                        var row = ret.data.task;
                        var subtasks = ret.data.subtasks || [];
                        var percent = row.total_amount > 0 ? Math.round(row.completed_amount / row.total_amount * 100) : 0;
                        
                        var html = '<div class="row">';
                        html += '<div class="col-md-6">';
                        html += '<p><strong>任务编号：</strong>'+row.task_no+'</p>';
                        html += '<p><strong>目标金额：</strong><span class="text-primary">¥'+parseFloat(row.total_amount).toFixed(2)+'</span></p>';
                        html += '<p><strong>已完成：</strong><span class="text-success">¥'+parseFloat(row.completed_amount).toFixed(2)+'</span> ('+percent+'%)</p>';
                        html += '<p><strong>保证金：</strong>¥'+parseFloat(row.deposit_amount).toFixed(2)+'</p>';
                        html += '</div>';
                        html += '<div class="col-md-6">';
                        html += '<p><strong>冻结金额：</strong><span class="text-warning">¥'+parseFloat(row.frozen_amount||0).toFixed(2)+'</span></p>';
                        html += '<p><strong>服务费率：</strong>'+(parseFloat(row.service_fee_rate)*100).toFixed(2)+'%</p>';
                        html += '<p><strong>子任务范围：</strong>¥'+row.sub_task_min+' - ¥'+row.sub_task_max+'</p>';
                        html += '<p><strong>收款类型：</strong>'+row.receipt_type_text+'</p>';
                        if (row.receipt_type == 'entry') {
                            html += '<p><strong>进件二维码：</strong><a href="'+row.entry_qrcode+'" target="_blank"><img src="'+row.entry_qrcode+'" style="max-width:60px;max-height:60px;border:1px solid #eee;"></a></p>';
                        } else {
                            html += '<p><strong>收款码：</strong><a href="'+row.collection_qrcode+'" target="_blank"><img src="'+row.collection_qrcode+'" style="max-width:60px;max-height:60px;border:1px solid #eee;"></a></p>';
                        }
                        html += '<p><strong>状态：</strong>'+row.status_text+'</p>';
                        html += '</div>';
                        html += '</div>';
                        
                        html += '<div class="progress" style="margin:15px 0;height:20px;">';
                        html += '<div class="progress-bar progress-bar-success" style="width:'+percent+'%;line-height:20px;">'+percent+'%</div>';
                        html += '</div>';

                        if (row.content) {
                            html += '<div class="well well-sm" style="background:#f9f9f9;margin-bottom:15px;">';
                            html += '<strong>任务说明：</strong><div style="margin-top:5px;max-height:150px;overflow-y:auto;">'+row.content+'</div>';
                            html += '</div>';
                        }
                        
                        if (subtasks.length > 0) {
                            html += '<h5 style="margin-top:20px;border-bottom:1px solid #eee;padding-bottom:10px;"><i class="fa fa-list"></i> 子任务列表 ('+subtasks.length+')</h5>';
                            html += '<div style="max-height:300px;overflow-y:auto;">';
                            html += '<table class="table table-condensed table-striped" style="font-size:12px;">';
                            html += '<thead><tr><th>编号</th><th>金额</th><th>佣金</th><th>执行方</th><th>状态</th></tr></thead><tbody>';
                            subtasks.forEach(function(st) {
                                html += '<tr>';
                                html += '<td>'+st.task_no+'</td>';
                                html += '<td>¥'+parseFloat(st.amount).toFixed(0)+'</td>';
                                html += '<td>¥'+parseFloat(st.commission).toFixed(2)+'</td>';
                                html += '<td>'+(st.to_user_id||'-')+'</td>';
                                html += '<td>'+st.status_text+'</td>';
                                html += '</tr>';
                            });
                            html += '</tbody></table></div>';
                        }
                        
                        $('#taskDetailContent').html(html);
                        $('#taskDetailModal').modal('show');
                    }
                }, 'json');
            }
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
