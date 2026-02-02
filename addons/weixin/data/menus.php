<?php


return [
    [
        'name'    => 'weixin',
        'title'   => '微信公众号管理',
        'icon'    => 'fa fa-weixin',
        'sublist' => [
            [
                'name'    => 'weixin/config',
                'title'   => '应用配置',
                'remark'  => '填写微信公众号开发配置，请前往微信公众平台申请服务号并完成认证，请使用已认证的公众号服务号，否则可能缺少接口权限。',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'sublist' => [
                    ['name' => 'weixin/config/index', 'title' => '查看'],
                    ['name' => 'weixin/config/edit',  'title' => '编辑']
                ]
            ],
            [
                'name'    => 'weixin/menus',
                'title'   => '菜单管理',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'sublist' => [
                    ['name' => 'weixin/menus/index', 'title' => '查看'],
                    ['name' => 'weixin/menus/save',  'title' => '保存'],
                    ['name' => 'weixin/menus/sync',  'title' => '保存与同步'],
                ]
            ],
            [
                'name'    => 'weixin/template',
                'title'   => '模板消息',
                'remark'  => '模板消息仅用于公众号向用户发送重要的服务通知，只能用于符合其要求的服务场景中，如信用卡刷卡通知，商品购买成功通知等。',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'sublist' => [
                    ['name' => 'weixin/template/index', 'title' => '查看'],
                    ['name' => 'weixin/template/add',   'title' => '添加'],
                    ['name' => 'weixin/template/edit',  'title' => '编辑'],
                    ['name' => 'weixin/template/multi', 'title' => '批量更新'],
                    ['name' => 'weixin/template/del',   'title' => '删除']
                ]
            ],
            [
                'name'    => 'weixin/reply',
                'title'   => '回复管理',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'sublist' => [
                    ['name' => 'weixin/reply/index', 'title' => '查看'],
                    ['name' => 'weixin/reply/add', 'title' => '新增'],
                    ['name' => 'weixin/reply/edit', 'title' => '编辑'],
                    ['name' => 'weixin/reply/del', 'title' => '删除'],
                    ['name' => 'weixin/reply/multi', 'title' => '批量更新']
                ]
            ],
            [
                'name'    => 'weixin/news',
                'title'   => '图文消息',
                'remark'  => '图文消息可以通过关键词或者主动推送等方式发送到用户端的公众号中显示。',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'sublist' => [
                    ['name' => 'weixin/news/index', 'title' => '查看'],
                    ['name' => 'weixin/news/add', 'title' => '新增'],
                    ['name' => 'weixin/news/edit', 'title' => '编辑'],
                    ['name' => 'weixin/news/del', 'title' => '删除'],
                    ['name' => 'weixin/news/multi', 'title' => '批量更新']
                ]
            ],
            [
                'name'    => 'weixin/user',
                'title'   => '微信用户',
                'remark'  => '该微信用户数据列表是用户在微信端通过登录接口主动授权登录后获得。',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'ismenu'  => 1,
                'sublist' => [
                    ['name' => 'weixin/user/index',           'title' => '查看'],
                    ['name' => 'weixin/user/sendmsg',         'title' => '推送消息'],
                    ['name' => 'weixin/user/edit_user_tag',   'title' => '修改用户标签'],
                    ['name' => 'weixin/user/edit_user_group', 'title' => '修改用户分组'],
                ]
            ],
            [
                'name'    => 'weixin/user/tag',
                'title'   => '用户标签',
                'remark'  => '维护和管理微信公众号用户标签，可以为公众号用户设置所属的标签组。',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'ismenu'  => 1,
                'sublist' => [
                    ['name' => 'weixin/user/tagadd',   'title' => '添加'],
                    ['name' => 'weixin/user/tagedit',  'title' => '编辑'],
                    ['name' => 'weixin/user/tagdel',   'title' => '删除'],
                ]
            ],
            [
                'name'    => 'weixin/fans/index',
                'title'   => '粉丝用户',
                'remark'  => '粉丝用户是指关注微信公众号的微信用户与授权无关，需要手动同步。因接口限制目前拉去粉丝用户将不再输出头像、昵称等信息。',
                'extend'  => 'padding-left: 15px;',
                'icon'    => 'fa fa-angle-double-right',
                'ismenu'  => 1,
                'sublist' => [
                    ['name' => 'weixin/fans/syncwechatfans',   'title' => '同步粉丝'],
                    ['name' => 'weixin/fans/sendmsg',          'title' => '推送消息'],
                ]
            ]
        ]
    ]
];