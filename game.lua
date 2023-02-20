local Game = {}

local sti = require("vendor.sti")
local gamera = require("vendor.gamera.gamera")
local Lighter = require("vendor.lighter")

local Player = require("player")

function Game:load()
    self.map = sti("assets/maps/testmap.lua", {"box2d"})
    self.world = love.physics.newWorld(0.0)
    self.world:setCallbacks(Game.beginContact, Game.endContact)
    self.map:box2d_init(self.world)
    self.map.layers.solid.visible = false
    self.player = Player(self.world)
    self.camera = gamera.new(0,0,640,480)
    self.camera:setPosition(self.player.x, self.player.x)
    self.camera:setScale(2.0)
    self.background = love.graphics.newImage("assets/imgs/background2.png")
    self.lighter = Lighter()
    self.playerLight = self.lighter:addLight(0, 0, 300, 1, 1, 1, 1)
    self.lightCanvas = love.graphics.newCanvas()
end

function Game:update(dt)
    self.world:update(dt)
    self.player:update(dt)

    local cx, cy = self.camera:getPosition()
    local dx = self.player.x - cx
    local dy = self.player.y - cy
    self.camera:setPosition(cx + dx * dt * 10, cy + dy * dt * 10)

    self.lighter:updateLight(self.playerLight, self.player.x, self.player.y)

    -- This is for lights, should be at the end
    love.graphics.setCanvas({ Game.lightCanvas, stencil = true})
    love.graphics.clear(0.4, 0.4, 0.4) -- Global illumination level
    Game.lighter:drawLights()
    love.graphics.setCanvas()
end

function Game.drawGame(l, t, w, h)
    love.graphics.draw(Game.background)
    Game.map:drawLayer(Game.map.layers.tile_layer1)
    Game.map:drawLayer(Game.map.layers.tile_layer2)
    Game.player:draw()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), Game.camera:toWorld(10, 10))
    
    -- This is for lights, should be at the end
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(Game.lightCanvas)
    love.graphics.setBlendMode("alpha")
end
  

function Game:draw()
    self.camera:draw(Game.drawGame)
end

function Game.beginContact(a, b, collision)
    Game.player:beginContact(a, b, collision)
end

function Game.endContact(a, b, collision)
    Game.player:endContact(a, b, collision)
end

function Game:keypressed(key, scancode, isrepeat)
    Game.player:keypressed(key)
end


return Game