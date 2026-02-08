<?php
namespace app\common\model;

use think\Model;

class MerchantCategory extends Model
{
    protected $name = 'merchant_category';
    protected $autoWriteTimestamp = true;
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';

    /**
     * 获取所有可用类目（树形结构）
     */
    public static function getCategoryTree()
    {
        $list = self::where('status', 'normal')
            ->order('sort', 'asc')
            ->order('id', 'asc')
            ->select();

        // 转换为数组
        $listArray = [];
        foreach ($list as $item) {
            $listArray[] = $item->toArray();
        }

        return self::buildTree($listArray, 0);
    }

    /**
     * 获取一级类目列表
     */
    public static function getTopCategories()
    {
        return self::where('status', 'normal')
            ->where('parent_id', 0)
            ->order('sort', 'asc')
            ->order('id', 'asc')
            ->select();
    }

    /**
     * 获取子类目列表
     */
    public static function getChildCategories($parentId)
    {
        return self::where('status', 'normal')
            ->where('parent_id', $parentId)
            ->order('sort', 'asc')
            ->order('id', 'asc')
            ->select();
    }

    /**
     * 构建树形结构
     */
    private static function buildTree($list, $parentId = 0)
    {
        $tree = [];
        foreach ($list as $item) {
            if ($item['parent_id'] == $parentId) {
                $children = self::buildTree($list, $item['id']);
                $node = [
                    'id' => $item['id'],
                    'name' => $item['name'],
                    'code' => $item['code'],
                    'level' => $item['level']
                ];
                if (!empty($children)) {
                    $node['children'] = $children;
                }
                $tree[] = $node;
            }
        }
        return $tree;
    }
}
