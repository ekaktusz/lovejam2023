local GameState = require("vendor.hump.gamestate")

local Button = require("button")
Menu = {}

function Menu:enter()
    self.background = love.graphics.newImage("assets/imgs/menu_background.png")

    local startButtonSprite = love.graphics.newImage("assets/imgs/startgombgorogbetus.png")
    self.startButton = Button(50, 50, startButtonSprite, function () 
        GameState.switch(Game)
    end)
    local mapButtonSprite = love.graphics.newImage("assets/imgs/mapbuttonfire1.png")
    self.mapButton = Button(50, 100,mapButtonSprite, function () 
        GameState.switch(Game)
    end)
end

function Menu:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)
    self.startButton:draw()
    self.mapButton:draw()
end

function Menu:update(dt)
    self.startButton:update(dt)
    self.mapButton:update(dt)
end

function Menu:keypressed(key, scancode, isrepeat)
    if key == "return" then
        GameState.switch(Game)
    end
end

function love.mousepressed(x, y, button, istouch)
    Menu.startButton:mousepressed(x, y,button,istouch)
    Menu.mapButton:mousepressed(x,y,button,istouch)
 end