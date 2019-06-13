-- local WayPoints = {
--     {614, 220},
--     {445,220},
--     {445,130},
--     {35,130},
--     {35,35},
--     {420,35}
-- }
local WayPoints = {
    {0,440},
    {880,440},
    {880,260},
    {70,260},
    {70,70},
    {780,70}
}

local PLAYER_AWARD = 200

local Enemy = class("Enemy", function(...)
    return cc.Sprite:create(...)
end)

local removeItem = function(list, item)
    local rmCount = 0
    for i = 1, #list do
        if list[i - rmCount] == item then
            table.remove(list, i - rmCount)
        end
    end
end

function Enemy.create(...)
    return Enemy.new(...)
end

function Enemy:ctor()
    self.MaxHp = 40
    self.CurHp = self.MaxHp
    self.Active = false
    self.WalkingSpeed = 1.0
    self.DestinationIndex = 1
    self.theGame = nil
    self.attackedBy = {}

    self:scheduleUpdateWithPriorityLua(function(dt)
        self:schedule(dt)
    end, 0)
end

function Enemy:setTheGame(theGame)
    self.theGame = theGame
end

function Enemy:schedule(dt)
    if not self.Active or not self.theGame then
        return
    end

    local Point = WayPoints[self.DestinationIndex]
    local Position = cc.p(self:getPosition())
    if self.theGame:checkCirclesCollide(Position, 1.0, cc.p(Point[1], Point[2]), 1.0) then
        self.DestinationIndex = self.DestinationIndex + 1
        Point = WayPoints[self.DestinationIndex]
        if not Point then
            -- move the enemy
            return
        end
    end

    local Direction = cc.pNormalize(cc.pSub(cc.p(Point[1], Point[2]), Position))
    local Rotation = math.atan(Direction.y / Direction.x) / math.pi * 180.0

    local Destination = cc.pAdd(Position, cc.pMul(Direction, self.WalkingSpeed))
    self:setPosition(Destination)
    local x, y = self:getPosition()
    self:setRotation(Rotation)
end

function Enemy:doActive()
    self.Active = true
end

function Enemy:gotLostSight(attacker)
    removeItem(self.attackedBy, attacker)
end

function Enemy:getAttacked(attacker)
    table.insert(self.attackedBy, attacker)
end

function Enemy:getRemoved()
    for _, Tower in ipairs(self.attackedBy) do
        Tower:targetKilled()
    end

    self.theGame:enemyGotKilled(self)
    self:removeFromParentAndCleanup(true)
end

function Enemy:getDamaged(damage)
    self.CurHp = self.CurHp - damage
    if self.CurHp <= 0 then
        self.theGame:awardGold(PLAYER_AWARD)
        self:getRemoved()
    end
end

return Enemy