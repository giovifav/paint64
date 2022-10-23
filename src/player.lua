local Player = Object:extend()

function Player:new(r,g,b)
    Player.super.new(self,r,g,b)
    print("sono il player")
end

function Player:update()
    local k = love.keyboard.isDown
    if k("w") then
        self.y = self.y - 1
    elseif k("s") then
        self.y = self.y + 1
    elseif k("a") then
        self.x = self.x - 1
    elseif k("d") then
        self.x = self.x + 1
    end 
end


return Player
