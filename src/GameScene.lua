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

function GameScene:createLayer( ... )
    cclog("Game Scene Init")
    local layer = cc.Layer:create()

    local label = cc.Label:createWithSystemFont("HellowWorld", "Arial", 36)
    label:setPosition(cc.p(size.width/2, size.height - 100))
    layer:addChild(label)

    -- local sprite = cc.Sprite:create("HelloWorld.png")
    -- sprite:setPosition(cc.p(size.width/2,size.height/2))
    -- layer:addChild(sprite)

    -- -- 游戏调度器
    -- local function update( delta )
    --     local x,y = label:getPosition()
    --     label:setPosition(x+2, y-2)
    -- end

    -- layer:scheduleUpdateWithPriorityLua(update, 0)

    -- local function onNodeEvent( tag )
    --     if tag == "exit" then
    --         layer:unscheduleUpdate()
    --     end
    -- end
    -- layer:registerScriptHandler(onNodeEvent)

    -- 标签类
    local gap = 120     -- 控件之间的间隔

    local label2 = cc.Label:createWithTTF("test for ttf label", "fonts/STLITI.ttf", 36)
    label2:setPosition(cc.p(size.width/2, size.height - 2 * gap))
    layer:addChild(label2, 1)

    local ttfConfig = {}
    ttfConfig.fontFilePath = "fonts/Marker Felt.ttf"
    ttfConfig.fontSize = 32
    ttfConfig.outlineSize = 4

    local label3 = cc.Label:createWithTTF(ttfConfig, "test for ttf label paht")
    label3:setPosition(cc.p(size.width/2, size.height - 3 *gap))
    label3:enableShadow(cc.c4b(255,255,255,128), cc.size(4,-4))
    label3:setColor(cc.c3b(255,0,0))
    layer:addChild(label3, 1)

    local label5 = cc.Label:createWithBMFont("fonts/BMFont.fnt", "test for png")
    label5:setPosition(cc.p(size.width/2,size.height - 4 * gap))
    layer:addChild(label5, 1)

    local label6 = cc.LabelAtlas:create("test for label altas", "fonts/tuffy_bold_italic-charmap.png", 48, 66, string.byte(" "))
    label6:setPosition(cc.p(size.width/2 - label6:getContentSize().width/2, size.height - label6:getContentSize().height))
    layer:addChild(label6, 1)

    -- 菜单项
    cc.MenuItemFont:setFontName("Times New Roman")
    cc.MenuItemFont:setFontSize(86)

    local item1 = cc.MenuItemFont:create("Start")
    local mnItem1Callback = function( sender )
        cclog("Touch Start Menu Item")
    end
    item1:registerScriptTapHandler(mnItem1Callback)

    local itemLabel = cc.LabelAtlas:create("help", "menu/tuffy_bold_italic-charmap.png", 48, 65, string.byte(" "))
    local item2 = cc.MenuItemLabel:create(itemLabel)
    local function mnItem2Callback( sender )
        cclog("Touch Help Menu Item")
    end
    item2:registerScriptTapHandler(mnItem2Callback)

    local mn = cc.Menu:create(item1, item2)
    mn:alignItemsVertically()
    layer:addChild(mn)

    -- sprite和image 菜单
    local startLocalNormal = cc.Sprite:create("menu/start-up.png")
    local startLocalSelect = cc.Sprite:create("menu/start-down.png")
    local startMenuItem = cc.MenuItemSprite:create(startLocalNormal, startLocalSelect)
    startMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(700,170)))
    local mnItemStartCallback = function ( sender )
        cclog("Touch Start")
    end
    startMenuItem:registerScriptTapHandler(mnItemStartCallback)

    local settingMenuItem = cc.MenuItemImage:create("menu/setting-up.png", "menu/setting-down.png")
    settingMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(480,400)))
    local mnItemSettingCallback = function ( sender )
        cclog("Touch Setting.")
    end
    settingMenuItem:registerScriptTapHandler(mnItemSettingCallback)

    -- toggle Menu
    local soundOnMenuItem = cc.MenuItemImage:create("menu/on.png", "menu/on.png")
    local soundOffMenuItem = cc.MenuItemImage:create("menu/off.png", "menu/off.png") 
    local soundToggleMenuItem = cc.MenuItemToggle:create(soundOnMenuItem, soundOffMenuItem)
    soundToggleMenuItem :setPosition(cc.Director:getInstance():convertToGL(cc.p(100, 200))) 
    local soundToggleCallback = function ( sender )
        cclog("Sound Toggle")
    end
    soundToggleMenuItem:registerScriptTapHandler(soundToggleCallback)

    local mn2 = cc.Menu:create(startMenuItem, settingMenuItem, soundToggleMenuItem)
    mn2:setPosition(cc.p(0, 0))
    layer:addChild(mn2) 

    return layer
end

return GameScene

