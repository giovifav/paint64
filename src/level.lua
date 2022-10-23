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
    --creiamo canvas oggetti fermi
    self.background = love.graphics.newCanvas(self.width+1, self.height+1)-- ????????? piu uno perche l'unita di misura del canvas parte da zero
    love.graphics.setCanvas(self.background)
    for x, obj in ipairs(self.objects) do
        if obj.stationary then
            obj:draw()
        end
    end
    love.graphics.setCanvas()
end
------------------------------------------------------------------------------------------------------
function Level:addObjects()
    local map = self.levelTable
    for x, v in ipairs(map) do
        for y, v1 in ipairs(v) do
            
            local m = map[x][y]
            if type(m) == "table" then
                local obj
                if m[1] == 0 and m[2] == 1 and m[3] == 1 then
                    obj = Player(unpack(m)) 
                else
                    obj = Object(unpack(m))
                end
                obj:flood8(x, y, map, self.width, self.height)
                table.insert(self.objects, obj)
            end
        end
    end
end
------------------------------------------------------------------------------------------------------
function Level:draw()
    love.graphics.scale(10,10)
    love.graphics.translate(-1,-1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.background)
    for x, obj in ipairs(self.objects) do
        if not obj.stationary then
            obj:draw()
        end
    end
end
------------------------------------------------------------------------------------------------------
function Level:update(dt)
    
    for x, obj in ipairs(self.objects) do
        
            obj:update(dt)
        
    end
end
------------------------------------------------------------------------------------------------------

function Level:checkCollision()
    for k, obj1 in pairs(self.objects) do
        for k2, obj2 in pairs(self.objects) do
            if k ~= k2 then
                print(tostring(self:objCollide(obj1, obj2)))
            end
        end
    end
end



function Level:objCollide(obj1, obj2)
    for index1, pixel1 in pairs(obj1.pixels) do
        for index2, pixel2 in pairs(obj2.pixels) do
            if pixel1[1] == pixel2[1] and   pixel1[2] == pixel2[2]  then
                return true
            end       
        end
    end

end

------------------------------------------------------------------------------------------------------
return Level
