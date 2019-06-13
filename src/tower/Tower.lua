local scheduler = cc.Director:getInstance():getScheduler()

local Tower = class("Tower", function(...)
    return cc.Sprite:create(...)
end)

function Tower.create(...)
    return Tower.new(...)
end

function Tower:ctor()
    self.attackRange = 70
    self.fireRate = 1.0
    self.damage = 10

    self:scheduleUpdateWithPriorityLua(function(dt)
        self:schedule(dt)
    end, 0)
end

function Tower:shootWeapon()
    if not self.theGame then return end

    local bullet = cc.Sprite:create("Resources/iphonehd/bullet.png")
    bullet:setPosition(cc.p(self:getPosition()))
    self.theGame:addChild(bullet)

    local aMoveTo = cc.MoveTo:create(0.1, cc.p(self.chosenEnemy:getPosition()))
    local damage = cc.CallFunc:create(function()
        if self.chosenEnemy then
            self.chosenEnemy:getDamaged(self.damage)
        end
    end)
    local remove = cc.RepeatForever:create(function(node)
        node:removeFromParentAndCleanup(true)
    end)
    bullet:runAction(cc.Sequence:create(
        aMoveTo,
        damage,
        remove
    ))
end

function Tower:attackEnemy()
    self.shootSchedule = scheduler:scheduleScriptFunc(function()
        self:shootWeapon()
    end, self.fireRate, false)
end

function Tower:lostSightOfEnemy()
    if self.chosenEnemy then
        self.chosenEnemy:gotLostSight(self)
        self.chosenEnemy = nil
    end

    scheduler:unscheduleScriptEntry(self.shootSchedule)
end

function Tower:targetKilled()
    self.chosenEnemy = nil
    scheduler:unscheduleScriptEntry(self.shootSchedule)
end

function Tower:chosenEnemyForAttack(enemy)
    self.chosenEnemy = enemy
    self:attackEnemy()
    enemy:getAttacked(self)
end

function Tower:schedule(dt)
    if not self.theGame then return end

    if self.chosenEnemy then
        local enemyPos = self.chosenEnemy:getPosition()
        local myPos = self:getPosition()
        local normalized = cc.pNormalize(cc.pSub(enemyPos, myPos))
        local angle = math.atan(normalized.y / normalized.x) / math.pi * 180.0
        self:setRotation(angle)

        if not self.theGame:checkCirclesCollide(myPos, self.attackRange, enemyPos, 1.0) then
            self:lostSightOfEnemy()
        end
    else
        local Position = cc.p(self:getPosition())
        for _, enemy in ipairs(self.theGame.enemies) do
            local enemyPos = cc.p(enemy:getPosition())
            if self.theGame:checkCirclesCollide(Position, self.attackRange, enemyPos, 1.0) then
                self:chosenEnemyForAttack(enemy)
                break
            end
        end
    end
end

function Tower:setTheGame(theGame)
    self.theGame = theGame
end

