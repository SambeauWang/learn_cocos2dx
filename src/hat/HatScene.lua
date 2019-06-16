local size = cc.Director:getInstance():getWinSize()
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
local DRAG_BODYS_TAG = 0x80

local HatScene = class("HatScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_NONE)  -- DEBUGDRAW_ALL DEBUGDRAW_NONE

    -- 重量加速度
    scene:getPhysicsWorld():setGravity(cc.p(0, -Gravity))
    return scene
end)

function HatScene.create()
    local scene = HatScene.new()
    scene.layer = scene:createLayer()
    scene.layer.uParent = scene
    scene:addChild(scene.layer)
    return scene
end

function HatScene:ctor()
    -- self.players = {}
end

function HatScene:schedule(dt)
    if self.GameOver then return end
    self.PastTime = self.PastTime + dt

    for i, v in ipairs(self.players) do
        local _, y = v:getPosition()
        if y + v:getContentSize().height/2 + (#v.hats)* 20 >= 980 then
            self.GameOver = true
            self.WinLabel:setString(string.format("%s Win!", i==1 and "Player2" or "Player1"))
            return
        end
    end

    if self.PastTime > 10 then
        -- self.DeadLineEx = self.DeadLineSpeed * dt + self.DeadLineEx
        self.DeadLine = VisibleRect:leftBottom().y + 50 + DeadLineSpeed*(self.PastTime - 10) + self.DeadLineEx
        self.ground:setPositionY(self.DeadLine)
    end

    -- if self.CurTimes > 12 then
    --     self.GameOver = true
    -- elseif self.PastTime > self.CurTimes * 5 then
    --     self.CurTimes = self.CurTimes + 1
    --     local hat = require("Hat/Hat").create(self.layer)
    --     hat:setPosition(cc.p(HatPositions[self.CurTimes].x, HatPositions[self.CurTimes].y))
    --     self.layer:addChild(hat)
    -- end

    if self.CurTimes > 4 then
        self.GameOver = true
    elseif self.PastTime > self.RandomTime * 15 then
        self.RandomTime = self.RandomTime + 1
        self:randomEvent()
    end
end

function HatScene:createGround(leftBottom, RightTop)
    local ground = cc.Node:create()
    ground.groudPhysicsBody = cc.PhysicsBody:createEdgeSegment(leftBottom, RightTop)
    ground:setPhysicsBody(ground.groudPhysicsBody)
    ground.groudPhysicsBody:setCategoryBitmask(GROUND_TAG)
    ground.groudPhysicsBody:setContactTestBitmask(0xFFFFFFFF)
    ground.groudPhysicsBody:setCollisionBitmask(bit.bor(PLAYER_TAG, HAT_TAG))
    return ground
end

function HatScene:initTextList(layer)
    layer.TextLabel = {}
    for i=1, 11 do
        local Label = cc.Sprite:create(string.format("hat/text/test%d.png", i))
        Label:setPosition(cc.p(0, -30))
        layer:addChild(Label)

        table.insert(layer.TextLabel, Label)
    end
end

function HatScene:randomEvent()
    local Type = math.random(0, 4)

    -- 小长假
    Type = 4
    if Type == 1 then
        for _, v in ipairs(self.players) do
            local x, y = v:getPosition()
            if y-100-3 < VisibleRect:leftBottom().y + 50 + DeadLineSpeed*(self.PastTime - 10) then
                v:setPosition(cc.p(x, y+ShortVacationLine))
            end
        end
        self.DeadLineEx = self.DeadLineEx + ShortVacationLine

        self.HintLabel:setString("short vacation!!!")
    elseif Type == 2 then
        for _, v in ipairs(self.players) do
            local x, y = v:getPosition()
            if y-100-3 < VisibleRect:leftBottom().y + 50 + DeadLineSpeed*(self.PastTime - 10) then
                v:setPosition(cc.p(x, y+VacationLine))
            end
        end
        self.DeadLineEx = self.DeadLineEx + VacationLine

        self.HintLabel:setString("Long vacation!!!")
    elseif Type == 3 then
        self.Maskbg:runAction(cc.Sequence:create(
            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.Show:create(),
            cc.DelayTime:create(0.5),

            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.Show:create(),
            cc.DelayTime:create(0.5),

            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.Show:create(),
            cc.DelayTime:create(0.5),

            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.Show:create(),
            cc.DelayTime:create(0.5),

            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.Show:create(),
            cc.DelayTime:create(0.5),

            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.Show:create(),
            cc.DelayTime:create(0.5),
            cc.Hide:create()
        ))

        self.HintLabel:setString("停电了!!!")
    elseif Type == 4 then
        local removeHat = function(hats)
            local nHats = #hats
            if nHats <= 0 then return end
            local hat = hats[nHats]
            table.remove(hats, nHats)
            hat:DestroyHat()
        end

        performWithDelay(self.layer, function()
            print("remove Hat 2.0")
            for _, v in ipairs(self.players) do
                removeHat(v.hats)
                removeHat(v.hats)
            end
        end, 2.0)

        performWithDelay(self.layer, function()
            print("remove Hat 2.0")
            for _, v in ipairs(self.players) do
                removeHat(v.hats)
                removeHat(v.hats)
            end
        end, 4.0)

        self.HintLabel:setString("996!!!")
    end

    self.HintLabel:runAction(cc.Sequence:create(
        cc.DelayTime:create(5.0),
        cc.CallFunc:create(function()
            self.HintLabel:setString("")
        end)
    ))
end

function HatScene:createLayer()
    local layer = cc.Layer:create()

    local bg = cc.Sprite:create("hat/scene/bg.png")
    bg:setPosition(VisibleRect:center())
    bg:setLocalZOrder(-2)
    layer:addChild(bg)

    self.Maskbg = cc.Sprite:create("hat/scene/bg.png")
    self.Maskbg:setPosition(VisibleRect:center())
    self.Maskbg:setLocalZOrder(5)
    self.Maskbg:setVisible(false)
    layer:addChild(self.Maskbg)

    local Deadline1 = cc.Sprite:create("hat/scene/deadline.png")
    Deadline1:setRotation(180)
    Deadline1:setPosition(cc.p(VisibleRect:center().x, VisibleRect:top().y-50))
    layer:addChild(Deadline1)

    self.ground = self:createGround(
        cc.p(VisibleRect:leftBottom().x,VisibleRect:leftBottom().y + 50),
        cc.p(VisibleRect:rightBottom().x,VisibleRect:rightBottom().y + 50)
    )
    local Deadline2 = cc.Sprite:create("hat/scene/deadline.png")
    Deadline2:setPosition(cc.p(VisibleRect:center().x, 30))
    self.ground:addChild(Deadline2)
    layer:addChild(self.ground)

    local wall1 = self:createGround(
        cc.p(VisibleRect:leftBottom().x - 2, VisibleRect:leftBottom().y),
        cc.p(VisibleRect:leftBottom().x - 2, VisibleRect:leftTop().y)
    )
    layer:addChild(wall1)

    local wall2 = self:createGround(
        cc.p(VisibleRect:rightBottom().x + 2, VisibleRect:rightBottom().y),
        cc.p(VisibleRect:rightBottom().x + 2, VisibleRect:rightTop().y)
    )
    layer:addChild(wall2)

    -- 创建角色
    self.Player1 = require("Hat/Player").create(layer, "hat/player/1p.png")
    layer:addChild(self.Player1)
    self.Player1:setPosition(Player1Pos)
    self.Player2 = require("Hat/Player").create(layer, "hat/player/2p.png")
    layer:addChild(self.Player2)
    self.Player2:setPosition(Player2Pos)
    self.players = {self.Player1, self.Player2}

    self.PlayerController = require("Hat/PlayerController").create(self.Player1, self.Player2)
    layer:addChild(self.PlayerController)

    local hat = require("Hat/Hat").create(layer)
    layer:addChild(hat)

    -- local p = VisibleRect:center()
    -- local floor = require("Hat/Floor").create(layer, cc.p(p.x-100, p.y), cc.size(700, 20), "YellowSquare.png")
    -- layer:addChild(floor)

    for i=1, #TileMap do
        local floor = require("Hat/Floor").create(layer, cc.p(TileMap[i].x, TileMap[i].y), cc.size(TileMap[i].width, TileMap[i].height), "YellowSquare.png")
        layer:addChild(floor)
    end

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

    self.WinLabel = cc.Label:createWithTTF("", "fonts/arial.ttf", 32)
    layer:addChild(self.WinLabel, 1)
    self.WinLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.WinLabel:setPosition(cc.p(VisibleRect:center().x, VisibleRect:top().y-38))


    self.HintLabel = cc.Label:createWithTTF("", "fonts/STLITI.ttf", 32)
    layer:addChild(self.HintLabel, 1)
    self.HintLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.HintLabel:setPosition(cc.p(VisibleRect:center().x, VisibleRect:top().y-53))

    -- 初始化滚动的文本
    self:initTextList(layer)

    self.PastTime = 0
    self.GameOver = false
    self.DeadLine = VisibleRect:leftBottom().y + 50
    self.CurTimes = 1
    self.RandomTime = 1
    self.DeadLineSpeed = 0.0
    self.DeadLineEx = 0.0

    layer:scheduleUpdateWithPriorityLua(function(dt)
        self:schedule(dt)
    end, 0)

    return layer
end

return HatScene
