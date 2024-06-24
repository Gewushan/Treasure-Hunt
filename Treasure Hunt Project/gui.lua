
local GUI ={}
local Player = require ("player")

function GUI:load()
  self.gems = {}
  self.gems.img = love.graphics.newImage("Environment/gem/1.png")
  self.gems.width = self.gems.img:getWidth()
  self.gems.height = self.gems.img:getHeight()
  self.gems.scale = 3
  self.gems.x = love.graphics.getWidth() - 200
  self.gems.y = 50
  
  self.hearts = {}
  self.hearts.img = love.graphics.newImage("Environment/heart.png")
  self.hearts.width = self.hearts.img:getWidth()
  self.hearts.height = self.hearts.img:getHeight()
  self.hearts.x = 0
  self.hearts.y = 50
  self.hearts.scale = 3
  self.hearts.spacing = self.hearts.width * self.hearts.scale + 30
  
  self.font = love.graphics.newFont("upheavtt.ttf", 36)
end

function GUI:update(dt)
  
end

function GUI:draw()
  self:displayGems()
  self:displayText()
  self:displayHearts()
end

function GUI:displayGems()
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.draw(self.gems.img, self.gems.x + 2, self.gems.y + 2, 0, self.gems.scale, self.gems.scale)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.gems.img, self.gems.x, self.gems.y, 0, self.gems.scale, self.gems.scale)
end

function GUI:displayHearts()
  for i = 1, Player.health.current do
    local x = self.hearts.x + self.hearts.spacing * i
    love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
  end
end

function GUI:displayText()
  love.graphics.setFont(self.font)
  local x = self.gems.x + self.gems.width * self.gems.scale
  local y = self.gems.y + self.gems.height / 2 * self.gems.scale - self.font:getHeight() / 2
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.print(" : "..Player.gems, x + 2, y + 2)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(" : "..Player.gems, x, y)
end

return GUI