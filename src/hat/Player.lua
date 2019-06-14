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
    self.PhysicsBody:setContactTestBitmask(0xFFFFFFFF)

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
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
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
    end
end

function Player:initContact()
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(function(contact)
        return self:onContactBegin(contact)
    end, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local eventDispatcher = self.layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self.layer)
end

function Player:onContactBegin(contact)
    local a = contact:getShapeA():getBody()
    local b = contact:getShapeB():getBody()
    if (a:getTag() == 0x01 and b:getTag() == 0x02) or (b:getTag() == 0x01 and a:getTag() == 0x02) then
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
        if pos1.y < pos2.y then
            return false
        else
            return true
        end
    end
    print("touch")
    return true
end

return Player