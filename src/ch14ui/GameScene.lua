-- 物理相关

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

    local function ButtonCloseCallback( sender, eventType )
        if eventType == ccui.TouchEventType.began then
            cclog("Touch Down")
        elseif eventType == ccui.TouchEventType.move then
            cclog("Touch Move")
        elseif eventType == ccui.TouchEventType.ended then
            cclog("Touch Ended")
        else
            cclog("Touch Cancelled")
        end
    end

    local button = ccui.Button:create("ch14/CloseNormal.png", "ch14/CloseSelected.png")
    button:setPosition(size.width - button:getContentSize().width/2, button:getContentSize().height/2)
    button:addTouchEventListener(ButtonCloseCallback)
    button:setPressedActionEnabled(true)
    layer:addChild(button)

    local label = ccui.Text:create("Test for UI", "ch14/fonts/Marker Felt.ttf", 24)
    label:setColor(cc.c3b(159,168,176))
    label:setPosition(size.width/2, size.height - label:getContentSize().height)
    layer:addChild(label)

    local textBMFont = ccui.TextBMFont:create("Test for UI BMF", "ch14/fonts/BMFont.fnt")
    textBMFont:setScale(0.8)
    textBMFont:setPosition(size.width/2, size.height - label:getContentSize().height - textBMFont:getContentSize().height*0.8)
    layer:addChild(textBMFont, 1)

    local imageView = ccui.ImageView:create("ch14/HelloWorld.png")
    imageView:setPosition(size.width/2, size.height/2)
    layer:addChild(imageView)

    -- 创建 Radio Button
    local function onChangedRadioButtonGroup( sender, index, eventType )
        cclog("RadioButton " .. index .. "Clicked")
    end
    
    local radioButtonGroup = ccui.RadioButtonGroup:create()
    layer:addChild(radioButtonGroup)

    local NUMBER_BUTTONS = 5
    local BUTTON_WIDTH = 60
    local startPosX = size.width/2.0 - (NUMBER_BUTTONS - 1)/2.0 * BUTTON_WIDTH
    for i=0, NUMBER_BUTTONS - 1 do
        local radioButton = ccui.RadioButton:create("ch14/icon/btn_radio_off_holo.png",
        "ch14/icon/btn_radio_on_holo.png")

        local posX = startPosX + BUTTON_WIDTH * i
        radioButton:setPosition(posX, size.height - label:getContentSize().height - textBMFont:getContentSize().height*0.8 - 30)
        radioButtonGroup:addRadioButton(radioButton)
        radioButtonGroup:addEventListener(onChangedRadioButtonGroup)

        layer:addChild(radioButton)
    end

    return layer
end

return GameScene