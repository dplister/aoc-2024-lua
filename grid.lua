inspect = require("inspect")
list = require("list")

grid = {}

--[[
    Grid stepping based on directions.
    Use to help orient oneself in the coordinate system.
    (N is negative, S is positive, W is negative, E is positive)
]]--
grid.step_directions = {
    ["N"] = { x=0, y=-1 },
    ["NE"] = { x=1, y=-1 },
    ["E"] = { x=1, y=0 },
    ["SE"] = { x=1, y=1 },
    ["S"] = { x=0, y=1 },
    ["SW"] = { x=-1, y=1 },
    ["W"] = { x=-1, y=0 },
    ["NW"] = { x=-1, y=-1 }
}

--[[
    Creates a grid from a set of lines of characters.
]]--
function grid.create(lines)
    assert(#lines > 0) -- must have a height of at least 1
    assert(#lines[1] > 0) -- must have a width of at least 1
    local g = {}
    for _, line in ipairs(lines) do
        g[#g + 1] = list.string_list(line)
    end
    return g
end

--[[
    Returns the string representation of the grid.
]]--
function grid.output(g)
    local r = {}
    for _, v in ipairs(g) do
        r[#r + 1] = table.concat(v)
    end
    return table.concat(r, string.char(10))
end

--[[
    Returns the set of cells, starting at px, py and continuing in a 
    step px, py until n cells are collected.
    Will return fewer cells if the projection would be beyond the boundary of the grid.
]]--
function grid.project(g, px, py, stepx, stepy, n)
    local result = {}
    while grid.in_bounds(g, px, py)
        and #result < n do
        result[#result + 1] = g[py][px]
        px = px + stepx
        py = py + stepy
    end
    return result
end

--[[
    Determines if px, py is located within the grid cells.
]]--
function grid.in_bounds(g, px, py)
    return py >= 1
        and py <= #g
        and px >= 1
        and px <= #g[py]
end

--[[
    Returns the width of the current grid row.
]]--
function grid.width(g, y)
    return #g[y]
end

--[[
    Returns the height of the grid.
]]--
function grid.height(g)
    return #g
end

return grid
