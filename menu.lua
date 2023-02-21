local GameState = require("vendor.hump.gamestate")

Menu = {}

function Menu:enter()
    self.background = love.graphics.newImage("assets/imgs/menu_background.png")
end

function Menu:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)
end

function Menu:update(dt)
    
end

function Menu:keypressed(key, scancode, isrepeat)
    if key == "return" then
        GameState.switch(Game)
    end
end