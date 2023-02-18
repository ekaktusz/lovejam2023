local Game = {}

local sti = require("vendor.sti")

local Player = require("player")

function Game:load()
    self.map = sti("assets/maps/testmap.lua", {"box2d"})
    self.world = love.physics.newWorld(0.0)
    self.world:setCallbacks(Game.beginContact, Game.endContact)
    self.map:box2d_init(self.world)
    self.map.layers.solid.visible = false
    self.player = Player(self.world)
end

function Game:update(dt)
    self.world:update(dt)
    self.player:update(dt)
end

function Game:draw()
    self.map:draw()
    self.player:draw()
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