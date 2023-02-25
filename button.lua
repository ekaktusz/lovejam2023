local Button = Object:extend()

function Button:new(x, y, sprite, todo)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
    self.text = text
    self.todo = todo
    self.offset = 1

    self.sprite =  sprite

    self.w = self.sprite:getWidth()
    self.h = self.sprite:getHeight()
end

function Button:draw()
    --love.graphics.setColor( love.math.colorFromBytes(220, 220, 220) )
    --love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    --love.graphics.setColor( love.math.colorFromBytes(255, 0, 0) )
    --love.graphics.rectangle("fill", self.x + self.offset, self.y + self.offset, self.w - self.offset*2, self.h - self.offset*2)
    --love.graphics.setColor( 1,1,1 )
    --love.graphics.print( self.text, self.x, self.y, 0, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Button:update(dt)
    local x, y = love.mouse.getPosition() -- get the position of the mouse
end

function Button:mousepressed(x, y, button, istouch)
    if button == 1 then
       if x > self.x and x < self.x + self.w then
            if y > self.y and y < self.y + self.h then
                print("pukitank")
                self:todo()
            end
       end
    end
 end

 return Button