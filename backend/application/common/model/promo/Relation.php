<?php
namespace app\common\model\promo;

use think\Model;

class Relation extends Model
{
    protected $name = 'promo_relation';
    protected $autoWriteTimestamp = true;

    protected static function init()
    {
        self::beforeInsert(function ($row) {
            if (empty($row['invite_code'])) {
                $row['invite_code'] = self::generateInviteCode();
            }
            if ($row['parent_id'] > 0) {
                $parent = self::where('user_id', $row['parent_id'])->find();
                if ($parent) {
                    $row['path'] = $parent['path'] ? $parent['path'] . ',' . $row['parent_id'] : (string)$row['parent_id'];
                    $row['depth'] = $parent['depth'] + 1;
                }
            } else {
                $row['path'] = '';
                $row['depth'] = 0;
            }
        });

        self::beforeUpdate(function ($row) {
            if (isset($row['parent_id']) && $row->isDirty('parent_id')) {
                if ($row['parent_id'] > 0) {
                    $parent = self::where('user_id', $row['parent_id'])->find();
                    if ($parent) {
                        $row['path'] = $parent['path'] ? $parent['path'] . ',' . $row['parent_id'] : (string)$row['parent_id'];
                        $row['depth'] = $parent['depth'] + 1;
                    }
                } else {
                    $row['path'] = '';
                    $row['depth'] = 0;
                }
            }
        });
    }

    public function user()
    {
        return $this->belongsTo('app\common\model\User', 'user_id', 'id');
    }

    public function level()
    {
        return $this->belongsTo('app\common\model\promo\Level', 'level_id', 'id');
    }

    public function parent()
    {
        return $this->belongsTo('app\common\model\promo\Relation', 'parent_id', 'user_id');
    }

    public static function getByUserId($userId)
    {
        return self::where('user_id', $userId)->find();
    }

    public static function getByInviteCode($code)
    {
        return self::where('invite_code', $code)->find();
    }

    public static function generateInviteCode()
    {
        do {
            $code = strtoupper(substr(md5(uniqid(mt_rand(), true)), 0, 8));
        } while (self::where('invite_code', $code)->find());
        return $code;
    }

    public static function createRelation($userId, $parentId = 0)
    {
        $data = [
            'user_id' => $userId,
            'level_id' => 0,
            'parent_id' => $parentId,
            'path' => '',
            'depth' => 0,
            'invite_code' => self::generateInviteCode()
        ];
        
        if ($parentId > 0) {
            $parent = self::getByUserId($parentId);
            if ($parent) {
                $data['path'] = $parent['path'] ? $parent['path'] . ',' . $parentId : (string)$parentId;
                $data['depth'] = $parent['depth'] + 1;
            }
        }
        
        return self::create($data);
    }

    public function getParentChain($depth = 0)
    {
        if (empty($this->path)) {
            return [];
        }
        $ids = array_reverse(explode(',', $this->path));
        if ($depth > 0) {
            $ids = array_slice($ids, 0, $depth);
        }
        return self::where('user_id', 'in', $ids)->order('depth', 'desc')->select();
    }

    public static function getDirectChildren($userId)
    {
        return self::where('parent_id', $userId)->select();
    }

    public static function getTeamCount($userId)
    {
        return self::where('path', 'like', '%' . $userId . '%')->count();
    }
}
