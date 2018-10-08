-- require("Cocos2d")
-- require("Cocos2dConstants")

local SettingScene = require("SettingScene")

local size = cc.Director:getInstance():getWinSize()

local StartScene = class("StartScene", function()
	return cc.Scene:create()
end)

function StartScene.create(...)
	local scene = StartScene.new()
	scene:addChild(scene:createLayer())
	return scene
end

function StartScene:ctor()
    cclog("test for ctor")
    local onNodeEvent = function ( event )
        if event == "enter" then
            self:onEnter()
        elseif event == "enterTransitionFinish" then
            self:onEnterTransitionFinish()
        elseif event == "exit" then
            self:onExit()
        elseif event == "exitTransitionStart" then
            self:onExitTransitionStart()
        elseif event == "cleanup" then
            self:cleanup()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function StartScene:onEnter()
    cclog("GameScene onEnter")
end

function StartScene:onEnterTransitionFinish()
    cclog("Game onEnterTransitionFinish")
end

function StartScene:onExit()
    cclog("Game onExit")
end

function StartScene:onExitTransitionStart( )
    cclog("GameScene onExitTransitionStart")
end

function StartScene:cleanup( )
    cclog("GameScene cleanup")
end

function StartScene:createLayer(...)
	cclog("Game Scene Init")
    local layer = cc.Layer:create()
    local director = cc.Director:getInstance()
    
    local bg = cc.Sprite:create("menu/background.png")
    bg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bg)

    -- 开始按钮
    local startlocalNormal = cc.Sprite:create("menu/start-up.png")
    local startlocalSelected = cc.Sprite:create("menu/start-down.png")
    local startMenuItem = cc.MenuItemSprite:create(startlocalNormal, startlocalSelected)
    startMenuItem:setPosition(director:convertToGL(cc.p(700,170)))
    local menuItemStartCallback = function ( sender )
        cclog("Touch Start")
    end
    startMenuItem:registerScriptTapHandler(menuItemStartCallback)

    -- 设置相关的按钮
    local settingMenuItem = cc.MenuItemImage:create("menu/setting-up.png", "menu/setting-down.png")
    settingMenuItem:setPosition(director:convertToGL(cc.p(480,400)))
    local menuItemSettingCallback = function ( sender )
        cclog("Touch setting.")
        local settingScene = SettingScene.create()
        director:pushScene(settingScene)
    end
    settingMenuItem:registerScriptTapHandler(menuItemSettingCallback)

    local helpMenuItem = cc.MenuItemImage:create("menu/help-up.png", "menu/help-down.png")
    helpMenuItem:setPosition(director:convertToGL(cc.p(860,480)))
    local menuItemHelpCallback = function ( sender )
        cclog("Touch help.")
    end
    helpMenuItem:registerScriptTapHandler(menuItemHelpCallback)

    local mn = cc.Menu:create(startMenuItem, settingMenuItem, helpMenuItem)
    mn:setPosition(cc.p(0,0))
    layer:addChild(mn)
	
	return layer
end

return StartScene

