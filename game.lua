local Game = {}

local sti = require("vendor.sti")
local Camera = require ("vendor.hump.camera")

local Player = require("player")

function Game:load()
    self.map = sti("assets/maps/testmap.lua", {"box2d"})
    self.world = love.physics.newWorld(0.0)
    self.world:setCallbacks(Game.beginContact, Game.endContact)
    self.map:box2d_init(self.world)
    self.map.layers.solid.visible = false
    self.player = Player(self.world)
    self.camera = Camera(self.player.x, self.player.y, 2)
    self.camera.smoother = Camera.smooth.damped(10)
    self.background = love.graphics.newImage("assets/imgs/background2.png")
end

function Game:update(dt)
    self.world:update(dt)
    self.player:update(dt)

    --local dx, dy = self.player.x - self.camera.x, self.player.y - self.camera.y
    --self.camera:move(dx/2, dy/2)
    self.camera:lockPosition(self.player.x, self.player.y, Camera.smooth.damped(10))
    --self.camera:lookAt(self.player.x, self.player.y)
    --if self.camera.x < love.graphics.getWidth() / 2 then
    --    self.camera.x = love.graphics.getWidth() / 2
    --end
end

function Game:draw()
    
    self.camera:attach()
    ---
    love.graphics.draw(self.background)
    self.map:drawLayer(self.map.layers.tile_layer1)
    self.map:drawLayer(self.map.layers.tile_layer2)
    self.player:draw()
    ---
    self.camera:detach()
end

function Game.beginContact(a, b, collision)
    Game.player:beginContact(a, b, collision)
end

function Game.endContact(a, b, collision)
    Game.player:endContact(a, b, collision)
end

function Game:keypressed(key, scancode, isrepeat)
    Game.player:keypressed(key)
end


return Game