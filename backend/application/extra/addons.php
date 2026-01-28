<?php

return [
    'autoload' => false,
    'hooks' => [
        'epay_config_init' => [
            'epay',
        ],
        'addon_action_begin' => [
            'epay',
        ],
        'action_begin' => [
            'epay',
        ],
        'view_filter' => [
            'sdtheme',
            'weixin',
        ],
        'config_init' => [
            'summernote',
        ],
        'upgrade' => [
            'weixin',
        ],
    ],
    'route' => [],
    'priority' => [],
    'domain' => '',
];
