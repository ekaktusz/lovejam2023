-- Global includes
Object = require("vendor.classic.classic")

-- Local includes
local Game = require("game")
local Console = require("vendor.console.console")

-- Dont apply rastering on scaling (to nice pixelart)
love.graphics.setDefaultFilter("nearest", "nearest")

-- LÖVE specific callbascks
function love.load()
    Game:load()
    Console.ENV.Game = Game -- make game parameters accessible from the game console
end

function love.update(dt)
    if Console.isEnabled() then return end
    Game:update(dt)
end

function love.draw()
    Game:draw()
    Console:draw()
end

function love.keypressed(key, scancode, isrepeat)
    Console.keypressed(key, scancode, isrepeat)
    if Console.isEnabled() then return end
    Game.keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
    Console.textinput(text)
end
