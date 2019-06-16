
_G.PLAYER_TAG = 0x01
_G.FLOOR_TAG = 0x02
_G.HAT_TAG = 0x04
_G.GROUND_TAG = 0x08

-- 人物的物理属性(_, 弹力, 摩檫力)
PLAYER_MATERIAL = cc.PhysicsMaterial(10000.0, 0.5, 0.9)
-- 帽子的物理属性(_, 弹力, 摩檫力)
HAT_MATERIAL = cc.PhysicsMaterial(0.1, 0.5, 1.0)
-- 底板的物理属性(_, 弹力, 摩檫力)
FLOOR_MATERIAL = cc.PhysicsMaterial(0.1, 0.5, 1.0)


-- 人物行走的加速度
AcceleratedSpeedX = 450
-- 人物行走的最大速度
MaxSpeedX = 160
-- 人物的停止 ==> 依靠上面的摩檫力

-- 人的跳跃初始速度
InitSpeedY = 250

-- 重量加速度
Gravity = 320

-- 帽子的上升的加速度
HatUpSpeed = 20

-- 帽子横向的速度
HatDefaultRightSpeed = 130
HatMaxRightSpeed = 180

-- 角色的大小
PlayerHeight = 50
PlayerWidth = 40

-- 角色1的大小
Player1Pos = cc.p(100, 120)
Player2Pos = cc.p(400, 120)

-- 小假期
ShortVacationLine = 120
-- 大假期
VacationLine = 240

-- dealine
DeadLineSpeed = 10


-- 每次刷出的个数
RespwanCnt = 4
RespwanInv = 5
RespwanTimes = 7

