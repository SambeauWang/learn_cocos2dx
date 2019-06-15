local Player = class("Player", function(layer)
    return cc.Sprite:create("grossini.png")
end)

function Player.create(layer)
    return Player.new(layer)
end

function Player:ctor(layer)
    self.layer = layer
    self.isRunning = 0
    self.hats = {}

    -- 设置大小
    local Size = self:getContentSize()
    self:setContentSize(cc.size(40, 50))

    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), PLAYER_MATERIAL)
    self:setPhysicsBody(self.PhysicsBody)
    self.PhysicsBody.Object = self
    self:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y - 130))

    self.PhysicsBody:setVelocity(cc.p(0, 150))
    self.PhysicsBody:setTag(PLAYER_TAG)
    self.PhysicsBody:setMass(1.0)
    self.PhysicsBody:setRotationEnable(false)

    -- 碰撞相关
    -- self:setLocalZOrder(1)
    -- self.PhysicsBody:setGroup(-PLAYER_TAG)
    self.PhysicsBody:setCategoryBitmask(PLAYER_TAG)
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -1))
    self.PhysicsBody:setContactTestBitmask(bit.bor(FLOOR_TAG, HAT_TAG))
    self.PhysicsBody:setCollisionBitmask(bit.bor(GROUND_TAG, FLOOR_TAG))
    -- print(bit.band(GROUND_TAG, FLOOR_TAG))

    -- self:initKeyBoard()
    self:initContact()

    self:scheduleUpdateWithPriorityLua(function(dt)
        self:schedule(dt)
    end, 0)
end

function Player:schedule(dt)
    local curVelocity = self.PhysicsBody:getVelocity()
    local VelocityX = math.max(math.min(curVelocity.x + self.isRunning*AcceleratedSpeedX*dt, MaxSpeedX), -MaxSpeedX)
    self.PhysicsBody:setVelocity(cc.p(VelocityX, curVelocity.y))
end

function Player:Shot()
    -- add Hat
    local hat = require("Hat/Hat").create(self.layer)
    self.layer:addChild(hat)

    local x, y = self:getPosition()
    local Size = self:getContentSize()
    local curVelocity = self.PhysicsBody:getVelocity()
    if curVelocity.x > 0 then
        hat:setPosition(cc.p(x+Size.width+20, y+Size.height/2))
        local VelocityX = math.min(HatDefaultRightSpeed + curVelocity.x, HatMaxRightSpeed)
        hat.PhysicsBody:setVelocity(cc.p(VelocityX, HatUpSpeed))
    else
        hat:setPosition(cc.p(x-Size.width-20, y+Size.height/2))
        local VelocityX = math.max(-HatDefaultRightSpeed + curVelocity.x, -HatMaxRightSpeed)
        hat.PhysicsBody:setVelocity(cc.p(VelocityX, HatUpSpeed))
    end
end

function Player:Right(Stop)
    self.isRunning = Stop and 1.0 or 0.0
end

function Player:Left(Stop)
    self.isRunning = Stop and -1.0 or 0.0
end

function Player:Jump()
    local curVelocity = self.PhysicsBody:getVelocity()
    if curVelocity.y <= 1.0 then
        self.PhysicsBody:setVelocity(cc.p(curVelocity.x, InitSpeedY))
    end
end

function Player:initKeyBoard()
    local function onKeyPressed(keyCode, event)
        self:onKeyPressed(keyCode, event)
    end

    local onKeyReleased = function(keyCode, event)
        self:onKeyReleased(keyCode, event)
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self.layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.layer)
end

function Player:onKeyPressed(keyCode, event)
    local curVelocity = self.PhysicsBody:getVelocity()
    if keyCode == cc.KeyCode.KEY_W then
        if curVelocity.y <= 1.0 then
            self.PhysicsBody:setVelocity(cc.p(curVelocity.x, InitSpeedY))
        end
    elseif keyCode == cc.KeyCode.KEY_A then
        self.isRunning = -1.0
    elseif keyCode == cc.KeyCode.KEY_D then
        self.isRunning = 1.0
    elseif keyCode == cc.KeyCode.KEY_J then
        local hat = require("Hat/Hat").create(self.layer)
        self.layer:addChild(hat)

        local x, y = self:getPosition()
        local Size = self:getContentSize()
        if curVelocity.x > 0 then
            hat:setPosition(cc.p(x+Size.width+20, y+Size.height/2))
            local VelocityX = math.min(HatDefaultRightSpeed + curVelocity.x, HatMaxRightSpeed)
            hat.PhysicsBody:setVelocity(cc.p(VelocityX, HatUpSpeed))
        else
            hat:setPosition(cc.p(x-Size.width-20, y+Size.height/2))
            local VelocityX = math.max(-HatDefaultRightSpeed + curVelocity.x, -HatMaxRightSpeed)
            hat.PhysicsBody:setVelocity(cc.p(VelocityX, HatUpSpeed))
        end
    end
end

function Player:onKeyReleased(keyCode, event)
    if keyCode == cc.KeyCode.KEY_W then
        -- if curVelocity.y <= 1.0 then
        --     local Dir = cc.pAdd(curVelocity, cc.p(0, 150))
        --     self.PhysicsBody:setVelocity(Dir)
        -- end
    elseif keyCode == cc.KeyCode.KEY_A then
        self.isRunning = 0.0
    elseif keyCode == cc.KeyCode.KEY_D then
        self.isRunning = 0.0
    end
end

function Player:initContact()
    local contactListener = cc.EventListenerPhysicsContact:create()
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
    local a = contact:getShapeA():getBody()
    local b = contact:getShapeB():getBody()
    local aTag = a:getTag()
    local bTag = b:getTag()
    if not (aTag == PLAYER_TAG or bTag == PLAYER_TAG) then return end
    print("Player")

    if (aTag == FLOOR_TAG) or (bTag == FLOOR_TAG) then
        local player = aTag == PLAYER_TAG and a or b

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