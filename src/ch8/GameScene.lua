PLAY_TAG = 102
FLIPX_TAG = 103
FLIPY_TAG = 104
HIDE_SHOW_TAG = 105
TOGGLE_TAG = 106

kSequence = 107
CallBack_TAG = 108

actionFLag = -1

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

    local bg = cc.Sprite:create("ch8/Background.png")
    bg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bg)

    local function OnClickCallback( tag, mnItemSender )
        cclog("tag = %d", tag)
        actionFLag = mnItemSender:getTag()

        local scene = require("ch8/MyActionScene")
        local nextScene = scene.create()
        local ts = cc.TransitionJumpZoom:create(1, nextScene)
        cc.Director:getInstance():pushScene(ts)
    end

    local placeLabel = cc.Label:createWithBMFont("ch8/fonts/fnt2.fnt", "Place")
    local placeMenu = cc.MenuItemLabel:create(placeLabel)
    placeMenu:setTag(PLAY_TAG)
    placeMenu:registerScriptTapHandler(OnClickCallback)

    local flipXLabel = cc.Label:createWithBMFont("ch8/fonts/fnt2.fnt", "FlipX")
    local flipXMenu = cc.MenuItemLabel:create(flipXLabel)
    flipXMenu:setTag(FLIPX_TAG)
    flipXMenu:registerScriptTapHandler(OnClickCallback)

    local flipYLabel = cc.Label:createWithBMFont("ch8/fonts/fnt2.fnt", "FlipY")
    local flipYMenu = cc.MenuItemLabel:create(flipYLabel)
    flipYMenu:setTag(FLIPY_TAG)
    flipYMenu:registerScriptTapHandler(OnClickCallback)

    local hideLabel = cc.Label:createWithBMFont("ch8/fonts/fnt2.fnt", "Hide or Show")
    local hideMenu = cc.MenuItemLabel:create(hideLabel)
    hideMenu:setTag(HIDE_SHOW_TAG)
    hideMenu:registerScriptTapHandler(OnClickCallback)

    local sequenceLabel = cc.Label:createWithBMFont("ch8/fonts/fnt2.fnt", "Sequence")
    local sequenceMenu = cc.MenuItemLabel:create(sequenceLabel)
    sequenceMenu:setTag(kSequence)
    sequenceMenu:registerScriptTapHandler(OnClickCallback)

    local callbackLabel = cc.Label:createWithBMFont("ch8/fonts/fnt2.fnt", "CallbackND")
    local callbackMenu = cc.MenuItemLabel:create(callbackLabel)
    callbackMenu:setTag(CallBack_TAG)
    callbackMenu:registerScriptTapHandler(OnClickCallback)

    local mn = cc.Menu:create(placeMenu, flipXMenu, flipYMenu, hideMenu, sequenceMenu, callbackMenu)
    mn:alignItemsVertically()
    layer:addChild(mn)

    return layer
end

return GameScene