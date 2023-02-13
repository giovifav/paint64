local Player = Object:extend()

function Player:new(r, g, b)
    Player.super.new(self, r, g, b)
    print("sono il player")
    self.solid = true --collidable
    self.type = 'player'
end

function Player:move(x, y)
    self.x = self.x + x
    self.y = self.y + y
end


function Player:update()
    self.oX = self.x 
    self.oY = self.y
    
end

return Player
