local size = cc.Director:getInstance():getWinSize()

local SpriteScene  = class("SpriteScene", function()
	return cc.Scene:create()
end)

function SpriteScene.create(...)
	local scene = SpriteScene .new()
	scene:addChild(scene:createLayer())
	return scene
end

function SpriteScene:actor()
end

function SpriteScene:createLayer(...)
	cclog("Game Scene Init")
	local layer = cc.Layer:create()
	
    local sBackground = cc.Sprite:create("background.png")
    sBackground:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(sBackground)

    -- sprite
    -- local tree1 = cc.Sprite:create("tree1.png", cc.rect(604,38,302,295))
    -- tree1:setPosition(cc.p(200,230))
    -- layer:addChild(tree1, 0)

    -- local cache = cc.Director:getInstance():getTextureCache():addImage("tree1.png")
    -- local tree2 = cc.Sprite:create()
    -- tree2:setTexture(cache)
    -- tree2:setTextureRect(cc.rect(73,72,182,270))
    -- tree2:setPosition(cc.p(500,200))
    -- layer:addChild(tree2, 0)

    -- sprite frame
    local frameCache = cc.SpriteFrameCache:getInstance()
    frameCache:addSpriteFrames("SpirteSheet.plist")

    local mountain1 = cc.Sprite:createWithSpriteFrameName("mountain1.png")
    mountain1:setAnchorPoint(cc.p(0,0))
    mountain1:setPosition(cc.p(-200,80))
    layer:addChild(mountain1, 0)

    local heroSpriteFrame = frameCache:getSpriteFrameByName("hero1.png")
    local hero1 = cc.Sprite:createWithSpriteFrame(heroSpriteFrame)
    hero1:setPosition(cc.p(800,200))
    layer:addChild(hero1, 0)
	
	return layer
end

return SpriteScene

