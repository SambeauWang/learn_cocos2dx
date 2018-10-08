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
    -- director:getOpenGLView():setDesignResolutionSize(640, 960, 0)
    director:getOpenGLView():setDesignResolutionSize(1136, 640, 0)

    director:setDisplayStats(true)
    director:setAnimationInterval(1.0/60.0)

    -- 创建场景
    -- local scene = require("GameScene")
    -- local scene = require("StartScene")
    -- local scene = require("ch8/GameScene")
    local scene = require("ch8/AnimateScene")
    local gameScene = scene.create()

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end