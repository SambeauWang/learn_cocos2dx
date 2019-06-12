-- ScrollView

local size =  cc.Director:getInstance():getWinSize()

local GameScene = class("GameScene", function()
    return cc.Scene:create()
end)

function GameScene.create(...)
    local scene = GameScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function GameScene:actor()
end

function GameScene:createLayer()
    return cc.CSLoader:createNode("MainScene.csb")
end

