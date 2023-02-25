local Checkpoint = Object:extend()
local activeCheckpoints = {}

local anim8 = require("vendor.anim8.anim8")



function Checkpoint:new(x, y)
    self.x = x or 0
    self.y = y or 0

    self.width = 64
    self.height = 64

    self.checked = false
    self.state = "lit"

    self.physics = {}
    self.physics.body = love.physics.newBody(Game.world, self.x, self.y, "static")
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.fixture:setSensor(true)

    self.sprite = love.graphics.newImage("assets/imgs/tiles/tile (167).png")

    self.animations = {}
    self.animations.lit = {}
    self.animations.lit.texture = love.graphics.newImage("assets/textures/checkpoint_lit.png")
    self.animations.lit.grid = anim8.newGrid(64,64, self.animations.lit.texture:getWidth(), self.animations.lit.texture:getHeight())
    self.animations.lit.animation = anim8.newAnimation(self.animations.lit.grid("1-14", 1), 0.1)

    self.animations.idle = {}
    self.animations.idle.texture = love.graphics.newImage("assets/textures/checkpoint_idle.png")
    self.animations.idle.grid = anim8.newGrid(64,64, self.animations.idle.texture:getWidth(), self.animations.idle.texture:getHeight())
    self.animations.idle.animation = anim8.newAnimation(self.animations.idle.grid("1-14", 1), 0.1)

    self.whooshAudio = love.audio.newSource("assets/audio/fire/whoosh-2.wav", "stream")

    self.currentAnimation = self.animations.lit
end

function Checkpoint:draw()
    if not self.checked then
        love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2)
    else
        self.currentAnimation.animation:draw(self.currentAnimation.texture, self.x - self.width / 2, self.y - self.height / 2, 0, 1, 1)
    end
end

function Checkpoint:update(dt)
    if not self.checked then return end

    if self.currentAnimation.animation:isOnEnd() and self.state == "lit" then
        self.currentAnimation = self.animations.idle
        self.state = "burning"
    end

    self.currentAnimation.animation:update(dt)
end

function Checkpoint.updateAll(dt)
    for i,checkpoint in ipairs(activeCheckpoints) do
        checkpoint:update(dt)
    end
end

function Checkpoint.drawAll()
    for i,checkpoint in ipairs(activeCheckpoints) do
        checkpoint:draw()
    end
end

function Checkpoint.spawnCheckpoints()
    for i,a in ipairs(Game.map.layers.checkpoints.objects) do
		local checkpoint = Checkpoint(a.x, a.y)
        table.insert(activeCheckpoints, checkpoint)
	end
end

function Checkpoint.beginContact(a, b, collision)
    for i,checkpoint in ipairs(activeCheckpoints) do
        if (a == checkpoint.physics.fixture and b == Game.player.physics.fixture) or (b == checkpoint.physics.fixture and a == Game.player.physics.fixture) then
            checkpoint.physics.body:destroy()
            checkpoint.checked = true
            Game.player.lastCheckpoint = {x=checkpoint.x, y=checkpoint.y}
            checkpoint.whooshAudio:play()
            return true
        end
    end
end

return Checkpoint