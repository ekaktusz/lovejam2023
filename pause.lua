local GameState = require("vendor.hump.gamestate")
local TransitionAnimation = require("transition_animation")

Pause = {}

function Pause:enter()
    self.background = love.graphics.newImage("assets/imgs/pause_background.png")

    self.openTransition = TransitionAnimation("open")
    self.closeTransition = TransitionAnimation("close")

    self.openTransition:start()
end

function Pause:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)

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