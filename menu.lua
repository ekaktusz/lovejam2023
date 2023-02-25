local GameState = require("vendor.hump.gamestate")

local Button = require("button")
Menu = {}

function Menu:enter()
    self.background = love.graphics.newImage("assets/imgs/map_v07.png")

    self.font = love.graphics.newFont("assets/fonts/Gelio Greek Diner.ttf", 120)
    love.graphics.setFont(self.font)

    local startButtonSprite = love.graphics.newImage("assets/imgs/startgombgorogbetus.png")
    self.startButton = Button(1000, 250, startButtonSprite, function () 
        GameState.switch(Game)
    end)
    --local mapButtonSprite = love.graphics.newImage("assets/imgs/mapbuttonfire1.png")
    --self.mapButton = Button(50, 100,mapButtonSprite, function () 
    --    GameState.switch(Game)
    --end)
end

function Menu:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth(), love.graphics:getHeight())
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Prometheus", 750, 100)

    self.startButton:draw()
    --self.mapButton:draw()
end

function Menu:update(dt)
    self.startButton:update(dt)
    --self.mapButton:update(dt)
end

function Menu:keypressed(key, scancode, isrepeat)
    if key == "return" then
        GameState.switch(Game)
    end
end

function love.mousepressed(x, y, button, istouch)
    Menu.startButton:mousepressed(x, y,button,istouch)
    --Menu.mapButton:mousepressed(x,y,button,istouch)
 end