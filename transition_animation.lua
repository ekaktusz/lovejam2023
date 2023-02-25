local TransitionAnimation = Object:extend()

function TransitionAnimation:new(mode)
    self.speed = 1.1

    self.mode = mode
    self.level = 0 -- if open
    self.started = false

    if mode == "close" then
        self.level = love.graphics:getWidth()
    end
end

function TransitionAnimation:update()
    if not self.started then return end

    if self:isFinished() then
        return
    end

    if self.mode == "close" then
        self.level = self.level - math.max(self.speed * self.level / 30,10)
    else
        -- open
        self.level = self.level + math.max(self.speed * self.level / 30, 10)
    end 
end

function TransitionAnimation:draw()

    if not self.started or self:isFinished() then return end
    love.graphics.setColor(0,0,0)

    print(self.level)

    -- open
    --for i=love.graphics:getWidth(),self.level,-1 do
    --    love.graphics.circle("line", Game.player.x,Game.player.y, i)
    --end

    --for i=self.level,love.graphics:getWidth(),1 do
    --    love.graphics.circle("line", Game.player.x,Game.player.y, i)
    --end

    for i=love.graphics:getWidth(),self.level,-1 do
        love.graphics.circle("line", Game.player.x,Game.player.y, i)
        --love.graphics.circle("line", Game.player.x+1,Game.player.y+1, i)
    end
end

function TransitionAnimation:start()
    self.started = true
end

function TransitionAnimation:isFinished()
    if self.mode == "open" then
        return love.graphics:getWidth() < self.level
    end
    print(self.level)

    return self.level < 0
end

function TransitionAnimation:reset()
    self.level = 0 -- if open
    self.started = false

    if self.mode == "close" then
        self.level = love.graphics:getWidth()
    end
end

return TransitionAnimation