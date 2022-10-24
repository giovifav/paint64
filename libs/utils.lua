-- 2d table(matrix) transposition rotation
--https://stackoverflow.com/questions/46492602/rotating-tables-in-lua
function transpose(m)
    local rotated = {}
    for c, m_1_c in ipairs(m[1]) do
       local col = {m_1_c}
       for r = 2, #m do
          col[r] = m[r][c]
       end
       table.insert(rotated, col)
    end
    return rotated
 end
 
 function rotate_CCW_90(m)
    local rotated = {}
    for c, m_1_c in ipairs(m[1]) do
       local col = {m_1_c}
       for r = 2, #m do
          col[r] = m[r][c]
       end
       table.insert(rotated, 1, col)
    end
    return rotated
 end
 
 function rotate_180(m)
    return rotate_CCW_90(rotate_CCW_90(m))
 end
 
 function rotate_CW_90(m)
    return rotate_CCW_90(rotate_CCW_90(rotate_CCW_90(m)))
 end
 ------------------------------------------------------------------------------------------------------