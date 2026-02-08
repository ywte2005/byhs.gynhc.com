define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {
    var Controller = {
        index: function () {
            Table.api.init({
                extend: {
                    index_url: 'merchant/application/index',
                    detail_url: 'merchant/application/detail',
                    table: 'merchant_application'
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
                        {field: 'id', title: __('Id'), sortable: true},
                        {field: 'application_no', title: '进件编号', operate: 'LIKE'},
                        {field: 'name', title: '主体名称', operate: 'LIKE'},
                        {field: 'type', title: '主体类型', searchList: {"personal": "个人", "individual": "个体", "enterprise": "企业"}, formatter: Table.api.formatter.normal},
                        {field: 'contact_name', title: '联系人'},
                        {field: 'contact_phone', title: '联系电话'},
                        {field: 'category', title: '经营类目'},
                        {field: 'status', title: '状态', searchList: {"pending": "待审核", "approved": "已通过", "rejected": "已驳回"}, formatter: Controller.api.formatter.status},
                        {field: 'createtime', title: '提交时间', operate: 'RANGE', addclass: 'datetimerange', autocomplete: false, formatter: Table.api.formatter.datetime},
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            events: Controller.api.events.operate,
                            formatter: Controller.api.formatter.operate
                        }
                    ]
                ]
            });

            Table.api.bindevent(table);

            // 快捷原因点击
            $(document).on('click', '.quick-reason', function(){
                var reason = $(this).text();
                $('#rejectReason').val(reason);
            });

            // 确认驳回
            var currentRejectId = null;
            $(document).on('click', '#confirmReject', function(){
                var reason = $('#rejectReason').val();
                if(!reason){
                    Toastr.error('请输入驳回原因');
                    return;
                }
                $.post('merchant/application/reject', {ids: currentRejectId, reason: reason}, function(res){
                    if(res.code === 1){
                        Toastr.success(res.msg);
                        $('#rejectModal').modal('hide');
                        table.bootstrapTable('refresh');
                    } else {
                        Toastr.error(res.msg);
                    }
                });
            });

            // 绑定驳回事件
            $(document).on('click', '.btn-reject-row', function(){
                currentRejectId = $(this).data('id');
                $('#rejectReason').val('');
                $('#rejectModal').modal('show');
            });
        },
        detail: function () {
            Form.api.bindevent($("form[role=form]"));
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            },
            formatter: {
                status: function (value, row, index) {
                    var statusMap = {
                        'pending': '<span class="status-badge status-pending">待审核</span>',
                        'approved': '<span class="status-badge status-approved">已通过</span>',
                        'rejected': '<span class="status-badge status-rejected">已驳回</span>'
                    };
                    return statusMap[value] || value;
                },
                operate: function (value, row, index) {
                    var table = this.table;
                    var html = [];
                    
                    html.push('<a href="javascript:;" class="btn btn-xs btn-info btn-detail" data-id="' + row.id + '" title="详情"><i class="fa fa-eye"></i></a>');
                    
                    if (row.status === 'pending') {
                        html.push('<a href="javascript:;" class="btn btn-xs btn-success btn-approve-row" data-id="' + row.id + '" title="通过"><i class="fa fa-check"></i></a>');
                        html.push('<a href="javascript:;" class="btn btn-xs btn-danger btn-reject-row" data-id="' + row.id + '" title="驳回"><i class="fa fa-times"></i></a>');
                    }
                    
                    return html.join(' ');
                }
            },
            events: {
                operate: {
                    'click .btn-detail': function (e, value, row, index) {
                        Fast.api.open('merchant/application/detail?ids=' + row.id, '进件详情', {area: ['800px', '600px']});
                    },
                    'click .btn-approve-row': function (e, value, row, index) {
                        Layer.confirm('确定要通过该进件申请吗？', function(idx){
                            $.post('merchant/application/approve', {ids: row.id}, function(res){
                                if(res.code === 1){
                                    Toastr.success(res.msg);
                                    Layer.close(idx);
                                    $("#table").bootstrapTable('refresh');
                                } else {
                                    Toastr.error(res.msg);
                                }
                            });
                        });
                    }
                }
            }
        }
    };
    return Controller;
});
