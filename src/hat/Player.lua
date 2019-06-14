local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
local DRAG_BODYS_TAG = 0x80

local Player = class("Player", function(layer)
    return cc.Sprite:create("grossini.png")
end)

function Player.create(layer)
    return Player.new(layer)
end

function Player:ctor(layer)
    self.layer = layer
    self:setScale(1.3)

    self.PhysicsBody = cc.PhysicsBody:createBox(self:getContentSize(), cc.PhysicsMaterial(0.1, 0.5, 0.0))
    self:setPhysicsBody(self.PhysicsBody)
    self:setPosition(cc.p(0, VisibleRect:center().y - 50))

    self.PhysicsBody:setVelocity(cc.p(0, 150))
    self.PhysicsBody:setTag(DRAG_BODYS_TAG)
    self.PhysicsBody:setMass(1.0)
    self.PhysicsBody:setContactTestBitmask(0xFFFFFFFF)

    self:initKeyBoard()
end

function Player:initKeyBoard()
    local function onKeyPressed(keyCode, event)
        self:onKeyPressed(keyCode, event)
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )

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

return Player