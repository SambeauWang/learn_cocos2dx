local size = cc.Director:getInstance():getWinSize()
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
local DRAG_BODYS_TAG = 0x80

local HatScene = class("HatScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)  -- DEBUGDRAW_ALL DEBUGDRAW_NONE

    -- 重量加速度
    scene:getPhysicsWorld():setGravity(cc.p(0, -Gravity))
    return scene
end)

function HatScene.create()
    local scene = HatScene.new()
    scene.layer = scene:createLayer()
    scene:addChild(scene.layer)
    return scene
end

function HatScene:actor()
end

local function makeBox(point, size, color, material)
    material = FLOOR_MATERIAL

    local yellow = false
    if color == 0 then
        yellow = math.random() > 0.5
    else
        yellow = color == 1
    end

    local box = yellow and cc.Sprite:create("YellowSquare.png") or cc.Sprite:create("CyanSquare.png")

    box:setScaleX(size.width/100.0)
    box:setScaleY(size.height/100.0)

    local body = cc.PhysicsBody:createBox(box:getContentSize(), material)
    box:setPhysicsBody(body)
    box:setPosition(cc.p(point.x, point.y))

    return box
end

function HatScene:createLayer()
    local layer = cc.Layer:create()

    local ground = cc.Node:create()
    local groudPhysicsBody = cc.PhysicsBody:createEdgeSegment(
        cc.p(VisibleRect:leftBottom().x,VisibleRect:leftBottom().y + 50),
        cc.p(VisibleRect:rightBottom().x,VisibleRect:rightBottom().y + 50)
    )
    ground:setPhysicsBody(groudPhysicsBody)
    groudPhysicsBody:setCategoryBitmask(GROUND_TAG)
    groudPhysicsBody:setContactTestBitmask(0xFFFFFFFF)
    groudPhysicsBody:setCollisionBitmask(bit.bor(PLAYER_TAG, HAT_TAG))
    layer:addChild(ground)

    -- 创建角色
    self.Player1 = require("Hat/Player").create(layer)
    layer:addChild(self.Player1)
    self.Player2 = require("Hat/Player").create(layer)
    layer:addChild(self.Player2)
    self.Player2:setPosition(cc.p(VisibleRect:center().x+100, VisibleRect:center().y - 130))

    self.PlayerController = require("Hat/PlayerController").create(self.Player1, self.Player2)
    layer:addChild(self.PlayerController)

    local hat = require("Hat/Hat").create(layer)
    layer:addChild(hat)

    local floor = require("Hat/Floor").create(layer, "YellowSquare.png")
    layer:addChild(floor)

    -- local p = VisibleRect:center()
    -- local platform = makeBox(cc.p(p.x, p.y-100), cc.size(700, 20))
    -- local platformPhysicsBody = platform:getPhysicsBody()
    -- platformPhysicsBody:setTag(FLOOR_TAG)
    -- platformPhysicsBody:setCategoryBitmask(FLOOR_TAG)
    -- platformPhysicsBody:setDynamic(false)
    -- platformPhysicsBody:setContactTestBitmask(PLAYER_TAG)
    -- -- platformPhysicsBody:setCategoryBitmask(FLOOR_TAG)
    -- -- platformPhysicsBody:setContactTestBitmask(bit.band(0xFFFFFFFF, -1))
    -- platformPhysicsBody:setCollisionBitmask(PLAYER_TAG)
    -- layer:addChild(platform)
    -- platform:setLocalZOrder(-1)

    -- print("player:", platformPhysicsBody)

    return layer
end

return HatScene
