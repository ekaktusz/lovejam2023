local Powerlevelbar = Object:extend()

function Powerlevelbar:new()
    self.w = 300
    self.h = 10
    self.offset = 2

    self.level = 0.5
end

function Powerlevelbar:draw(x, y)
    love.graphics.setColor( love.math.colorFromBytes(220, 220, 220) )
    love.graphics.rectangle("fill", x, y, self.w, self.h) -- outer
    love.graphics.setColor( love.math.colorFromBytes(255, 0, 0) )
    love.graphics.rectangle("fill", x + self.offset, y + self.offset, (self.w - self.offset * 2) * self.level, self.h- self.offset*2 ) -- inner
    love.graphics.setColor( love.math.colorFromBytes(255, 255, 255) )
end

function Powerlevelbar:setLevel(level)
    self.level = level
end

return Powerlevelbar