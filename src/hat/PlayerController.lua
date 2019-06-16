local PlayerController = class("PlayerController", function(player1, player2)
    return cc.Node:create()
end)

function PlayerController.create(player1, player2)
    return PlayerController.new(player1, player2)
end

function PlayerController:ctor(player1, player2)
    self.player = player1
    self.other = player2
    self:initKeyBoard()
end

function PlayerController:initKeyBoard()
    local function onKeyPressed(keyCode, event)
        self:onKeyPressed(keyCode, event)
    end

    local onKeyReleased = function(keyCode, event)
        self:onKeyReleased(keyCode, event)
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self.player.layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.player.layer)
end

function PlayerController:onKeyPressed(keyCode, event)
    if keyCode == cc.KeyCode.KEY_W then
        self.player:Jump()
    elseif keyCode == cc.KeyCode.KEY_A then
        self.player:Left(true)
    elseif keyCode == cc.KeyCode.KEY_D then
        self.player:Right(true)
    elseif keyCode == cc.KeyCode.KEY_J then
        self.player:Shot()
    end

    -- other controller
    if keyCode == cc.KeyCode.KEY_UP_ARROW then
        self.other:Jump()
    elseif keyCode == cc.KeyCode.KEY_LEFT_ARROW then
        self.other:Left(true)
    elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
        self.other:Right(true)
    elseif keyCode == cc.KeyCode.KEY_1 then
        self.other:Shot()
    end
end

function PlayerController:onKeyReleased(keyCode, event)
    if keyCode == cc.KeyCode.KEY_A then
        self.player:Left(false)
    elseif keyCode == cc.KeyCode.KEY_D then
        self.player:Right(false)
    end

    if keyCode == cc.KeyCode.KEY_LEFT_ARROW then
        self.other:Left(false)
    elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
        self.other:Right(false)
    end
end

return PlayerController
