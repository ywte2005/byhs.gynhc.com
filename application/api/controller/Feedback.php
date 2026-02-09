<?php
namespace app\api\controller;

use app\common\controller\Api;
use app\common\model\Feedback as FeedbackModel;

/**
 * 工单反馈接口
 */
class Feedback extends Api
{
    protected $noNeedLogin = [];
    protected $noNeedRight = ['*'];

    /**
     * 获取反馈列表
     */
    public function index()
    {
        $userId = $this->auth->id;
        $page = $this->request->get('page', 1);
        $pageSize = $this->request->get('page_size', 10);
        
        $list = FeedbackModel::where('user_id', $userId)
            ->order('id', 'desc')
            ->paginate($pageSize, false, ['page' => $page]);
        
        $data = [];
        foreach ($list as $item) {
            $data[] = [
                'id' => $item->id,
                'type' => $item->type,
                'type_text' => $item->type_text,
                'title' => $item->title,
                'content' => $item->content,
                'status' => $item->status,
                'status_text' => $item->status_text,
                'reply' => $item->reply ?? '',
                'createtime' => $item->createtime,
                'reply_time' => $item->reply_time ?? 0
            ];
        }
        
        $this->success('获取成功', [
            'list' => $data,
            'total' => $list->total(),
            'page' => $page,
            'page_size' => $pageSize
        ]);
    }

    /**
     * 获取反馈类型列表
     */
    public function types()
    {
        $types = [];
        foreach (FeedbackModel::$types as $key => $value) {
            $types[] = ['value' => $key, 'label' => $value];
        }
        $this->success('获取成功', ['list' => $types]);
    }

    /**
     * 提交反馈
     */
    public function submit()
    {
        $userId = $this->auth->id;
        $data = $this->request->post();
        
        $rule = [
            'type' => 'require',
            'content' => 'require|min:10|max:1000'
        ];
        
        $message = [
            'type.require' => '请选择反馈类型',
            'content.require' => '请输入反馈内容',
            'content.min' => '反馈内容至少10个字符',
            'content.max' => '反馈内容最多1000个字符'
        ];
        
        $validate = $this->validate($data, $rule, $message);
        if ($validate !== true) {
            $this->error($validate);
        }
        
        $feedback = FeedbackModel::submit($userId, $data);
        
        $this->success('提交成功', [
            'id' => $feedback->id
        ]);
    }

    /**
     * 获取反馈详情
     */
    public function detail()
    {
        $userId = $this->auth->id;
        $id = $this->request->get('id');
        
        if (!$id) {
            $this->error('参数错误');
        }
        
        $feedback = FeedbackModel::where('id', $id)->where('user_id', $userId)->find();
        
        if (!$feedback) {
            $this->error('反馈不存在');
        }
        
        $data = [
            'id' => $feedback->id,
            'type' => $feedback->type,
            'type_text' => $feedback->type_text,
            'title' => $feedback->title,
            'content' => $feedback->content,
            'images' => $feedback->images ? explode(',', $feedback->images) : [],
            'contact' => $feedback->contact,
            'status' => $feedback->status,
            'status_text' => $feedback->status_text,
            'reply' => $feedback->reply ?? '',
            'createtime' => $feedback->createtime,
            'reply_time' => $feedback->reply_time ?? 0
        ];
        
        $this->success('获取成功', $data);
    }
}
