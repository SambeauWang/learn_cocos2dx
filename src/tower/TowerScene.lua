local size = cc.Director:getInstance():getWinSize()

local isPlaying = false
local SpwanTime = {
    [1] = {0.1}, -- , 0.5, 0.6, 1.0, 3.0, 6.0
    [2] = {1, 2, 3},
    [3] = {1, 2, 3, 4, 5},
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

    self:addChild(self:createLayer())
    self:loadWave()
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
    -- this->awardGold(0); //just to display initial ammount

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

return TowerScene


