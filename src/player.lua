local Player = Object:extend()

function Player:new(r, g, b)
    Player.super.new(self, r, g, b)
    print("sono il player")
    self.solid = true --collidable
    self.type = 'player'
end

function Player:update()
    self.oX = self.x 
    self.oY = self.y
    
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
