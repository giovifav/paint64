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
    --controlliamo se gli oggetti sono freccie
    for x, obj in ipairs(self.objects) do
        obj:consolidate()
        obj:checkArrow()

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
local step = 0.1 -- fixed time step
function Level:update(dt)
     
    for _, obj in pairs(self.objects) do
        if obj.type == "player" then
            local x, y = input:get("move")
                if x ~= 0 or y ~= 0 then
                result, obj2 = self:objCollideAt(obj, obj.x + x, obj.y + y)
                if not result then
                    obj:move(x,y)
                end
            end
        end
    end



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
    for _, obj in pairs(self.objects) do
        if obj.motion then
            result, obj2 = self:objCollideAt(obj, obj.x + obj.direction[1], obj.y + obj.direction[2])
            if result then
                obj:onCollision(obj2)
            end
        end
    end


    for _, obj1 in pairs(self.objects) do
        for __, obj2 in pairs(self.objects) do
            if obj1 ~= obj2 then
                if self:objCollide(obj1, obj2) then

                        self:resolveCollision(obj1, obj2)
                    
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
function Level:resolveCollision(obj1, obj2)
    
    if obj1.type == 'player' and obj2.type == 'barrier' then
        obj2.remove = true
    elseif obj1.type == 'barrier' and obj2.type == 'player' then
        obj1.remove = true
    elseif obj1.type == 'goal' and obj2.type == 'player' then
        obj1.remove = true
    elseif obj1.type == 'player' and obj2.type == 'goal' then
        obj2.remove = true
    elseif obj1.type == 'player' and obj2.type == 'enemy' then
        self:new(self.filename)
    elseif obj1.type == 'enemy' and obj2.type == 'player' then
        self:new(self.filename)
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

function Level:objCollideAt(obj1, x, y)
    for _, obj2 in pairs(self.objects) do
        for index1, pixel1 in pairs(obj1.pixels) do
            for index2, pixel2 in pairs(obj2.pixels) do
                if pixel1[1] + x == pixel2[1] + obj2.x and
                    pixel1[2] + y == pixel2[2] + obj2.y then
                    return true, obj2
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
return Level
