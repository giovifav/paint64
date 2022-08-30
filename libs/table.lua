local _cache = {}
local _table = {}

--- Checks if the table is empty
-- @param t Table
-- @return True if empty or false otherwise
function _table.empty(t)
  return next(t) == nil
end

--- Removes all values
-- @param t Table
function _table.clear(t)
  for i in pairs(t) do
    t[i] = nil
  end
end

--- Counts the number of elements
-- @param t Table
-- @return Total number of elements
function _table.count(t)
  local n = 0
  for _ in pairs(t) do
    n = n + 1
  end
  return n
end

--- Counts the number of unique elements
--- The number of duplicate elements can be calculated
--- by subtracting the first return value from the second
-- @param t Table
-- @return Number of unique values
-- @return Total number of elements
function _table.ucount(t)
  -- clear the cache
  _table.clear(_cache)
  local n = 0
  local d = 0
  for _, v in pairs(t) do
    if _cache[v] then
      d = d + 1
    else
      _cache[v] = true
    end
    n = n + 1
  end
  return n - d, n
end

--- Counts the number of occurrences of a given value
-- @param t Table
-- @param v Value
-- @return Number of occurrences
-- @return Total number of elements
function _table.vcount(t, s)
  assert(s ~= nil, "second argument cannot be nil")
  local n = 0
  local d = 0
  for _, v in pairs(t) do
    if v == s then
      d = d + 1
    end
    n = n + 1
  end
  return d, n
end

--- Reverses the elements in a list
-- @param t Table
-- @param r Destination table (optional)
-- @return Reversed table
function _table.reverse(t, r)
  r = r or t
  local n = #t
  if t == r then
    -- reverse in place
    for i = 1, n/2 do
      local i2 = n - i + 1
      r[i], r[i2] = r[i2], r[i]
    end
  else
    -- reverse copy
    for i = 1, n do
      r[n - i + 1] = t[i]
    end
  end
  return r
end

--- Shuffles the elements in a list
-- @param t Table
-- @param r Destination table (optional)
-- @return Reversed table
local rand = math.random
function _table.shuffle(t, r)
  r = r or t
  local n = #t
  -- shuffle copy
  if t ~= r then
    for i = 1, n do
      r[i] = t[i]
    end
  end
  -- shuffle in place
  for i = n, 1, -1 do
    local j = rand(n)
    r[i], r[j] = r[j], r[i]
  end
  return r
end

--- Finds the first occurrence in a list
-- @param t Table
-- @param s Search value
-- @param o Starting index (optional)
-- @return Numeric index or nil
function _table.find(t, s, o)
  o = o or 1
  assert(s ~= nil, "second argument cannot be nil")
  for i = o, #t do
    if t[i] == s then
      return i
    end
  end
end

--- Finds the last occurrence in a list
-- @param t Table
-- @param s Search value
-- @param o Starting index (optional)
-- @return Numeric index or nil
function _table.rfind(t, s, o)
  o = o or #t
  assert(s ~= nil, "second argument cannot be nil")
  -- iterate in reverse
  for i = o, 1, -1 do
    if t[i] == s then
      return i
    end
  end
end

--- Recursive deep copy (internal)
--- "cache" must be empty prior to calling this function
-- @param s Source table
-- @param d Destination table
local function dcopy(s, d)
  -- copy elements from the source table
  for k, v in pairs(s) do
    if type(v) == "table" then
      if _cache[v] then
        -- reference cycle
        d[k] = _cache[v]
      else
        -- recursive copy
        local d2 = d[k]
        if d2 == nil then
          d2 = {}
          d[k] = d2
        end
        _cache[v] = d2
        dcopy(v, d2)
      end
    else
      d[k] = v
    end
  end
end

--- Copies the contents from one table to another
--- Overwrites existing elements in the destination table
--- Preserves table cycles
-- @param s Source table
-- @param d Destination table (optional)
-- @return Resulting table
function _table.copy(s, d)
  d = d or {}
  assert(s ~= d, "source and destination tables must be different")
  -- clear the cache
  _table.clear(_cache)
  -- deep copy
  dcopy(s, d)
  return d
end

-- Inject in the table module
_table.copy(_table, table)

return _table