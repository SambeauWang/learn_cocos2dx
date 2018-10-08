-- require("Cocos2d")
-- require("Cocos2dConstants")

local size = cc.Director:getInstance():getWinSize()

local SettingScene = class("SettingScene", function()
	return cc.Scene:create()
end)

function SettingScene.create(...)
	local scene = SettingScene.new()
	scene:addChild(scene:createLayer())
	return scene
end

function SettingScene:actor()
end

function SettingScene:createLayer(...)
    cclog("Game Scene Init")
    local layer = cc.Layer:create()
    local director = cc.Director:getInstance()
    
    local bg = cc.Sprite:create("menu/setting-back.png")
    bg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bg)

    -- 音效
    local soundOnMenuItem = cc.MenuItemImage:create("menu/on.png", "menu/on.png")
    local soundOffMenuItem = cc.MenuItemImage:create("menu/off.png", "menu/off.png")
    local soundToggleMenuItem = cc.MenuItemToggle:create(soundOnMenuItem, soundOffMenuItem)
    soundToggleMenuItem:setPosition(director:convertToGL(cc.p(818,220)))
    local menuSoundToggleCallback = function ( sender )
        cclog("Sound Toggle.")
    end
    soundToggleMenuItem:registerScriptTapHandler(menuSoundToggleCallback)

    -- 音乐
    local musicOnMenuItem = cc.MenuItemImage:create("menu/on.png", "menu/on.png")
    local musicOffMenuItem = cc.MenuItemImage:create("menu/off.png", "menu/off.png")
    local musicToggleMenuItem = cc.MenuItemToggle:create(musicOnMenuItem, musicOffMenuItem)
    musicToggleMenuItem:setPosition(director:convertToGL(cc.p(818,362)))
    local menuMusicToggleCallback = function ( sender )
        cclog("Sound Toggle.")
    end
    musicToggleMenuItem:registerScriptTapHandler(menuMusicToggleCallback)

    local okMenuItem = cc.MenuItemImage:create("menu/ok-down.png", "menu/ok-up.png")
    okMenuItem:setPosition(director:convertToGL(cc.p(600,510)))
    local menuOkCallback = function ( sender )
        cclog("Ok Menu tap.")
        director:popScene()
    end
    okMenuItem:registerScriptTapHandler(menuOkCallback)

    local mn = cc.Menu:create(soundToggleMenuItem, musicToggleMenuItem, okMenuItem)
    mn:setPosition(cc.p(0,0))
    layer:addChild(mn)
    
	return layer
end

return SettingScene

