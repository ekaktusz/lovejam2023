local Amphora = Object:extend()

local activeAmphoras = {}

function Amphora:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.width = 64
    self.height = 64
    self.sprite = love.graphics.newImage("assets/imgs/tiles/tile (120).png")

    self.physics = {}
    self.physics.body = love.physics.newBody(Game.world, self.x, self.y, "static")
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.fixture:setSensor(true)
end

function Amphora:draw()
    love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2)
end

function Amphora.drawAll()
    for i,amphora in ipairs(activeAmphoras) do
        amphora:draw()
    end
end

function Amphora.spawnAmphoras()
    for i,a in ipairs(Game.map.layers.amphoras.objects) do
		local amphora = Amphora(a.x, a.y)
        table.insert(activeAmphoras, amphora)
	end
end

function Amphora.beginContact(a, b, collision)
    for i,amphora in ipairs(activeAmphoras) do
        if (a == amphora.physics.fixture and b == Game.player.physics.fixture) or (b == amphora.physics.fixture and a == Game.player.physics.fixture) then
            amphora.physics.body:destroy()
            table.remove(activeAmphoras, i)
            Game.player.score = Game.player.score + 1
            return true
        end
    end
end

return Amphora