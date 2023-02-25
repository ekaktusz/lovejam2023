local Grass = Object:extend()

local anim8 = require("vendor.anim8.anim8")

local activeGrass = {}
local activeBurningGrass = {}

local burningTexture = love.graphics.newImage("assets/textures/zold_fucsomo_1.png")
local burningGrid = anim8.newGrid(32,32, burningTexture:getWidth(), burningTexture:getHeight())

function Grass:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.width = 64
    self.height = 64

    self.sprite = love.graphics.newImage("assets/imgs/tiles/tile (71).png") -- todo

    self.physics = {}
    self.physics.body = love.physics.newBody(Game.world, self.x, self.y, "static")
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.fixture:setSensor(true)
end

function Grass:draw()
    love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2)
end

function Grass.drawAll()
    for i,grass in ipairs(activeGrass) do
        grass:draw()
    end

    for i,burn in ipairs(activeBurningGrass) do
        burn.animation:draw(burningTexture, burn.x, burn.y, 0, 1, 1)
    end
end

function Grass.updateAll(dt)
    for i,burn in ipairs(activeBurningGrass) do
        burn.animation:update(dt)
    end
end

function Grass.spawnGrass()
    for i,a in ipairs(Game.map.layers.grass.objects) do
		local amphora = Grass(a.x, a.y)
        table.insert(activeGrass, amphora)
	end
end

function Grass.beginContact(a, b, collision)
    for i,grass in ipairs(activeGrass) do
        if (a == grass.physics.fixture and b == Game.player.physics.fixture) or (b == grass.physics.fixture and a == Game.player.physics.fixture) then
            grass.physics.body:destroy()
            grass:spawnBurningGrass()
            Game.player.fireStrength = Game.player.fireStrength + 0.1
            table.remove(activeGrass, i)
            return true
        end
    end
end

function Grass:spawnBurningGrass()
    local burn = {}
    burn.animation = anim8.newAnimation(burningGrid("1-11", 1), 0.1, 'pauseAtEnd')
    burn.x = self.x 
    burn.y = self.y
    table.insert(activeBurningGrass, burn)
end


return Grass