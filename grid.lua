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
	Optional transformation function to convert cell values.
]]--
function grid.create(lines, value_transform_f)
    assert(#lines > 0) -- must have a height of at least 1
    assert(#lines[1] > 0) -- must have a width of at least 1
    local g = {}
    for _, line in ipairs(lines) do
        g[#g + 1] = list.string_list(line, value_transform_f)
    end
    return g
end

--[[
    Creates a grid of width and height, initialising each cell via setter_f(x, y)
]]--
function grid.create_f(width, height, setter_f)
    local g = {}
    for y=1,height do
        g[y] = {}
        for x=1,width do
            g[y][x] = setter_f(x, y)
        end
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
    If n is omitted, projection continues until boundary.
    If n is supplied, will return fewer cells if the projection would be beyond the boundary of the grid.
]]--
function grid.project(g, px, py, stepx, stepy, n)
    local result = {}
    while grid.in_bounds(g, px, py)
        and (n == nil or #result < n) do
        result[#result + 1] = g[py][px]
        px = px + stepx
        py = py + stepy
    end
    return result
end

--[[
    Returns the set of cells, starting at px, py and continuing in a 
    step px, py until terminate returns true
    If terminate is not supplied, step will continue until bouundary.
]]--
function grid.path(g, px, py, stepx, stepy, terminate)
    local result = {}
    while grid.in_bounds(g, px, py)
        and (terminate == nil 
            or not terminate(px, py, g[py][px])) do
        result[#result + 1] = { x=px, y=py }
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

--[[
    Returns the coordinates of the first cell
    that contains the matching element.
    Returns nil if not found.
]]--
function grid.find(g, target)
    for y=1, grid.height(g) do
        for x=1, grid.width(g, y) do
            if g[y][x] == target then
                return x, y
            end
        end
    end
    return nil
end

--[[
    Finds all unique elements in grid
]]--
function grid.unique_elements(g)
    local ls = {}
    for y=1, grid.height(g) do
        for x=1, grid.width(g, y) do
            ls[g[y][x]] = 1
        end
    end
    local elements = {}
    for k, _ in pairs(ls) do
        elements[#elements + 1] = k
    end
    return elements
end

--[[
    Finds all matching elements in grid
]]--
function grid.matching_elements(g, matcher)
    local ls = {}
    for y=1, grid.height(g) do
        for x=1, grid.width(g, y) do
            if matcher(x, y, g[y][x]) then
                ls[#ls + 1] = { x=x, y=y, c=g[y][x] }
            end
        end
    end
    return ls
end

--[[
    Retrieves the distance between two points
]]--
function grid.distance(ax, ay, bx, by)
    return (bx - ax), (by - ay)
end

--[[
    Retrieves the points in the directions supplied from the supplied x,y starting position.
]]--
function grid.next_dir(g, x, y, dirs)
    local pts = {}
    for _, d in ipairs(dirs) do
        local wx = x + grid.step_directions[d].x
        local wy = y + grid.step_directions[d].y
        if grid.in_bounds(g, wx, wy) then
            pts[#pts + 1] = { x = wx, y = wy, c = g[wy][wx] }
        end
    end
    return pts
end

return grid
