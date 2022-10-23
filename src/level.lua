
local Level = Class:extend()

function Level:new(imgFileName)
    self.filename = imgFileName
    local source = love.image.newImageData(self.filename)
    self.width, self.height = source:getWidth(), source:getHeight()
    self.levelTable = {}
    self.objects = {}
    --crea tabella temporanea che tiene tutti i pixel che non sono ancora stati assegnati ad un oggetto
    for x = 1, self.width do
        self.levelTable[x] = {}
        for y = 1, self.height do
            local r, g, b, a = source:getPixel(x - 1, y - 1)
            self.levelTable[x][y] = { r, g, b }
        end
    end
    self:addObjects()
    self.levelTable = nil
    --controlliamo se gli oggetti sono freccie
    for x, obj in ipairs(self.objects) do
        obj:consolidate()
        obj:checkArrow()

    end
    love.graphics.setBackgroundColor(0, 0, 0)
end
------------------------------------------------------------------------------------------------------
function Level:addObjects()
    local map = self.levelTable
    for x, v in ipairs(map) do
        for y, v1 in ipairs(v) do
            local m = map[x][y]
            if type(m) == "table" then
                if m[1] == 0 and m[2] == 1 and m[3] == 1 then -- azzurro 0,1,1
                    local obj = Player(unpack(m))
                    obj:flood8(x, y, map, self.width, self.height)
                    table.insert(self.objects, obj)
                elseif m[1] == 1 and m[2] == 1 and m[3] == 1 then -- bianco 1,1,1 -- WALL
                    local obj = Object(unpack(m))
                    obj.solid = true
                    obj.type = "wall"
                    obj:flood8(x, y, map, self.width, self.height)
                    table.insert(self.objects, obj)
                elseif m[1] == 1 and m[2] == 1 and m[3] == 0 then -- giallo 1,1,0 -- BARRIER 
                    local obj = Object(unpack(m))
                    obj.type = "barrier"
                    obj:flood8(x, y, map, self.width, self.height)
                    table.insert(self.objects, obj)
                elseif m[1] == 0 and m[2] == 1 and m[3] == 0 then -- verde 0,1,0 --GOAL 
                    local obj = Object(unpack(m))
                    obj.type = 'goal'
                    obj:flood8(x, y, map, self.width, self.height)
                    table.insert(self.objects, obj)
                elseif m[1] == 1 and m[2] == 0 and m[3] == 0 then -- rosso 1,0,0 -- ENEMY
                    local obj = Object(unpack(m))
                    obj.type = 'enemy'
                    obj:flood8(x, y, map, self.width, self.height)
                    table.insert(self.objects, obj)
                end
            end
        end
    end
end
------------------------------------------------------------------------------------------------------
function Level:draw()
    love.graphics.push()
    love.graphics.scale(10, 10)
    love.graphics.translate(-1, -1)
    love.graphics.setColor(1, 1, 1, 1)
    for x, obj in ipairs(self.objects) do
        obj:draw()
    end
    love.graphics.pop()
end
------------------------------------------------------------------------------------------------------
local accum = 0
local step = 0.05 -- fixed time step
function Level:update(dt)
    accum = accum + dt
    while accum >= step do
        for k, obj in ipairs(self.objects) do
            obj:update(dt)
        end
        self:checkCollision()
        for k, obj in ipairs(self.objects) do
            if obj.remove then
                table.remove(self.objects, k)
            end
        end
        accum = accum - step
    end

end
------------------------------------------------------------------------------------------------------
function Level:checkCollision()
    for _, obj1 in pairs(self.objects) do
        for __, obj2 in pairs(self.objects) do
            if obj1 ~= obj2 then
                if self:objCollide(obj1, obj2) then
                    print("collision")
                    self:resolveCollision(obj1, obj2)
                end
            end
        end
    end
end
------------------------------------------------------------------------------------------------------
function Level:resolveCollision(obj1, obj2)
    if obj1.type == 'player' and obj2.type == 'wall' then --to fix 
        obj1.x = obj1.oX
        obj1.y = obj1.oY
    elseif obj1.type == 'wall' and obj2.type == 'player' then--FIXME
        obj2.x = obj2.oX
        obj2.y = obj2.oY
    elseif obj1.type == 'player' and obj2.type == 'barrier' then
        obj2.remove = true
    elseif obj1.type == 'barrier' and obj2.type == 'player' then
        obj1.remove = true
    elseif obj1.type == 'goal' and obj2.type == 'player' then
        obj1.remove = true
    elseif obj1.type == 'player' and obj2.type == 'goal' then
        obj2.remove = true
    elseif obj1.type == 'player' and obj2.type == 'enemy' then
        self.restart = true
    elseif obj1.type == 'enemy' and obj2.type == 'player' then
        self.restart = true
    end
end
------------------------------------------------------------------------------------------------------
function Level:objCollide(obj1, obj2)
    for index1, pixel1 in pairs(obj1.pixels) do
        for index2, pixel2 in pairs(obj2.pixels) do
            if pixel1[1] + obj1.x == pixel2[1] + obj2.x and
                pixel1[2] + obj1.y == pixel2[2] + obj2.y then
                return true
            end
        end
    end
    return false
end
------------------------------------------------------------------------------------------------------
return Level
