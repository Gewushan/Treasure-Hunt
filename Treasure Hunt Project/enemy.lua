
local Enemy = {}
Enemy.__index = Enemy
local Player = require("player")
local Sound = require("sound")

local ActiveEnemy = {}

function Enemy.new(x,y)
   local instance = setmetatable({}, Enemy)
   instance.x = x
   instance.y = y
   instance.offSetY = -5
   
   instance.state = "walk"
   
   instance.speed = 50
   instance.xVel = instance.speed
   
   instance.damage = 1
   
   instance.animation = {timer = 0, rate = 0.1}
   instance.animation.walk = {total = 8, current = 1, img = Enemy.walk}
   instance.animation.draw = instance.animation.walk.img[1]

   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
   instance.physics.body:setFixedRotation(true)
   instance.physics.shape = love.physics.newRectangleShape(instance.width * 0.4, instance.height * 0.75)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   table.insert(ActiveEnemy, instance)
end

function Enemy.loadAssests()
  Enemy.walk = {}
  for i = 1,8 do
    Enemy.walk[i] = love.graphics.newImage("Characters/Enemies/Skeleton-Walk/skeleton-walk"..i..".png")
  end
  
  Enemy.width = Enemy.walk[1]:getWidth()
  Enemy.height = Enemy.walk[1]:getHeight()
  
  Sound:init("damage", "Audio/Hit damage 1.wav", "static")
end

function Enemy:update(dt)
   self:syncPhysics()
   self:animate(dt)
end

function Enemy:flipDirection()
  self.xVel = -self.xVel
end

function Enemy:animate(dt)
  self.animation.timer = self.animation.timer + dt
  if self.animation.timer > self.animation.rate then
    self.animation.timer = 0
    self:setNewFrame()
  end
end

function Enemy:setNewFrame()
  local anim = self.animation[self.state]
  if anim.current < anim.total then
    anim.current = anim.current + 1
  else
    anim.current = 1
  end
  self.animation.draw = anim.img[anim.current]
end

function Enemy:syncPhysics()
   self.x, self.y = self.physics.body:getPosition()
   self.physics.body:setLinearVelocity(self.xVel, 100)
end

function Enemy:draw()
  local scaleX = 1
  if self.xVel < 0 then
    scaleX = -1
  end
  love.graphics.draw(self.animation.draw, self.x, self.y + self.offSetY, self.r, scaleX, 1, self.width / 2, self.height / 2)
end

function Enemy.removeAll()
  for i,v in ipairs(ActiveEnemy) do
    v.physics.body:destroy()
  end
  
  ActiveEnemy = {}
end

function Enemy.updateAll(dt)
   for i,instance in ipairs(ActiveEnemy) do
      instance:update(dt)
   end
end

function Enemy.drawAll()
   for i,instance in ipairs(ActiveEnemy) do
      instance:draw()
   end
end

function Enemy.beginContact(a, b, collision)
  for i,instance in ipairs(ActiveEnemy) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == Player.physics.fixture or b == Player.physics.fixture then
        Sound:play("damage", "sfx", 2)
        Player:takeDamage(instance.damage)
      end
      
      instance:flipDirection()
    end
  end
end

return Enemy
