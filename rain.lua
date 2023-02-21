local RainDrop = Object:extend()

local anim8 = require("vendor.anim8.anim8")

local activeRaindrops = {}
local activeRainSplashes = {}

local splashTexture = love.graphics.newImage("assets/textures/eso_csopp_2.png")
local splashGrid = anim8.newGrid(8,8, splashTexture:getWidth(), splashTexture:getHeight())

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
        local x = math.random(1, love.graphics.getWidth()) -- TODO: from camera
        local y = -20
        local raindrop = RainDrop(x, y, world)

        table.insert(activeRaindrops, raindrop)
    end
    
end

function RainDrop.updateRain(dt)
    for i,raindrop in ipairs(activeRaindrops) do
        raindrop:update()
    end

    for i,splash in ipairs(activeRainSplashes) do
        if splash.animation:isOnEnd() then
            table.remove(activeRainSplashes, i)
        else
            splash.animation:update(dt)
        end
    end
end

function RainDrop:update(dt)
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

    for i,splash in ipairs(activeRainSplashes) do
        splash.animation:draw(splashTexture, splash.x, splash.y, 0, 1, 1)
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
        instance:spawnSplash()
        instance:remove()
       end
    end
end

function RainDrop:spawnSplash()
    print("asd")
    local splash = {}
    splash.animation = anim8.newAnimation(splashGrid("1-6", 1), 0.1)
    splash.x = self.x
    splash.y = self.y
    table.insert(activeRainSplashes, splash)
end

return RainDrop