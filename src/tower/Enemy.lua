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

local Enemy = class("Enemy", function(...)
    return cc.Sprite:create(...)
end)

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
    if self:checkCirclesCollide(Position, 1.0, cc.p(Point[1], Point[2]), 1.0) then
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

function Enemy:checkCirclesCollide(p1, r1, p2, r2)
    local distance = cc.pGetDistance(p1, p2)
    return distance < r1 + r2
end

return Enemy