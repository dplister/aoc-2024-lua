local filehelper = require "filehelper"
local grid = require "grid"

--[[
    Returns set of paths that are in incremental order.
]]--
function explore(g, px, py, c)
    if c == 9 then
        return 1
    end
    -- fetch the next set of steps
    local ds = grid.next_dir(g, px, py, { "N", "S", "E", "W" })
    local result = 0
    for _, d in ipairs(ds) do
        if d.c == (c + 1) then
            result = result + explore(g, d.x, d.y, d.c)
        end
    end
    return result
end

-- find all ones
function part_a(lines)
    local g = grid.create(lines)
    local pts = grid.matching_elements(g, function (x, y, e) return e == 0 end)
    local results = 0
    for _, p in ipairs(pts) do
        results = results + explore(g, p)
    end
end

print(part_a(filehelper.read_all(arg[1])))
