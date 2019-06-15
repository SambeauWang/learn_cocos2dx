-- local breakInfoFun,xpCallFun = require("LuaDebugjit")("localhost",7003)
-- cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)

-- cc.FileUtils:getInstance():setPopupNotify(false)

-- require "config"
-- require "cocos.init"

-- local function main()
--     require("app.MyApp"):create():run()
-- end

-- local status, msg = xpcall(main, __G__TRACKBACK__)
-- if not status then
--     print(msg)
-- end
require("cocos.init")
require("hat/VisibleRect")
require("hat/Const")
require("hat/Map")

local json = require 'dkjson'
local debuggee = require 'vscode-debuggee'
local startResult, breakerType = debuggee.start(json)
print('debuggee start ->', startResult, breakerType)
-- local breakSocketHandle, debugXpCall = require("LuaDebug")("localhost", 7003)

function cclog( ... )
    print(string.format(...))
end

function main()
    -- 避免内存泄漏
    collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")

    -- 初始化显示的帧率等参数
    local director = cc.Director:getInstance()
    director:getOpenGLView():setDesignResolutionSize(500, 1080, 0)
    director:getOpenGLView():setFrameSize(500, 1080)

    director:setDisplayStats(true)
    director:setAnimationInterval(1.0/60.0)

    -- local test = my.MyClass:create()
    -- print("lua bind: " .. test:foo(99))

    -- 创建场景
    -- local scene = require("GameScene")
    -- local scene = require("StartScene")
    -- local scene = require("tower/TowerScene")
    local scene = require("hat/HatScene")
    -- local scene = require("ch8/GameScene")
    -- local scene = require("ch8/AnimateScene")
    -- local scene = require("ch9event/GameScene")
    -- local scene = require("ch13physics/GameScene")
    -- local scene = require("ch14ui/GameScene")
    -- local scene = require("ch15/GameScene")
    -- local scene = require("scrollview/GameScene")
    local gameScene = scene.create()
    _G.gameScene = gameScene

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    -- debugXpCall()
    error(msg)
end