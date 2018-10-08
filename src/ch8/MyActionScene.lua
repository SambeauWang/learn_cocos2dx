-- 动作和特效的实现

local hiddenFlag = true
local sprite
local gridNodeTarget

local size = cc.Director:getInstance():getWinSize()

local MyActionScene = class("MyActionScene", function()
    return cc.Scene:create()
end)

function MyActionScene.create( ... )
    local scene = MyActionScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function MyActionScene:actor()
end

function MyActionScene:createLayer()
    cclog("MyActionScene actionFlag = %d", actionFLag)
    local layer = cc.Layer:create()

    gridNodeTarget = cc.NodeGrid:create()
    layer:addChild(gridNodeTarget)

    local bg = cc.Sprite:create("ch8/Background.png")
    bg:setPosition(cc.p(size.width/2,size.height/2))
    gridNodeTarget:addChild(bg)
    -- layer:addChild(bg)

    sprite = cc.Sprite:create("ch8/Plane.png")
    sprite:setPosition(cc.p(size.width/2, size.height/2))
    gridNodeTarget:addChild(sprite)
    -- layer:addChild(sprite)

    local backMenuItem = cc.MenuItemImage:create("ch8/Back-up.png", "ch8/Back-down.png")
    backMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(120,100)))

    local goMenuItem = cc.MenuItemImage:create("ch8/Go-up.png", "ch8/Go-down.png")
    goMenuItem:setPosition(size.width/2,100)

    local mn = cc.Menu:create(backMenuItem, goMenuItem)
    mn:setPosition(cc.p(0,0))
    layer:addChild(mn)

    local function backMenuCallback( pSender )
        cclog("MyActionScene backMenu")
        cc.Director:getInstance():popScene()
    end

    local function goMenu( pSender )
        cclog("MyActionScene goMenu")
        local p = cc.p(math.random()*size.width,math.random()*size.height)

        if actionFLag == PLAY_TAG then
            sprite:runAction(cc.Place:create(p))
        elseif actionFLag == FLIPX_TAG then
            -- sprite:runAction(cc.FlipX:create(true))
            gridNodeTarget:runAction(cc.FlipX3D:create(3.0))
        elseif actionFLag == FLIPY_TAG then
            sprite:runAction(cc.FlipY:create(true))
        elseif actionFLag == HIDE_SHOW_TAG then
            if hiddenFlag then
                sprite:runAction(cc.Hide:create())
                hiddenFlag = false
            else
                sprite:runAction(cc.Show:create())
                hiddenFlag = true
            end
        elseif actionFLag == kSequence then
            self.OnSequence(pSender)
        elseif actionFLag == CallBack_TAG then
            self:OnCallFuncND()
        else
            sprite:runAction(cc.ToggleVisibility:create())
        end
    end

    backMenuItem:registerScriptTapHandler(backMenuCallback)
    goMenuItem:registerScriptTapHandler(goMenu)

    return layer
end

local function callbackND( pSender, table )
    cclog("MyActionScene CallBack ND")
    local sp = pSender
    sp:runAction(cc.TintBy:create(table[1], table[2], table[3], table[4]))
end

function MyActionScene:OnCallFuncND()
    local ac1 = cc.MoveBy:create(2, cc.p(100,100))
    local ac2 = ac1:reverse()

    local acf = cc.CallFunc:create(callbackND, {1, 255, 0, 255})
    local seq = cc.Sequence:create(ac1, acf, ac3)
    sprite:runAction(cc.Sequence:create(seq))
end

function MyActionScene:OnSequence( pSender )
    cclog("MyActionScene OnSequence")

    local p = cc.p(size.width/2,200)
    
    local ac0 = sprite:runAction(cc.Place:create(p))
    local ac1 = sprite:runAction(cc.MoveTo:create(2, cc.p(size.width - 130,size.height - 200)))
    local ac2 = sprite:runAction(cc.JumpBy:create(2, cc.p(8,8),6,3))
    local ac3 = sprite:runAction(cc.Blink:create(2,3))
    local ac4 = sprite:runAction(cc.TintBy:create(0.5,0,255,255))

    sprite:runAction(cc.Sequence:create(ac0, ac1, ac2, ac3, ac4, ac0))
end

return MyActionScene