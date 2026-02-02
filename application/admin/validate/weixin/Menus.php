<?php

namespace app\admin\validate\weixin;
use think\Validate;

class Menus extends Validate
{
    /**
     * 验证规则
     */
    protected $rule = [
        'menus' => 'require|checkMenus'
    ];

    /**
     * 提示消息
     */
    protected $message = [

    ];

    /**
     * 验证场景
     */
    protected $scene = [

    ];

    public function checkMenus($menus, $rule, $data)
    {
        if (empty($menus) || !is_array($menus)) {
            return '请设置正确格式菜单';
        }

        if (count($menus) > 3) {
            return '一级菜单超出限制(最多3个)';
        }

        foreach ($menus as $item) {
            if (!is_array($item)) {
                return '一级菜单项须为数组格式';
            }

            if (empty($item['name'])) {
                return '请输入一级菜单名称';
            }

            if (strlen($item['name']) > 16) {
                return $item['name'] . '：菜单名称过长';
            }

            if (empty($item['sub_button'])) {
                if (empty($item['type'])) {
                    return '一级菜单未选择菜单类型';
                }
                if (!in_array($item['type'], ['click', 'view', 'miniprogram'])) {
                    return '一级菜单类型错误';
                }
                //验证类型
                $result = $this->checkType($item);
                if (true !== $result) {
                    return $result;
                }
            }

            if (!empty($item['sub_button'])) {
                $result = $this->checkSubButton($item['sub_button']);
                if (true !== $result) {
                    return $result;
                }
            }
        }
        return true;
    }


    /**
     * @notes 菜单类型校验
     * @param $item
     * @author Xing <464401240@qq.com>
     */
    public function checkType($item)
    {
        switch ($item['type']) {
            // 关键字
            case 'click':
                if (empty($item['key'])) {
                    return '请输入关键字';
                }
                break;
            // 跳转网页链接
            case 'view':
                if (empty($item['url'])) {
                    return '请输入网页链接';
                }
                if (!$this->checkRule($item['url'],'url')) {
                    return '跳转地址url格式不正确';
                }
                break;
            // 小程序
            case 'miniprogram':
                if (empty($item['appid'])) {
                    return '请输入appid';
                }
                if (empty($item['pagepath'])) {
                    return '请输入小程序路径';
                }
                if (empty($item['url'])) {
                    return '请输入备用网页链接';
                }
                if (!$this->checkRule($item['url'],'url')) {
                    return '备用网页链接格式错误';
                }
                break;
        }
        return true;
    }

    /**
     * @notes 二级菜单校验
     * @param $subButtion
     * @author Xing <464401240@qq.com>
     */
    public function checkSubButton($subButtion)
    {
        if (!is_array($subButtion)) {
            return '二级菜单须为数组格式';
        }

        if (count($subButtion) > 5) {
            return '二级菜单超出限制(最多5个)';
        }

        foreach ($subButtion as $subItem) {
            if (!is_array($subItem)) {
                return '二级菜单项须为数组';
            }

            if (empty($subItem['name'])) {
                return '请输入二级菜单名称';
            }

            if (strlen($subItem['name']) > 40) {
                return $subItem['name'] . '：菜单名称过长';
            }

            if (empty($subItem['type']) || !in_array($subItem['type'], ['click', 'view', 'miniprogram'])) {
                return '二级未选择菜单类型或菜单类型错误';
            }

            $result = $this->checkType($subItem);
            if (true !== $result) {
                return $result;
            }
        }
        return true;
    }

}
