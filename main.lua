-- Global includes
Object = require("vendor.classic.classic")
Console = require("vendor.console.console")

-- Local includes
local Game = require("game")

-- Dont apply rastering on scaling (to nice pixelart)
love.graphics.setDefaultFilter("nearest", "nearest")

-- LÖVE specific callbascks
function love.load()
    Game:load()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end