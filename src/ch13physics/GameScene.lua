-- 物理相关

local size = cc.Director:getInstance():getWinSize()

local GameScene = class("GameScene", function()
    local scene = cc.Scene:createWithPhysics()
    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    return scene
end)

function GameScene.create( ... )
    local scene = GameScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function GameScene:actor()
end

function GameScene:addNewSpriteAtPosition(pos)
    local boxA = cc.Sprite:create("BoxA2.png")
    boxA:setPosition(pos)
    local boxABody = cc.PhysicsBody:createBox(boxA:getContentSize())
    boxA:setPhysicsBody( boxABody )
    self:addChild(boxA, 10, 100)

    local boxB = cc.Sprite:create("BoxB2.png")
    boxB:setPosition(pos.x + 100, pos.y - 120)
    local boxBBody = cc.PhysicsBody:createBox(boxB:getContentSize())
    boxB:setPhysicsBody(boxBBody)
    self:addChild(boxB, 20, 101)

    local world = cc.Director:getInstance():getRunningScene():getPhysicsWorld()
    local joint = cc.PhysicsJointDistance:construct(boxABody, boxBBody, cc.p(0,0), cc.p(0, boxB:getContentSize().width/2))
    world:addJoint(joint)
end

function GameScene:createLayer()
    local layer = cc.Layer:create()

    local body = cc.PhysicsBody:createEdgeBox(size, cc.PHYSICSBODY_MATERIAL_DEFAULT, 5.0)
    local edgeNode = cc.Node:create()
    edgeNode:setPosition(cc.p(size.width/2,size.height/2))
    edgeNode:setPhysicsBody(body)
    layer:addChild(edgeNode)

    local function onContactBegin(contact)
        local spriteA = contact:getShapeA():getBody():getNode()
        local spriteB = contact:getShapeB():getBody():getNode()

        if spriteA and spriteA:getTag() == 1 and spriteB and spriteB:getTag() == 1 then
            spriteA:setColor(cc.c3b(255,255,0))
            spriteB:setColor(cc.c3b(255,255,0))
        end

        cclog("onContactBegin")
        return true
    end

    local function onContactPreSolve( contact )
        cclog("onContactPreSolve")
        return true
    end

    local function onContactPostSolve(contact)
        cclog("onContactPostSolve")
    end

    local function onContactSeperate(contact)
        local spriteA = contact:getShapeA():getBody():getNode()
        local spriteB = contact:getShapeB():getBody():getNode()

        if spriteA and spriteA:getTag() == 1 and spriteB and spriteB:getTag() == 1 then
            spriteA:setColor(cc.c3b(255,255,255))
            spriteB:setColor(cc.c3b(255,255,255))
        end

        cclog("onContactSeperate")
    end

    local function touchBegin( touch, event )
        local location = touch:getLocation()
        self:addNewSpriteAtPosition(location)
        return false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(touchBegin, cc.Handler.EVENT_TOUCH_BEGAN)

    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    contactListener:registerScriptHandler(onContactPreSolve, cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
    contactListener:registerScriptHandler(onContactPostSolve, cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
    contactListener:registerScriptHandler(onContactSeperate,cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, layer)

    return layer
end

return GameScene