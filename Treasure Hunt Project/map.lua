

local Map = {}
local STI = require("sti")
local Enemy = require("enemy")
local Gems = require("gems")
local Player = require("player")

function Map:load()
  self.currentLevel = 1
  
  World = love.physics.newWorld(0, 0)
  World:setCallbacks(beginContact, endContact)
  
  self:init()
end

function Map:init()
  self.level = STI("Maps/map"..self.currentLevel..".lua", {"box2d"})
  
  self.level:box2d_init(World)
  
  self.solidLayer = self.level.layers.solid
  self.entityLayer = self.level.layers.entity
  self.groundLayer = self.level.layers.ground
  
  self.solidLayer.visible = false
  self.entityLayer.visible = false
  mapWidth = self.groundLayer.width * 16
  
  self:spawnEntities()
end

function Map:next()
  self:clean()
  self.currentLevel = self.currentLevel + 1
  self:init()
  Player:resetPosition()
end

function Map:update()
  if Player.x > mapWidth - 16 then
    self:next()
  end
end

function Map:clean()
  self.level:box2d_removeLayer("solid")
  Enemy.removeAll()
  Gems.removeAll()
end

function Map:spawnEntities()
  for i,v in ipairs(self.entityLayer.objects) do
    if v.type == "gem" then
      Gems.new(v.x + v.width / 2, v.y + v.height / 2)
    elseif v.type == "enemy" then
      Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
    end
  end
end

return Map