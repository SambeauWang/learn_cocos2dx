-- 3D相关

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

function GameScene:createLayer()
    local layer = cc.Layer:create()

    local bg = cc.LayerColor:create()
    layer:addChild(bg)

    -- 创建3D精灵
    local sprite = cc.Sprite3D:create("ch15/3D/ship.c3b")
    sprite:setScale(10)
    sprite:setPosition(cc.p(size.width/2,size.height/2))
    sprite:setCameraMask(cc.CameraFlag.USER1)
    layer:addChild(sprite)

    local function update( delta )
        local rotation3D = sprite:getRotation3D()
        rotation3D.y = rotation3D.y + 3
        sprite:setRotation3D(rotation3D)
    end

    local function touchBegin( touch, event )
        cclog("touch Begin")
        layer:scheduleUpdateWithPriorityLua(update, 0)
        return true
    end

    local function touchEnded( touch, event )
        cclog("touch end")
        layer:unscheduleUpdate()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(touchBegin, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, layer)

    local camera = cc.Camera:createPerspective(60, size.width/size.height, 1, 1000)
    local spritePos = sprite:getPosition3D()
    spritePos.y = spritePos.y + 200
    spritePos.z = spritePos.z + 600
    camera:lookAt(spritePos)
    camera:setCameraFlag(cc.CameraFlag.USER1)
    layer:addChild(camera)

    local rootps = cc.PUParticleSystem3D:create("ch15/Particle3D/scripts/example_010.pu")
	rootps:setCameraMask(cc.CameraFlag.USER1)
	rootps:setScale(5)
	rootps:startParticleSystem()
    sprite:addChild(rootps)

    return layer
end

return GameScene