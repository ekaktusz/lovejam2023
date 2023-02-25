local TransitionAnimation = Object:extend()

function TransitionAnimation:new(mode)
    self.speed = 0.03

    self.mode = mode
    self.alpha = 1 -- if open
    self.started = false

    if mode == "close" then
        self.alpha = 0
    end
end

function TransitionAnimation:update()
    if not self.started then return end

    if self:isFinished() then
        return
    end

    if self.mode == "close" then
        self.alpha = self.alpha + self.speed
    else
        -- open
        self.alpha = self.alpha - self.speed
    end 
end

function TransitionAnimation:draw()

    if not self.started then return end
    --love.graphics.setColor(0,0,0)
--
    --print(self.level)

    -- open
    --for i=love.graphics:getWidth(),self.level,-1 do
    --    love.graphics.circle("line", Game.player.x,Game.player.y, i)
    --end

    --for i=self.level,love.graphics:getWidth(),1 do
    --    love.graphics.circle("line", Game.player.x,Game.player.y, i)
    --end

    --love.graphics.setColor(1, 1, 1, 1 - transitionTimer)
    --love.graphics.rectangle("fill")

    local cx, cy = Game.camera:toWorld(0, 0)
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.rectangle("fill", cx, cy, love.graphics:getWidth(), love.graphics:getHeight())

   -- for i=love.graphics:getWidth(),self.level,-1 do
   --     love.graphics.circle("line", Game.player.x,Game.player.y, i)
   --     --love.graphics.circle("line", Game.player.x+1,Game.player.y+1, i)
   -- end
end

function TransitionAnimation:start()
    self.started = true
end

function TransitionAnimation:isFinished()
    if self.mode == "open" then
        return self.alpha <= 0
    end
    print(self.alpha)

    return self.alpha >= 1
end

function TransitionAnimation:reset()
    self.alpha = 1 -- if open
    self.started = false

    if self.mode == "close" then
        self.alpha = 0
    end
end

return TransitionAnimation