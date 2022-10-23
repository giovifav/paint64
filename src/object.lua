local Object = Class:extend()
------------------------------------------------------------------------------------------------------
function Object:new(r, g, b)
  self.type   = "basicObject"
  self.r      = r or 1
  self.g      = g or 1
  self.b      = b or 1
  self.pixels = {}
  self.remove = false
  self.solid  = true

  if r == 0 and g == 0 and b == 0 then
    self.stationary = true
  else
    self.stationary = false
  end
end





------------------------------------------------------------------------------------------------------
function Object:addPixel(x, y)
  table.insert(self.pixels, { x, y })
end

------------------------------------------------------------------------------------------------------
function Object:draw()
  love.graphics.setColor(self.r, self.g, self.b)

    for k, v in pairs(self.pixels) do
      local x, y = self.x + v[1], self.y + v[2] 
      --local x, y = v[1], v[2]
      love.graphics.rectangle("fill",x, y, 1, 1)
    end

end

------------------------------------------------------------------------------------------------------
function Object:update(dt)

end

------------------------------------------------------------------------------------------------------
function Object:flood8(x, y, map, width, height)

  if x <= width and x >= 1 and y <= height and y >= 1 then
    if type(map[x][y]) == "table" then
      if map[x][y][1] == self.r and map[x][y][2] == self.g and map[x][y][3] == self.b then
        self:addPixel(x, y)
        map[x][y] = "empty"
        self:flood8(x + 1, y, map, width, height)
        self:flood8(x - 1, y, map, width, height)
        self:flood8(x, y + 1, map, width, height)
        self:flood8(x, y - 1, map, width, height)
        self:flood8(x + 1, y + 1, map, width, height)
        self:flood8(x + 1, y - 1, map, width, height)
        self:flood8(x - 1, y + 1, map, width, height)
        self:flood8(x - 1, y - 1, map, width, height)
      end
    end
  end
end

------------------------------------------------------------------------------------------------------
function Object:consolidate()

  local minX, minY, maxX, maxY = nil, nil, nil, nil
  for k, v in ipairs(self.pixels) do
    if minX == nil then minX = v[1] end
    if maxX == nil then maxX = v[1] end
    if minY == nil then minY = v[2] end
    if maxY == nil then maxY = v[2] end

    if v[1] <= minX then minX = v[1] end
    if v[1] >= maxX then maxX = v[1] end
    if v[2] <= minY then minY = v[2] end
    if v[2] >= maxY then maxY = v[2] end

  end

  self.width = maxX - minX + 1
  self.height = maxY - minY + 1

  self.x, self.y = minX, minY

  local t = {}
  for key, v in pairs(self.pixels) do
    --inseriamo le posizioni relative a x e y dell'oggetto
    table.insert(t, { v[1] - self.x , v[2] - self.y })
  end
  self.pixels = t
 

end

------------------------------------------------------------------------------------------------------
function Object:isPixel(x, y)
  for k, v in pairs(self.pixels) do
    if v[1] == x and v[2] == y then
      return true
    end
  end
end

------------------------------------------------------------------------------------------------------





function Object:leftArrow()
  -- creiamo una tabella temporanea
  local t = {}
  for key, v in pairs(self.pixels) do
    --inseriamo le posizioni relative a x e y dell'oggetto
    table.insert(t, {v[1], v[2]})
  end
  for k, v in pairs(t) do
    --eliminiamo la punta sinistra della freccia
    if v[1] == 1 and v[2] == self.width then
      t[k] = nil
    end
  end
  -- eliminiamo il resto dei pixels nella freccia
  for x = 2, self.width do
    for k, v in pairs(t) do
      if v[1] == x and v[2] == self.width - (x - 1) then
        t[k] = nil
      elseif v[1] == x and v[2] == self.width + (x - 1) then
        t[k] = nil
      end
    end
  end
  --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia sinistra
  if table.count(t) == 0 then
    t = nil
    return true
  else
    t = nil
    return false
  end
end

------------------------------------------------------------------------------------------------------

function Object:upArrow()
  -- creiamo una tabella temporanea
  local t = {}
  for key, v in pairs(self.pixels) do
    --inseriamo le posizioni relative a x e y dell'oggetto
    table.insert(t, v)
  end
  for k, v in pairs(t) do
    --eliminiamo la punta superiore della freccia
    if v[1] == self.height and v[2] == 1 then
      t[k] = nil
    end
  end
  -- eliminiamo il resto dei pixels nella freccia
  for y = 2, self.height do
    for k, v in pairs(t) do
      if v[1] == self.height - (y - 1) and v[2] == y then
        t[k] = nil
      elseif v[1] == self.height + (y - 1) and v[2] == y then
        t[k] = nil
      end
    end
  end
  --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia su
  if table.count(t) == 0 then
    t = nil
    return true
  else
    t = nil
    return false
  end
end

------------------------------------------------------------------------------------------------------
function Object:downArrow()
  -- creiamo una tabella temporanea
  local t = {}
  for key, v in pairs(self.pixels) do
    --inseriamo le posizioni relative a x e y dell'oggetto
    table.insert(t, v)
  end
  for k, v in pairs(t) do
    --eliminiamo la punta inferiore della freccia
    if v[1] == self.height and v[2] == self.height then
      t[k] = nil
    end
  end
  -- eliminiamo il resto dei pixels nella freccia
  for y = 1, self.height - 1 do
    for k, v in pairs(t) do
      if v[1] == y and v[2] == y then
        t[k] = nil
      elseif v[1] == (self.height * 2) - y and v[2] == y then
        t[k] = nil
      end
    end
  end
  --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia giu
  if table.count(t) == 0 then
    t = nil
    return true
  else
    t = nil
    return false
  end
end

------------------------------------------------------------------------------------------------------
function Object:rightArrow()
  -- creiamo una tabella temporanea
  local t = {}
  for key, v in pairs(self.pixels) do
    --inseriamo le posizioni relative a x e y dell'oggetto
    table.insert(t, v)
  end
  for k, v in pairs(t) do
    --eliminiamo la punta destra della freccia
    if v[1] == self.width and v[2] == self.width then
      t[k] = nil
    end
  end
  -- eliminiamo il resto dei pixels nella freccia
  for x = 1, self.width - 1 do
    for k, v in pairs(t) do
      if v[1] == x and v[2] == x then
        t[k] = nil
      elseif v[1] == x and v[2] == (self.width * 2) - x then
        t[k] = nil
      end
    end
  end
  --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia destra
  if table.count(t) == 0 then
    t = nil
    return true
  else
    t = nil
    return false
  end
end

------------------------------------------------------------------------------------------------------
function Object:topLeftArrow()
  -- se l'oggetto è quadrato
  if self.width == self.height then
    -- creiamo una tabella temporanea
    local t = {}
    for key, v in pairs(self.pixels) do
      --inseriamo le posizioni relative a x e y dell'oggetto
      table.insert(t, v)
    end

    -- eliminiamo i pixel orizzontali
    for x = 1, self.width do
      for k, v in pairs(t) do
        if v[1] == x and v[2] == 1 then
          t[k] = nil
        end
      end
    end
    -- eliminiamo i pixel verticali
    for y = 2, self.height do
      for k, v in pairs(t) do
        if v[1] == 1 and v[2] == y then
          t[k] = nil
        end
      end
    end
    --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia in alto a sinistra
    if table.count(t) == 0 then
      t = nil
      return true
    else
      t = nil
      return false
    end
  end
end

------------------------------------------------------------------------------------------------------
function Object:topRightArrow()
  -- se l'oggetto è quadrato
  if self.width == self.height then
    -- creiamo una tabella temporanea
    local t = {}
    for key, v in pairs(self.pixels) do
      --inseriamo le posizioni relative a x e y dell'oggetto
      table.insert(t, v)
    end
    -- eliminiamo i pixel orizzonatali
    for x = 1, self.width do
      for k, v in pairs(t) do
        if v[1] == x and v[2] == 1 then
          t[k] = nil
        end
      end
    end
    -- eliminiamo i pixel verticali
    for y = 2, self.height do
      for k, v in pairs(t) do
        if v[1] == self.width and v[2] == y then
          t[k] = nil
        end
      end
    end
    --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia in alto a destra
    if table.count(t) == 0 then
      t = nil
      return true
    else
      t = nil
      return false
    end
  end
end

------------------------------------------------------------------------------------------------------
function Object:bottomRightArrow()
  -- se l'oggetto è quadrato
  if self.width == self.height then
    -- creiamo una tabella temporanea
    local t = {}
    for key, v in pairs(self.pixels) do
      --inseriamo le posizioni relative a x e y dell'oggetto
      table.insert(t, v)
    end

    -- eliminiamo i pixel orizzonatali
    for x = 1, self.width do
      for k, v in pairs(t) do
        if v[1] == x and v[2] == self.height then
          t[k] = nil
        end
      end
    end
    -- eliminiamo i pixel verticali
    for y = 1, self.height - 1 do
      for k, v in pairs(t) do
        if v[1] == self.width and v[2] == y then
          t[k] = nil
        end
      end
    end
    --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia in basso a destra
    if table.count(t) == 0 then
      t = nil
      return true
    else
      t = nil
      return false
    end
  end
end

------------------------------------------------------------------------------------------------------
function Object:bottomLeftArrow()
  -- se l'oggetto è quadrato
  if self.width == self.height then
    -- creiamo una tabella temporanea
    local t = {}
    for key, v in pairs(self.pixels) do
      --inseriamo le posizioni relative a x e y dell'oggetto
      table.insert(t, v)
    end

    -- eliminiamo i pixel orizzonatali
    for x = 1, self.width do
      for k, v in pairs(t) do
        if v[1] == x and v[2] == self.height then
          t[k] = nil
        end
      end
    end
    -- eliminiamo i pixel verticali
    for y = 1, self.height - 1 do
      for k, v in pairs(t) do
        if v[1] == 1 and v[2] == y then
          t[k] = nil
        end
      end
    end
    --se la nostra tabella temporanea è vuota vuol dire che l'oggetto è una freccia in basso a sinistra
    if table.count(t) == 0 then
      t = nil
      return true
    else
      t = nil
      return false
    end
  end
end

------------------------------------------------------------------------------------------------------
function Object:checkArrow()
  if self.width > 1 and self.height > 1 then
    if self:leftArrow() then
      self.direction = "left"
    elseif self:rightArrow() then
      self.direction = "right"
    elseif self:upArrow() then
      self.direction = "up"
    elseif self:downArrow() then
      self.direction = "down"
    elseif self:topLeftArrow() then
      self.direction = "topLeft"
    elseif self:topRightArrow() then
      self.direction = "topright"
    elseif self:bottomLeftArrow() then
      self.direction = "bottomLeft"
    elseif self:bottomRightArrow() then
      self.direction = "bottomRight"
    else -- se non è freccia l'oggetto è fermo
      self.direction = "none"
      if not self.player then
        self.stationary = true
      end
    end
    print(self.direction)
  else
    self.direction = "none"
    self.stationary = true
  end
end

------------------------------------------------------------------------------------------------------
return Object
