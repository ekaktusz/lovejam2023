local RainDrop = Object:extend()

local activeRaindrops = {}

function RainDrop:new(x,y,world)
    self.x = x
    self.y = y
    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.physics.shape = love.physics.newCircleShape(2)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setMass(1)
end

function RainDrop:remove()
    for i,instance in ipairs(activeRaindrops) do
       if instance == self then
          self.physics.body:destroy()
          table.remove(activeRaindrops, i)
       end
    end
end

function RainDrop.generateRain(cx, cy, world)

    for i = 1, 10 do
        local x = math.random(1, 640)
        local y = 0
        local raindrop = RainDrop(x, y, world)

        table.insert(activeRaindrops, raindrop)
    end
    
end

function RainDrop.updateRain()
    for i,instance in ipairs(activeRaindrops) do
        instance:update()
    end
end

function RainDrop:update()
    self:syncPhysics()
end

function RainDrop:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
 end
 

function RainDrop.drawRain()
    for i,instance in ipairs(activeRaindrops) do
        instance:draw()
    end
end

function RainDrop:draw()
    love.graphics.setColor(0, 1, 1)
    love.graphics.circle( "fill", self.x, self.y, 2 )
    love.graphics.setColor(1, 1, 1)
end

function RainDrop.beginContact(a, b, collision)
    for i,instance in ipairs(activeRaindrops) do
       if a == instance.physics.fixture or b == instance.physics.fixture then
        instance:remove()
       end
    end
 end

return RainDrop