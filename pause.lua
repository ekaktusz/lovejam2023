local GameState = require("vendor.hump.gamestate")
local TransitionAnimation = require("transition_animation")
local Button = require("button")

Pause = {}

function Pause:enter()
    self.background = love.graphics.newImage("assets/imgs/map_v07.png")
    self.scoreFont = love.graphics.newFont("assets/fonts/Gelio Fasolada.ttf", 60)

    self.openTransition = TransitionAnimation("open", 0.1)
    self.closeTransition = TransitionAnimation("close", 0.1)

    local continueButtonSprite = love.graphics.newImage("assets/imgs/startgombgorogbetus.png")
    self.continueButton = Button(550, 600, continueButtonSprite, function () 
        self.closeTransition:start()
    end)

    self.openTransition:start()
end

function Pause:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)

    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth(), love.graphics:getHeight())

    love.graphics.setColor(246/255, 190/255, 0, 1)
    love.graphics.rectangle("fill", 0, 30, love.graphics:getWidth(), 230)


    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(Menu.font)

    love.graphics.print("Prometheus", love.graphics:getWidth() /2 - 300, 50)
    love.graphics.setFont(self.scoreFont)
    love.graphics.print("Score: "..tostring(Game.player.score), 580, 300)

    self.continueButton:draw()

    self.openTransition:draw(0, 0)
    self.closeTransition:draw(0, 0)
end

function Pause:update(dt)
    if self.closeTransition:isFinished() then
        self.openTransition:reset()
        self.closeTransition:reset()
        GameState.pop()
    end

    self.openTransition:update(dt)
    self.closeTransition:update(dt)
end

function Pause:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        self.closeTransition:start()
    end
end

function Pause:mousepressed(x, y, button, istouch)
    Pause.continueButton:mousepressed(x, y,button,istouch)
    --Menu.mapButton:mousepressed(x,y,button,istouch)
 end