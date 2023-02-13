--globali
require("libs.table")
require('libs.utils')
input = require('libs.baton').new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    action = {'key:x', 'button:a'},
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

Class =  require("libs.classic")
Object = require("src.object")
Player = require("src.player")
Level = require("src.level")
local level

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    level = Level("Carts/race.png")
end

function love.update(dt)
    input:update()
    level:update(dt)
end

function love.draw()
    level:draw()
end
