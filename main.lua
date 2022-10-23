--globali
Class =  require("libs.classic")
require("libs.table")
Level = require("src.level")
Object = require("src.object")
Player = require("src.player")
local level
Pprint = require("libs.pprint")
C = {
    debug= true,
}
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
