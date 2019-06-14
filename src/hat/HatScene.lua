local size = cc.Director:getInstance():getWinSize()
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
local DRAG_BODYS_TAG = 0x80

local HatScene = class("HatScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)  -- DEBUGDRAW_ALL DEBUGDRAW_NONE
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
    material = material or MATERIAL_DEFAULT

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
    ground:setPhysicsBody(cc.PhysicsBody:createEdgeSegment(cc.p(VisibleRect:leftBottom().x,VisibleRect:leftBottom().y + 50),cc.p(VisibleRect:rightBottom().x,VisibleRect:rightBottom().y + 50)))
    layer:addChild(ground)

    self.Player = require("Hat/Player").create(layer)
    layer:addChild(self.Player)

    local platform = makeBox(VisibleRect:center(), cc.size(700, 20))
    local platformPhysicsBody = platform:getPhysicsBody()
    platformPhysicsBody:setDynamic(false)
    platformPhysicsBody:setContactTestBitmask(0xFFFFFFFF)
    platform:setRotation(-45)
    layer:addChild(platform)

    return layer
end

return HatScene
