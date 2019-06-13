local size = cc.Director:getInstance():getWinSize()

local removeItem = function(list, item)
    local rmCount = 0
    for i = 1, #list do
        if list[i - rmCount] == item then
            table.remove(list, i - rmCount)
        end
    end
end

local TOWER_COST = 300
local isPlaying = false
local SpwanTime = {
    [1] = {0.1}, -- , 0.5, 0.6, 1.0, 3.0, 6.0
    [2] = {1, 2, 3},
    [3] = {1, 2, 3, 4, 5},
}

local TowerPoints = {
    cc.p(200, 535),
    cc.p(400, 535),
    cc.p(600, 535),
    cc.p(190, 350),
    cc.p(340, 350),
    cc.p(480, 350),
    cc.p(620, 350),
    cc.p(770, 350),
    cc.p(190, 170),
    cc.p(335, 170),
    cc.p(477, 170),
    cc.p(620, 170),
}

local TowerScene = class("TowerScene", function()
    return cc.Scene:create()
end)

function TowerScene.create()
    local scene = TowerScene.new()
    return scene
end

function TowerScene:ctor()
    self.playerHP = 0
    self.wave = 1
    self.enemies = {}
    self.towerBases = {}
    self.playerGold = 0

    self:addChild(self:createLayer())
    self:loadWave()
    self:loadTowerPosition()
    self:addTouchFunction()
end

function TowerScene:createLayer()
    self.layer = cc.Layer:create()
    self.background = cc.Sprite:create("Resources/iphonehd/bg.png")
    self.background:setPosition(cc.p(size.width/2, size.height/2))
    self.layer:addChild(self.background)

    -- HP
    self.ui_hp_lbl = cc.LabelBMFont:create("HP: " .. self.playerHP, "Resources/iphonehd/font_red_14.fnt")
    self.ui_hp_lbl:setPosition(cc.p(35, size.height - 12))
    self.ui_hp_lbl:setAnchorPoint(cc.p(0, 0.5))
    self.layer:addChild(self.ui_hp_lbl)

    -- WAVE
    self.ui_wave_lbl = cc.LabelBMFont:create("", "Resources/iphonehd/font_red_14.fnt")
    self.ui_wave_lbl:setPosition(cc.p(400, size.height - 12));
    self.ui_wave_lbl:setAnchorPoint(cc.p(0, 0.5));
    self.layer:addChild(self.ui_wave_lbl);

    -- GOLD
    self.ui_gold_lbl = cc.LabelBMFont:create("", "Resources/iphonehd/font_red_14.fnt");
    self.ui_gold_lbl:setPosition(cc.p(135, size.height - 12));
    self.ui_gold_lbl:setAnchorPoint(cc.p(0, 0.5));
    self.layer:addChild(self.ui_gold_lbl);
    self:awardGold(0)

    return self.layer
end

function TowerScene:loadWave()
    if self.wave > #SpwanTime then return false end

    for _, i in ipairs(SpwanTime[self.wave]) do
        local Enemy = require("tower/Enemy").create("Resources/iphonehd/enemy.png")
        Enemy:setTheGame(self)
        Enemy:setPosition(cc.p(0, 440))
        performWithDelay(Enemy, Enemy.doActive, i)

        self.layer:addChild(Enemy)
        table.insert(self.enemies, Enemy)
    end

    self.ui_wave_lbl:setString(string.format("WAVE: %d", self.wave))
    self.wave = self.wave + 1

    return true
end

function TowerScene:loadTowerPosition()
    for _, p in ipairs(TowerPoints) do
        local TowerBase = cc.Sprite:create("Resources/iphonehd/open_spot.png")
        TowerBase:setPosition(p)
        self.layer:addChild(TowerBase)
        table.insert(self.towerBases, TowerBase)
    end
end

function TowerScene:addTouchFunction()
    local onTouchesEnd = function(touches, event)
        self:onTouchesEnd(touches, event)
    end

    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesEnd, cc.Handler.EVENT_TOUCHES_ENDED)
    self.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.layer)
end

function TowerScene:awardGold(gold)
    self.playerGold = self.playerGold + gold
    self.ui_gold_lbl:setString("GOLD" .. self.playerGold)
end

function TowerScene:onTouchesEnd(touches, event)
    local touchLocation = touches[1]:getLocation()
    for _, TowerBase in ipairs(self.towerBases) do
        local locationInNode = TowerBase:convertToNodeSpace(touchLocation)
        local s = TowerBase:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)

        if not TowerBase.UserData and cc.rectContainsPoint(rect, locationInNode) then
            local Tower = require("tower/Tower").create("Resources/iphonehd/tower.png")
            Tower:setTheGame(self)
            Tower:setAnchorPoint(cc.p(0.5, 0.5))
            Tower:setPosition(cc.p(TowerBase:getPosition()))

            self.Layer:addChild(Tower)
            TowerBase.UserData = Tower

            self.playerGold = self.playerGold - TOWER_COST
            self:awardGold(0)
        end
    end
end

function TowerScene:checkCirclesCollide(p1, r1, p2, r2)
    local distance = cc.pGetDistance(p1, p2)
    return distance < r1 + r2
end

function TowerScene:enemyGotKilled(enemy)
    removeItem(self.enemies, enemy)
    if #self.enemies < 0 then
        if not self:loadWave() then
            -- TODO Win
        end
    end
end

return TowerScene


