local Hat = class("Hat", function(layer)
    return cc.Sprite:create("btn-play-selected.png")
end)

function Hat.create(layer)
    return Hat.new(layer)
end

function Hat:ctor(layer)
    self.layer = layer

    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), PLAYER_MATERIAL)
    self:setPhysicsBody(self.PhysicsBody)
    self.PhysicsBody.Object = self
    self:setPosition(cc.p(VisibleRect:center().x - 50, VisibleRect:center().y - 150))

    self.PhysicsBody:setTag(HAT_TAG)
    self.PhysicsBody:setMass(1.0)
    self.PhysicsBody:setContactTestBitmask(0xFFFFFFFF)
end

function Hat:initContact()
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
    if (a:getTag() == PLAYER_TAG and b:getTag() == HAT_TAG) or (b:getTag() == PLAYER_TAG and a:getTag() == HAT_TAG) then
        local player = a:getTag() == PLAYER_TAG and a.Object or b.Object
        local hat = a:getTag() == PLAYER_TAG and b.Object or a.Object
        hat:getPhysicsBody():setResting(true)
        hat:removeFromParent(true)

        player:addChild(hat)
        table.insert(self.hats, hat)
    end
    print("touch")
    return true
end

