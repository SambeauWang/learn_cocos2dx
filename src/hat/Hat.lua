local Hat = class("Hat", function(layer)
    return cc.Sprite:create("hat/icon/pot.png")
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
    self.PhysicsBody:setRotationEnable(false)
    self.PhysicsBody:setMass(1.0)

    -- self.PhysicsBody:setGroup(-HAT_TAG)
    self.PhysicsBody:setCategoryBitmask(HAT_TAG)
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -1))
    -- self.PhysicsBody:setContactTestBitmask(bit.bor(0xFFFFFFFF, -HAT_TAG))
    self.PhysicsBody:setContactTestBitmask(bit.bor(FLOOR_TAG, PLAYER_TAG))
    self.PhysicsBody:setCollisionBitmask(bit.bor(GROUND_TAG, FLOOR_TAG))

    -- 碰撞相关
    self:setLocalZOrder(0)
    -- self:initContact()

    -- 每帧Loop
    self:scheduleUpdateWithPriorityLua(function(dt)
        self:schedule(dt)
    end, 0)
end

function Hat:ClearStatus()
    if self.Owner and self.isTestHatFlying then
        self.isTestHatFlying = false
        self:runAction(
            cc.CallFunc:create(function()
                self:getPhysicsBody():setEnabled(false)
                self:retain()
                self:removeFromParent(false)

                self.Owner:addChild(self)
                local nHats = #self.Owner.hats + 1
                self:setPosition(cc.p(PlayerWidth/2, PlayerHeight + 18*nHats))
                table.insert(self.Owner.hats, self)
                self.Owner.isShoting = false
            end)
        )
    end
end

function Hat:DestroyHat()
    self:getPhysicsBody():setEnabled(false)
    self:removeFromParent(false)
end

function Hat:SlowDown()
end

function Hat:initContact()
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(function(contact)
        return self:onContactBegin(contact)
    end, cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
    local eventDispatcher = self.layer:getEventDispatcher()

    local node = cc.Node:create()
    node:setLocalZOrder(2)
    self.layer:addChild(node)
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, node)
end

function Hat:schedule(dt)
    for _, v in ipairs(self.layer.uParent.players) do
        local vPosition = cc.p(v:getPosition())
        local hPosition = cc.p(self:getPosition())
        if cc.pGetDistance(vPosition, hPosition) < 45 then
            self:getPhysicsBody():setEnabled(false)
            self:retain()
            self:removeFromParent(false)
            self:hit()

            v:addChild(self)
            local nHats = #v.hats + 1
            self:setPosition(cc.p(PlayerWidth/2, PlayerHeight + 18*nHats))
            table.insert(v.hats, self)

            self.Owner = v
            break
        end
    end
end

function Hat:hit()
    local Cnt = 0
    local CurIndex = math.random(0, 10)
    while Cnt < 12 do
        local Label = self.layer.TextLabel[CurIndex+1]
        if not Label.isUsed then
            Label.isUsed = true
            local Size = Label:getContentSize()
            local left = VisibleRect:left()
            local right = VisibleRect:right()
            Label:setPosition(cc.p(right.x + Size.width/2, right.y))
            Label:runAction(cc.Sequence:create(
                cc.MoveTo:create(3.0, cc.p(cc.p(left.x - Size.width/2, left.y))),
                cc.CallFunc:create(function()
                    Label.isUsed = false
                end)
            ))
            return
        end
        Cnt = Cnt + 1
        CurIndex = CurIndex + 1
        CurIndex = CurIndex > 11 and CurIndex-12 or CurIndex
    end
end

function Hat:onContactBegin(contact)
    local a = contact:getShapeA():getBody()
    local b = contact:getShapeB():getBody()
    local aTag = a:getTag()
    local bTag = b:getTag()
    if not (aTag == HAT_TAG or bTag == HAT_TAG) then return end
    print("Hat")

    if a:getTag() == PLAYER_TAG or b:getTag() == PLAYER_TAG then
        local player = a:getTag() == PLAYER_TAG and a.Object or b.Object
        local hat = a:getTag() == PLAYER_TAG and b.Object or a.Object
        hat:runAction(
            cc.CallFunc:create(function()
                hat:getPhysicsBody():setEnabled(false)
                hat:retain()
                hat:removeFromParent(false)

                player:addChild(hat)
                local Size = player:getContentSize()
                local nHats = #player.hats + 1
                hat:setPosition(cc.p(PlayerWidth/2, PlayerHeight + 10*nHats))

                table.insert(player.hats, hat)
            end)
        )
        return false
    end

    return false

end

return Hat
