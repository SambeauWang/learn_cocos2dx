-- 动画的实例

local size = cc.Director:getInstance():getWinSize()
local isPlaying = false

local AnimateScene = class("AnimateScene", function()
    return cc.Scene:create()
end)

function AnimateScene.create()
    local scene = AnimateScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function AnimateScene:ctor()
end

-- create layer
function AnimateScene:createLayer()
    local layer = cc.Layer:create()

    local spriteFrame  = cc.SpriteFrameCache:getInstance()
    spriteFrame:addSpriteFrames("hat/action/jump/jump.plist")

    local bg = cc.Sprite:create("ch83/background.png")
    bg:setPosition(cc.p(size.width/2, size.height/2))
    layer:addChild(bg)

    local sprite = cc.Sprite:create("hat/action/jump/1.png")
    sprite:setPosition(cc.p(size.width/2, size.height/2))
    layer:addChild(sprite)

    --toggle菜单
    local goSprite = cc.Sprite:create("ch83/go.png")
    local stopSprite = cc.Sprite:create("ch83/stop.png")

    local goToggleMenuItem = cc.MenuItemSprite:create(goSprite, goSprite)
    local stopToggleMenuItem = cc.MenuItemSprite:create(stopSprite, stopSprite)
    local toggleMenuItem = cc.MenuItemToggle:create(goToggleMenuItem, stopToggleMenuItem)
    toggleMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(930, 540)))

    local mn = cc.Menu:create(toggleMenuItem)
    mn:setPosition(cc.p(0, 0))
    layer:addChild(mn)

    local function OnAction(menuItemSender)
        local scale = 0.5
        local sz = cc.Director:getInstance():getWinSize()
        local renderTexture = cc.RenderTexture:create(sz.width * scale, sz.height * scale)
        local scene = _G.gameScene
        local ancPos = scene:getAnchorPoint()

        -- copy screen
        -- renderTexture:begin()
        -- scene:setScale(scale)
        -- scene:setAnchorPoint(0, 0)
        -- scene:visit()
        -- renderTexture:endToLua()
        -- print("test2", renderTexture:saveToFile("D:\\test.png"))
        -- scene:setScale(1)
        -- scene:setAnchorPoint(ancPos)

        if not isPlaying then

            --///////////////动画开始//////////////////////
            local animation = cc.Animation:create()
            for i=1,4 do
                local frameName = string.format("%d.png",i)
                cclog("frameName = %s",frameName)
                local spriteFrame = spriteFrame:getSpriteFrame(frameName)
                animation:addSpriteFrame(spriteFrame)
            end

            animation:setDelayPerUnit(0.15)           --设置两个帧播放时间
            animation:setRestoreOriginalFrame(true)    --动画执行后还原初始状态

            local action = cc.Animate:create(animation)
            sprite:runAction(cc.RepeatForever:create(action))
            --//////////////////动画结束///////////////////
            isPlaying = true
        else
            sprite:stopAllActions()
            isPlaying = false
        end
    end
    toggleMenuItem:registerScriptTapHandler(OnAction)

    return layer
end


return AnimateScene