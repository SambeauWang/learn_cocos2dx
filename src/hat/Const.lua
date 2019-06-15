
_G.PLAYER_TAG = 0x01
_G.FLOOR_TAG = 0x02
_G.HAT_TAG = 0x04
_G.GROUND_TAG = 0x08

-- 人物的物理属性(_, _, 摩檫力)
PLAYER_MATERIAL = cc.PhysicsMaterial(0.1, 0.5, 0.9)
-- 帽子的物理属性(_, _, 摩檫力)
HAT_MATERIAL = cc.PhysicsMaterial(0.1, 0.5, 1.0)
-- 底板的物理属性(_, _, 摩檫力)
FLOOR_MATERIAL = cc.PhysicsMaterial(0.1, 0.5, 1.0)


-- 人物行走的加速度
AcceleratedSpeedX = 320
-- 人物行走的最大速度
MaxSpeedX = 160
-- 人物的停止 ==> 依靠上面的摩檫力

-- 人的跳跃初始速度
InitSpeedY = 225

-- 重量加速度
Gravity = 250

-- 帽子的上升的加速度
HatUpSpeed = 20

-- 帽子横向的速度
HatDefaultRightSpeed = 180
HatMaxRightSpeed = 250
