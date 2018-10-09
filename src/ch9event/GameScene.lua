-- 事件相关

local kBoxA_Tag = 102
local kBoxB_Tag = 103
local kBoxC_Tag = 104
local kKey_Tag = 105

local size = cc.Director:getInstance():getWinSize()

local GameScene = class("GameScene", function()
    return cc.Scene:create()
end)

function GameScene.create( ... )
    local scene = GameScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function GameScene:actor()
end


local function touchBegin( touch, event )
    cclog("touch Begin")

    local node = event:getCurrentTarget()
    local locationInNode = node:convertToNodeSpace(touch:getLocation())
    local s = node:getContentSize()
    local rect = cc.rect(0,0,s.width,s.height)

    if cc.rectContainsPoint(rect, locationInNode) then
        cclog("sprite x = %d, y = %d", locationInNode.x, locationInNode.y)
        cclog("sprite tag = %d", node:getTag())
        node:runAction(cc.ScaleBy:create(0.06, 1.06))
        return true
    end

    return false
end

local function touchMove( touch, event )
    cclog("touch Move")

    local node = event:getCurrentTarget()
    local currentPosX, currentPosY = node:getPosition()
    local diff = touch:getDelta()
    node:setPosition(cc.p(currentPosX + diff.x, currentPosY + diff.y))
end

local function touchEnd( touch, event )
    cclog("touch End")

    local node = event:getCurrentTarget()
    local locationInNode = node:convertToNodeSpace(touch:getLocation())
    local s = node:getContentSize()
    local rect = cc.rect(0,0,s.width,s.height)

    if cc.rectContainsPoint(rect, locationInNode) then
        cclog("sprite x = %d, y = %d", locationInNode.x, locationInNode.y)
        cclog("sprite tag = %d", node:getTag())
        node:runAction(cc.ScaleBy:create(0.06, 1.00))
        return true
    end

    return false
end

local function onKeyPressed( keyCode, event )
    local buf = string.format( "key %d pressed.", keyCode)
    local label = event:getCurrentTarget()
    label:setString(buf)
end

local function onKeyReleased( keyCode, event )
    local buf = string.format( "key %d released.", keyCode)
    local label = event:getCurrentTarget()
    label:setString(buf)
end

function GameScene:createLayer()
    local layer = cc.Layer:create()

    local bg = cc.Sprite:create("ch9/BackgroundTile.png")
    bg:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
    bg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bg)

    local statusLabel = cc.Label:createWithSystemFont("not key event", "", 40)
    statusLabel:setAnchorPoint(cc.p(0.5,0.5))
    statusLabel:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(statusLabel, 50, kKey_Tag)

    local boxA = cc.Sprite:create("ch9/BoxA2.png")
    boxA:setPosition(cc.p(size.width/2 - 120,size.height/2 + 120))
    layer:addChild(boxA, 10, kBoxA_Tag)

    local boxB = cc.Sprite:create("ch9/BoxB2.png")
    boxB:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(boxB, 20, kBoxB_Tag)

    local boxC = cc.Sprite:create("ch9/BoxC2.png")
    boxC:setPosition(cc.p(size.width/2 + 120,size.height/2 + 160))
    layer:addChild(boxC, 30, kBoxC_Tag)

    -- 创建事件监听器(触碰)
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(touchBegin, cc.Handler.EVENT_TOUCH_BEGAN)
    listener1:registerScriptHandler(touchMove, cc.Handler.EVENT_TOUCH_MOVED)
    listener1:registerScriptHandler(touchEnd, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, boxA)
    local listener2 = listener1:clone()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener2, boxB)
    local listener3 = listener2:clone()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener3, boxC)

    -- 键盘事件
    local keyListener = cc.EventListenerKeyboard:create()
    keyListener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    keyListener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(keyListener, statusLabel)

    return layer
end

return GameScene