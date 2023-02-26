local Button = Object:extend()

function Button:new(x, y, sprite, todo)
    self.x = x or 0
    self.y = y or 0
    self.todo = todo
    self.offset = 1

    self.sprite =  sprite

    self.scale = 2

    self.w = self.sprite:getWidth() * self.scale
    self.h = self.sprite:getHeight() * self.scale
end

function Button:draw()
    --love.graphics.setColor( love.math.colorFromBytes(220, 220, 220) )
    --love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    --love.graphics.setColor( love.math.colorFromBytes(255, 0, 0) )
    --love.graphics.rectangle("fill", self.x + self.offset, self.y + self.offset, self.w - self.offset*2, self.h - self.offset*2)
    --love.graphics.setColor( 1,1,1 )
    --love.graphics.print( self.text, self.x, self.y, 0, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
end

function Button:update(dt)
    local x, y = love.mouse.getPosition() -- get the position of the mouse
end

function Button:mousepressed(x, y, button, istouch)
    if button == 1 then
       if x > self.x and x < self.x + self.w then
            if y > self.y and y < self.y + self.h then
                self:todo()
            end
       end
    end
 end

 return Button