love.graphics.setDefaultFilter("nearest", "nearest")


local Player = require("player")
local Gems = require("gems")
local GUI = require("gui")
local Camera = require("camera")
local Enemy = require("enemy")
local Map = require("map")
local Sound = require("sound")



function love.load()
  Enemy.loadAssests()
  Gems.loadAssests()
  Map:load()
  background = love.graphics.newImage("Environment/Background.png")
  Sound:init("track", "Audio/dark-happy-world.ogg", "stream")
  Sound:play("track", "music", 0.3, true)
  Player:load()
  GUI:load()
end

function love.update(dt)
  World:update(dt)
  Player:update(dt)
  Gems.updateAll(dt)
  Enemy.updateAll(dt)
  GUI:update(dt)
  Camera:setPosition(Player.x, 0)
  Map:update(dt)
  Sound:update()
end

function love.draw()
  
  love.graphics.draw(background)
  Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
  
  
  Camera:apply()
  Player:draw()
  Gems.drawAll()
  Enemy.drawAll()
  Camera:clear()
  
  GUI:draw()
  
end

function love.keypressed(key)
  Player:jump(key)
end

function beginContact(a, b, collision)
  if Gems.beginContact(a, b, collision) then return end
  Enemy.beginContact(a, b, collision)
  Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
  Player:endContact(a, b, collision)
end

