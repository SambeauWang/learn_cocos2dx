local SpriteItem = class("SpriteItem", function(...)
    return cc.Sprite:create(...)
end)

function SpriteItem.create(...)
    return SpriteItem.new(...)
end

function SpriteItem:ctor()
    -- self:scheduleUpdate(function()
    --     print("test")
    -- end)
    -- print(self.scheduleUpdateWithPriorityLua)
    self:scheduleUpdateWithPriorityLua(self.update, 0)
end

function SpriteItem:update()
    print("test")
end

return SpriteItem