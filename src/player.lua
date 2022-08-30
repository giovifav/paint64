local Player = Object:extend()

function Player:new(r,g,b)
    Player.super.new(r,g,b)
end

function Player:update(dt)
    dt = 1
    local k = love.keyboard.isDown
    if k("w") then
        self.y = self.y - dt
    elseif k("s") then
        self.y = self.y + dt
    elseif k("a") then
        self.x = self.x - dt
    elseif k("d") then
        self.x = self.x + dt
    end 
end


return Player
