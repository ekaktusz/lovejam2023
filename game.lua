 Game = {}

local sti = require("vendor.sti")
local gamera = require("vendor.gamera.gamera")
local Lighter = require("vendor.lighter")
local Parallax = require ("vendor.parallax.parallax")
local GameState = require("vendor.hump.gamestate")
local Console = require("vendor.console.console")

local RainDrop = require("rain")
local Amphora = require("amphora")
local Grass = require("grass")
local Checkpoint = require("checkpoint")

local Player = require("player")


Console.ENV.Game = Game -- make game parameters accessible from the game console


function Game:enter()
    self.map = sti("assets/maps/testmap2.lua", {"box2d"})
    self.world = love.physics.newWorld(0.0, 100)
    self.world:setCallbacks(Game.beginContact, Game.endContact)
    self.map:box2d_init(self.world)
    self.map.layers.solid.visible = false
    self.player = Player(self.world)
    self.camera = gamera.new(0,0,love.graphics.getWidth(),love.graphics.getHeight())
    self.camera:setPosition(self.player.x, self.player.x)
    self.camera:setScale(2)
    self.background = love.graphics.newImage("assets/imgs/background2.png")
    self.lighter = Lighter()
    self.playerLight = self.lighter:addLight(0, 0, 300, 1, 1, 1, 1)
    self.lightCanvas = love.graphics.newCanvas()

    self.parallaxLayers = {
        parallax_1 = Parallax.new(self.camera, 1.25),
        parallax_2 = Parallax.new(self.camera, 1)
    }

    self.rainAudio = love.audio.newSource("assets/audio/rain/rain.wav", "stream")
    self.rainAudio:setLooping(true)
    self.rainAudio:setVolume(0.5)
    self.rainAudio:play()
    
    Amphora.spawnAmphoras()
    Grass.spawnGrass()
    Checkpoint.spawnCheckpoints()
end

function Game:update(dt)
    
    if Console.isEnabled() then return end

    self.world:update(dt)
    self.player:update(dt)

    local cx, cy = self.camera:getPosition()
    local dx = self.player.x - cx
    local dy = self.player.y - cy
    self.camera:setPosition(cx + dx * dt * 10, cy + dy * dt * 10)

    RainDrop.generateRain(cx,cy, self.world)
    RainDrop.updateRain(dt)

    Checkpoint.updateAll(dt)

    self.lighter:updateLight(self.playerLight, self.player.x, self.player.y)

    -- This is for lights, should be at the end
    love.graphics.setCanvas({ Game.lightCanvas, stencil = true})
    love.graphics.clear(0.4, 0.4, 0.4) -- Global illumination level
    Game.lighter:drawLights()
    love.graphics.setCanvas()
end

function Game.drawGame(l, t, w, h)

    local wx, wy = Game.camera:toWorld(0, 0)
    love.graphics.draw(Game.background, wx, wy, 0, 1.2, 1.2)
    

    --love.graphics.draw(Game.background)

    for i,layer in ipairs(Game.map.layers) do
        if layer.objects == nil then
            Game.map:drawLayer(layer)
        end
    end

     -- draw rain before player
    RainDrop.drawRain()
    Amphora.drawAll()
    Grass.drawAll()
    Checkpoint.drawAll()
    Game.player:draw()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), Game.camera:toWorld(10, 10))
    love.graphics.print("Powerlevel: "..tostring(Game.player.fireStrength), Game.camera:toWorld(love.graphics.getWidth() /2, 10))
    love.graphics.print("Score: "..tostring(Game.player.score), Game.camera:toWorld(love.graphics.getWidth() -150, 10))

    -- Comment out for debugging
    -- Game:drawBox2dWorld()
    
    -- This is for lights, should be at the end
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(Game.lightCanvas)
    love.graphics.setBlendMode("alpha")
end
  

function Game:draw()
    self.camera:draw(Game.drawGame)
    Console:draw()
end

function Game.beginContact(a, b, collision)
    if Grass.beginContact(a, b, collision) then return end
    if RainDrop.beginContact(a, b, collision) then return end
    if Amphora.beginContact(a, b, collision) then return end
    if Checkpoint.beginContact(a, b, collision) then return end
    
    Game.player:beginContact(a, b, collision)
end

function Game.endContact(a, b, collision)
    Game.player:endContact(a, b, collision)
end

function Game:keypressed(key, scancode, isrepeat)
    Console.keypressed(key, scancode, isrepeat)
    if Console.isEnabled() then return end

    Game.player:keypressed(key)
    if key == "escape" then
        GameState.push(Pause)
    end
end

-- for debugging
function Game:drawBox2dWorld()
    for _, body in pairs(self.world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
    
            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("line", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end

--function love.textinput(text)
--    Console.textinput(text)
--end



return Game