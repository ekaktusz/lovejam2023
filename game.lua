local Game = {}

local Player = require("player")

function Game:load()
    self.player = Player()
end

function Game:update(dt)
    self.player:update(dt)
end

function Game:draw()
    self.player:draw()
end

return Game