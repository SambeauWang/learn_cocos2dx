--[[

Copyright (c) 2014-2017 Chukong Technologies Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

-- debug setting
-- local breakInfoFun, xpCallFun = require("LuaDebugjit")("localhost", 7003)
-- cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)

require "cocos.cocos2d.Cocos2d"
require "cocos.cocos2d.Cocos2dConstants"
require "cocos.cocos2d.functions"

local _RUNTIME_ERROR = print

local function getlocals( frame )
    local i = 1
    frame = traceback.gettop() + 1 + frame
    local info = debug.getinfo(frame)
    if info == nil then return end

    local total = 1
    local var_names  = {}
    local var_values = {}

    if info.func then
        i = 1
        while true do
            local name, value = debug.getupvalue(info.func,i)
            if not name then break end

            var_names[total] = name
            var_values[total] = value  --不要用table.insert, value可能为nil

            total = total + 1
            i = i + 1
        end
    end

    i = 1
    while true do
        local name, value = debug.getlocal( frame, i)
        if not name then break end

        var_names[total] = name
        var_values[total] = value

        total = total + 1
        i = i + 1
    end

    return var_names, var_values
end

function get_backtrace( botframe, PrintVar )
	local btinfo = {}
	table.insert(btinfo, 'traceback:')
	local top = traceback.gettop()
	local indicator = ' '

	for frame = botframe, -1  do
		local level = ( top + 1 ) + frame
		local info = debug.getinfo(level,'nfSlu')
		if info == nil then
			break
		end

		local i = frame - botframe
		if info.what == 'C' then   -- is a C function?
			if info.name ~= nil then
				table.insert(btinfo, string.format('\t%s%2d[C] : in %s',indicator, i, info.name))
			else
				table.insert(btinfo, string.format('\t%s%2d[C] :',indicator, i))
			end
		else   -- a Lua function
			if info.name ~= nil then
				table.insert(btinfo , string.format('\t%s%2d %s:%d in %s',indicator, i, info.source, info.currentline, info.name))
			else
				table.insert(btinfo, string.format('\t%s%2d %s:%d',indicator, i, info.source, info.currentline))
			end

			if PrintVar then
				local var_names, var_values = getlocals( frame )
				for pos, name in ipairs(var_names) do
					local val = string.sub(tostring(var_values[pos]), 1, 50)
					local Msg = string.format("\t\t%s:%s", name, val)
					table.insert(btinfo, Msg)
				end
			end
		end
	end
	return table.concat(btinfo, "\n")
end

function SafeXy3Except(Error)
	_RUNTIME_ERROR("ERROR!!", Error )
	local btinfo = nil
	local function Xy3Except()
		local curframe = -traceback.gettop() -- the curframe as at the top frame as 0
        if curframe < -100 then
	        return "stack too deep!!\n" .. debug.traceback()
        end
		local botframe = curframe + 4 -- as 'SafeXy3Except' is 4 frame under the last fuction
		btinfo = get_backtrace(botframe, true)
		print(btinfo)
	end
	xpcall(Xy3Except, function(Error) _RUNTIME_ERROR("internal excepthook error", Error) end)

	return Error, btinfo
end

__G__TRACKBACK__ = function(msg)
    -- xpCallFun()
    local msg = debug.traceback(msg)
    print(msg)
    return msg
    -- local errInfo, btInfo = SafeXy3Except(msg)
    -- ERROR(tostring(msg))
    -- return debug.traceback(msg)
end

-- opengl
require "cocos.cocos2d.Opengl"
require "cocos.cocos2d.OpenglConstants"
-- audio
require "cocos.cocosdenshion.AudioEngine"
-- cocosstudio
if nil ~= ccs then
    require "cocos.cocostudio.CocoStudio"
end
-- ui
if nil ~= ccui then
    require "cocos.ui.GuiConstants"
    require "cocos.ui.experimentalUIConstants"
end

-- extensions
require "cocos.extension.ExtensionConstants"
-- network
require "cocos.network.NetworkConstants"
-- Spine
if nil ~= sp then
    require "cocos.spine.SpineConstants"
end

require "cocos.cocos2d.deprecated"
require "cocos.cocos2d.DrawPrimitives"

-- Lua extensions
require "cocos.cocos2d.bitExtend"

-- CCLuaEngine
require "cocos.cocos2d.DeprecatedCocos2dClass"
require "cocos.cocos2d.DeprecatedCocos2dEnum"
require "cocos.cocos2d.DeprecatedCocos2dFunc"
require "cocos.cocos2d.DeprecatedOpenglEnum"

-- register_cocostudio_module
if nil ~= ccs then
    require "cocos.cocostudio.DeprecatedCocoStudioClass"
    require "cocos.cocostudio.DeprecatedCocoStudioFunc"
end


-- register_cocosbuilder_module
require "cocos.cocosbuilder.DeprecatedCocosBuilderClass"

-- register_cocosdenshion_module
require "cocos.cocosdenshion.DeprecatedCocosDenshionClass"
require "cocos.cocosdenshion.DeprecatedCocosDenshionFunc"

-- register_extension_module
require "cocos.extension.DeprecatedExtensionClass"
require "cocos.extension.DeprecatedExtensionEnum"
require "cocos.extension.DeprecatedExtensionFunc"

-- register_network_module
require "cocos.network.DeprecatedNetworkClass"
require "cocos.network.DeprecatedNetworkEnum"
require "cocos.network.DeprecatedNetworkFunc"

-- register_ui_module
if nil ~= ccui then
    require "cocos.ui.DeprecatedUIEnum"
    require "cocos.ui.DeprecatedUIFunc"
end

-- cocosbuilder
require "cocos.cocosbuilder.CCBReaderLoad"

-- physics3d
require "cocos.physics3d.physics3d-constants"

if CC_USE_FRAMEWORK then
    require "cocos.framework.init"
end

