local Player = class("Player", function(layer)
    return cc.Sprite:create("grossini.png")
end)

function Player.create(layer)
    return Player.new(layer)
end

function Player:ctor(layer)
    self.layer = layer
    self.isRunning = 0
    self.JumpCnt = 0
    self.hats = {}
    self.Forward = 1

    self.CurHp = 50

    -- 设置大小
    local Size = self:getContentSize()
    self:setContentSize(cc.size(PlayerWidth, PlayerHeight))

    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), PLAYER_MATERIAL)
    self:setPhysicsBody(self.PhysicsBody)
    self.PhysicsBody.Object = self
    self:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y - 130))

    self.PhysicsBody:setVelocity(cc.p(0, 150))
    self.PhysicsBody:setTag(PLAYER_TAG)
    self.PhysicsBody:setMass(1.0)
    self.PhysicsBody:setRotationEnable(false)
    self.PhysicsBody.Object = self

    -- 碰撞相关
    -- self:setLocalZOrder(1)
    -- self.PhysicsBody:setGroup(-PLAYER_TAG)
    self.PhysicsBody:setCategoryBitmask(PLAYER_TAG)
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -1))
    self.PhysicsBody:setContactTestBitmask(bit.bor(FLOOR_TAG, HAT_TAG))
    self.PhysicsBody:setCollisionBitmask(bit.bor(GROUND_TAG, FLOOR_TAG))
    -- print(bit.band(GROUND_TAG, FLOOR_TAG))

    -- self:initKeyBoard()
    -- self:initContact()

    self:scheduleUpdateWithPriorityLua(function(dt)
        self:schedule(dt)
    end, 0)
end

function Player:schedule(dt)
    local curVelocity = self.PhysicsBody:getVelocity()
    local VelocityX = math.max(math.min(curVelocity.x + self.isRunning*AcceleratedSpeedX*dt, MaxSpeedX), -MaxSpeedX)
    self.PhysicsBody:setVelocity(cc.p(VelocityX, curVelocity.y))

    local _, y = self:getPosition()
    -- TODO 都加25的偏移
    if self.layer.uParent.DeadLine + self:getContentSize().height + 25 >= y then
        self.JumpCnt = 0
    end
end

function Player:Shot()
    local nHats = #self.hats
    if nHats <= 0 then
        return
    end
    local hat = self.hats[nHats]
    table.remove(self.hats, nHats)
    hat:retain()
    hat:removeFromParent(false)
    print(nHats, hat, self.layer)
    self.layer:addChild(hat)
    hat:getPhysicsBody():setEnabled(true)

    local x, y = self:getPosition()
    local Size = self:getContentSize()
    local curVelocity = self.PhysicsBody:getVelocity()

    hat:setPosition(cc.p(x+(Size.width+20)*self.Forward, y+Size.height/2))
    local VelocityX = math.max(HatDefaultRightSpeed*self.Forward + curVelocity.x, HatMaxRightSpeed*self.Forward)
    hat.PhysicsBody:setVelocity(cc.p(VelocityX, HatUpSpeed))
end

function Player:ClearStatus()
    self.JumpCnt = 0
end

function Player:Right(Stop)
    self.Forward = 1
    self.isRunning = Stop and 1.0 or 0.0
end

function Player:Left(Stop)
    self.Forward = -1
    self.isRunning = Stop and -1.0 or 0.0
end

function Player:Jump()
    local curVelocity = self.PhysicsBody:getVelocity()
    if self.JumpCnt < 2 then
        self.JumpCnt = self.JumpCnt + 1
        self.PhysicsBody:setVelocity(cc.p(curVelocity.x, InitSpeedY))
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
        self.JumpCnt = pos1.y < pos2.y and self.JumpCnt or 0
    end
    return false
end

return Player