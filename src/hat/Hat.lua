local Hat = class("Hat", function(layer)
    return cc.Sprite:create("btn-play-selected.png")
end)

function Hat.create(layer)
    return Hat.new(layer)
end

function Hat:ctor(layer)
    self.layer = layer
    self:setContentSize(cc.size(50, 20))

    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), HAT_MATERIAL)
    self:setPhysicsBody(self.PhysicsBody)
    self.PhysicsBody.Object = self
    self:setPosition(cc.p(VisibleRect:center().x - 150, VisibleRect:center().y - 150))
    self.PhysicsBody:setTag(HAT_TAG)
    self.PhysicsBody:setMass(1.0)

    -- self.PhysicsBody:setGroup(-HAT_TAG)
    self.PhysicsBody:setCategoryBitmask(HAT_TAG)
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -1))
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -HAT_TAG))
    self.PhysicsBody:setContactTestBitmask(PLAYER_TAG)
    self.PhysicsBody:setCollisionBitmask(GROUND_TAG)

    -- 碰撞相关
    self:setLocalZOrder(0)
    self:initContact()
end

function Hat:initContact()
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(function(contact)
        return self:onContactBegin(contact)
    end, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local eventDispatcher = self.layer:getEventDispatcher()

    local node = cc.Node:create()
    node:setLocalZOrder(2)
    self.layer:addChild(node)
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, node)
end

function Hat:onContactBegin(contact)
    local a = contact:getShapeA():getBody()
    local b = contact:getShapeB():getBody()
    local aTag = a:getTag()
    local bTag = b:getTag()
    if not (aTag == HAT_TAG or bTag == HAT_TAG) then return end
    print("Hat")

    if (a:getTag() == PLAYER_TAG and b:getTag() == HAT_TAG) or (b:getTag() == PLAYER_TAG and a:getTag() == HAT_TAG) then
        local player = a:getTag() == PLAYER_TAG and a.Object or b.Object
        local hat = a:getTag() == PLAYER_TAG and b.Object or a.Object
        local hatBody = a:getTag() == PLAYER_TAG and b or a
        hat:runAction(
            cc.CallFunc:create(function()
                hat:getPhysicsBody():setEnabled(false)
                hat:retain()
                hat:removeFromParent(false)

                player:addChild(hat)
                local Size = player:getContentSize()
                hat:setPosition(cc.p(Size.width/2, Size.height + 10*(#player.hats + 1)))

                table.insert(player.hats, hat)
            end)
        )
        return false
    end

    return false

end

return Hat
