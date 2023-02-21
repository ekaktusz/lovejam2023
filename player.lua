local Player = Object:extend()

local anim8 = require("vendor.anim8.anim8")

function Player:new(world)
    self.x = 100
    self.y = 0
    self.dx = 0
    self.dy = 0
    self.width = 64
    self.height = 64

    self.acceleration = 4000
    self.friction = 3500
    self.maxSpeed = 200
    self.gravity = 1500
    self.jumpSpeed = -500

    self.coyoteTimer = 0
    self.coyoteDuration = 0.1

    self.grounded = false
    self.hasDoubleJump = true
    self.doubleJumpModifier = 0.8

    self.fireStrength = 0.5 -- value between 0 and 1, showing the strength of fire

    -- init physics
    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
   

    -- init animations
    self.animations = {}

    self.animations.idle = {}
    self.animations.idle.texture = love.graphics.newImage("assets/textures/characters/idle.png")
    self.animations.idle.grid = anim8.newGrid(64,64, self.animations.idle.texture:getWidth(), self.animations.idle.texture:getHeight())
    self.animations.idle.animation = anim8.newAnimation(self.animations.idle.grid("1-8", 1), 0.1)

    self.animations.running = {}
    self.animations.running.texture = love.graphics.newImage("assets/textures/characters/running.png")
    self.animations.running.grid = anim8.newGrid(64,64, self.animations.running.texture:getWidth(), self.animations.running.texture:getHeight())
    self.animations.running.animation = anim8.newAnimation(self.animations.running.grid("5-19", 1), 0.075)

    self.currentAnimation = self.animations.idle
end

function Player:draw()
    --love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    self.currentAnimation.animation:draw(self.currentAnimation.texture, self.x - self.width / 2, self.y - self.height / 2, 0, 1, 1)
end

function Player:update(dt)
    self.currentAnimation.animation:update(dt)
    self:decreaseCoyoteTimer(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:updateAnimationState()
end

function Player:updateAnimationState()
    if self.dx ~= 0 then
        self.currentAnimation = self.animations.running
    else
        self.currentAnimation = self.animations.idle
    end
end

function Player:decreaseCoyoteTimer(dt)
    if not self.grounded then
        self.coyoteTimer = self.coyoteTimer - dt
    end
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.dy = self.dy + self.gravity * dt
    end
end

function Player:beginContact(a, b, collision)
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.dy = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.dy = 0
        end
    end
end

function Player:land(collision)
    self.currentGroundedCollision = collision
    self.dy = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.coyoteTimer = self.coyoteDuration
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundedCollision == collision then
            self.grounded = false
        end
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        self.dx = math.min(self.dx + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") then
        self.dx = math.max(self.dx - self.acceleration * dt, -self.maxSpeed)
    else
        self:applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if self.dx > 0 then
        self.dx = math.max(self.dx - self.friction * dt, 0)
    elseif self.dx < 0 then
        self.dx = math.min(self.dx + self.friction * dt, 0)
    end
end

function Player:keypressed(key)
    if key == "w" or key == "up" then
        self:jump()
    end
end

function Player:jump()
    if self.grounded or self.coyoteTimer > 0 then
        self.dy = self.jumpSpeed
        self.grounded = false
        self.coyoteTimer = 0
    elseif self.hasDoubleJump then
        self.hasDoubleJump = false
        self.dy = self.jumpSpeed * self.doubleJumpModifier
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.dx, self.dy)
end

return Player