-- Global includes
Object = require("vendor.classic.classic")

-- Local includes
local GameState = require("vendor.hump.gamestate")

require("menu")
require("game")
require("pause")

-- Dont apply rastering on scaling (to nice pixelart)
love.graphics.setDefaultFilter("nearest", "nearest")

-- LÖVE specific callbascks
function love.load()
    GameState.registerEvents()
    GameState.switch(Menu)
end