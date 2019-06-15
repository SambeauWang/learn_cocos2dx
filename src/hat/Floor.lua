local Floor = class("Floor", function(layer, res)
    return cc.Sprite:create(res)
end)

function Floor.create(layer, res)
    return Floor.new(layer, res)
end

function Floor:ctor(layer)
    self.layer = layer

    -- 初始化物理
    local p = VisibleRect:center()
    self:setScaleX(700/100.0)
    self:setScaleY(20/100.0)
    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), FLOOR_MATERIAL)
    self:setPhysicsBody(self.PhysicsBody)
    self:setPosition(cc.p(p.x, p.y-100))

    self.PhysicsBody:setTag(FLOOR_TAG)
    self.PhysicsBody:setCategoryBitmask(FLOOR_TAG)
    self.PhysicsBody:setDynamic(false)
    self.PhysicsBody:setContactTestBitmask(bit.bor(PLAYER_TAG, HAT_TAG))
    -- platformPhysicsBody:setCategoryBitmask(FLOOR_TAG)
    -- platformPhysicsBody:setContactTestBitmask(bit.band(0xFFFFFFFF, -1))
    self.PhysicsBody:setCollisionBitmask(bit.bor(PLAYER_TAG, HAT_TAG))
    self:setLocalZOrder(-1)

    self:initContact()
end

function Floor:initContact()
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

function Floor:onContactBegin(contact)
    local a = contact:getShapeA():getBody()
    local b = contact:getShapeB():getBody()
    local aTag = a:getTag()
    local bTag = b:getTag()
    if not (aTag == FLOOR_TAG or bTag == FLOOR_TAG) then return end
    print("Floor Contact")

    local player
    if aTag == PLAYER_TAG or aTag == HAT_TAG then player = a end
    if bTag == PLAYER_TAG or bTag == HAT_TAG then player = b end
    if player then
        local pos1 = player:getPosition()
        local pos2 = contact:getContactData().points[1]
        print("Touch Floor", pos1.y < pos2.y)
        if pos1.y < pos2.y then
            return false
        else
            return true
        end
    end
    return false
end

return Floor