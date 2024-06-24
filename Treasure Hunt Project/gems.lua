
local Gems = {}
Gems.__index = Gems
local ActiveGems = {}
local Player = require ("player")
local Sound = require("sound")

function Gems.new(x,y)
  local instance = setmetatable({}, Gems)
  instance.x = x
  instance.y = y
  
  instance.state = "spin"
  
  instance.animation = {timer = 0, rate = 0.1}
  instance.animation.spin = {total = 5, current = 1, img = Gems.spin}
  instance.animation.draw = instance.animation.spin.img[1]
  
  instance.toBeRemoved = false
  
  instance.physics = {}
  instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
  instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
  instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
  instance.physics.fixture:setSensor(true)
  
  table.insert(ActiveGems, instance)
end

function Gems.loadAssests()
  Gems.spin = {}
  for i = 1,5 do
    Gems.spin[i] = love.graphics.newImage("Environment/gem/"..i..".png")
  end
  
  Gems.width = Gems.spin[1]:getWidth()
  Gems.height = Gems.spin[1]:getHeight()
  
  Sound:init("collect", "Audio/Fruit collect 1.wav", "static")
end

function Gems:update(dt)
  self:checkRemove()
  self:animate(dt)
end

function Gems:animate(dt)
  self.animation.timer = self.animation.timer + dt
  if self.animation.timer > self.animation.rate then
    self.animation.timer = 0
    self:setNewFrame()
  end
end

function Gems:setNewFrame()
  local anim = self.animation[self.state]
  if anim.current < anim.total then
    anim.current = anim.current + 1
  else
    anim.current = 1
  end
  self.animation.draw = anim.img[anim.current]
end

function Gems:remove()
  for i,instance in ipairs(ActiveGems) do
    if instance == self then
      Player:incrementGems()
      self.physics.body:destroy()
      table.remove(ActiveGems, i)
    end
  end
end

function Gems:checkRemove()
  if self.toBeRemoved then
    self:remove()
  end
end

function Gems.removeAll()
  for i,v in ipairs(ActiveGems) do
    v.physics.body:destroy()
  end
  
  ActiveGems = {}
end

function Gems:draw()
  love.graphics.draw(self.animation.draw, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Gems.updateAll(dt)
  for i,instance in ipairs(ActiveGems) do
    instance:update(dt)
  end
end

function Gems.drawAll()
  for i,instance in ipairs(ActiveGems) do
    instance:draw()
  end
end

function Gems.beginContact(a, b, collision)
  for i,instance in ipairs(ActiveGems) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == Player.physics.fixture or b == Player.physics.fixture then
        Sound:play("collect", "sfx", 2)
        instance.toBeRemoved = true
        return true
      end
    end
  end
end

return Gems