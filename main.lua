--globali
require("libs.table")
require('libs.utils')
Class =  require("libs.classic")
Object = require("src.object")
Player = require("src.player")
Level = require("src.level")
local level


function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    level = Level("dungeon.png")
end

function love.update(dt)
    level:update(dt)
end

function love.draw()
    level:draw()
end
