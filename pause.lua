local GameState = require("vendor.hump.gamestate")

Pause = {}

function Pause:enter()
    self.background = love.graphics.newImage("assets/imgs/pause_background.png")
end

function Pause:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)
end

function Pause:update(dt)
    
end

function Pause:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        GameState.pop()
    end
end