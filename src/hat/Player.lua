local Player = class("Player", function(layer)
    return cc.Sprite:create("grossini.png")
end)

function Player.create(layer)
    return Player.new(layer)
end

function Player:ctor(layer)
    self.layer = layer
    self:setScale(1.3)
    self.hats = {}

    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), PLAYER_MATERIAL)
    self:setPhysicsBody(self.PhysicsBody)
    self.PhysicsBody.Object = self
    self:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y - 150))

    self.PhysicsBody:setVelocity(cc.p(0, 150))
    self.PhysicsBody:setTag(PLAYER_TAG)
    self.PhysicsBody:setMass(1.0)
    self.PhysicsBody:setRotationEnable(false)

    -- 碰撞相关
    -- self:setLocalZOrder(1)
    self.PhysicsBody:setGroup(-PLAYER_TAG)
    -- self.PhysicsBody:setCategoryBitmask(PLAYER_TAG)
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -1))
    self.PhysicsBody:setContactTestBitmask(0xFFFFFFFF)
    -- self.PhysicsBody:setCollisionBitmask(bit.bnot(FLOOR_TAG))

    self:initKeyBoard()
    self:initContact()
end

function Player:initKeyBoard()
    local function onKeyPressed(keyCode, event)
        self:onKeyPressed(keyCode, event)
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)

    local eventDispatcher = self.layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.layer)
end

function Player:onKeyPressed(keyCode, event)
    local curVelocity = self.PhysicsBody:getVelocity()
    if keyCode == cc.KeyCode.KEY_W then
        if curVelocity.y <= 1.0 then
            local Dir = cc.pAdd(curVelocity, cc.p(0, 150))
            self.PhysicsBody:setVelocity(Dir)
        end
    elseif keyCode == cc.KeyCode.KEY_A then
        local Dir = cc.pAdd(curVelocity, cc.p(-100, 0))
        self.PhysicsBody:setVelocity(Dir)
    elseif keyCode == cc.KeyCode.KEY_D then
        local Dir = cc.pAdd(curVelocity, cc.p(100, 0))
        self.PhysicsBody:setVelocity(Dir)
    elseif keyCode == cc.KeyCode.KEY_J then
        local hat = require("Hat/Hat").create(self.layer)
        local x, y = self:getPosition()
        hat:setPosition(cc.p(x-150, y))
        self.layer:addChild(hat)
        hat.PhysicsBody:setVelocity(cc.p(-150, 150))
    end
end

function Player:initContact()
    local contactListener = cc.EventListenerPhysicsContactWithGroup:create(-PLAYER_TAG)
    contactListener:registerScriptHandler(function(contact)
        return self:onContactBegin(contact)
    end, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local eventDispatcher = self.layer:getEventDispatcher()

    local node = cc.Node:create()
    node:setLocalZOrder(1)
    self.layer:addChild(node)
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, node)
end

function Player:onContactBegin(contact)
    print("Player")
    local a = contact:getShapeA():getBody()
    local b = contact:getShapeB():getBody()
    if (a:getTag() == PLAYER_TAG and b:getTag() == FLOOR_TAG) or (b:getTag() == PLAYER_TAG and a:getTag() == FLOOR_TAG) then
        local player, Floor
        if a:getTag() == 0x01 then
            player = a
            Floor = b
        else
            player = b
            Floor = a
        end

        local pos1 = player:getPosition()
        local pos2 = contact:getContactData().points[1]
        print("Jump")
        if pos1.y < pos2.y then
            return false
        else
            return true
        end
    end
    return false
end

return Player