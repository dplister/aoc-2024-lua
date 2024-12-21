local filehelper = require "filehelper"
local grid = require "grid"

local orth_dirs = {
    "N", "E", "S", "W"
}

--[[
    Returns the direction 90 degrees from the one supplied.
]]--
function next_dir(dir)
    local nd = list.array_index(orth_dirs, dir) + 1
    if nd > 4 then
        nd = 1
    end
    return orth_dirs[nd]
end

--[[ 
    Execute until loop or boundary hit.
    Returns sequence of steps made.
]]--
function run(g, px, py, dir)
    local pointsets = {}
    while true
    do
        local step = grid.step_directions[dir]
        local path = grid.path(g, px, py, step.x, step.y)
        pointsets[#pointsets + 1] = path
        local last_step = path[#path]
        print("Start px: " .. px .. " py: " .. py)
        print("End px: " .. last_step.x .. " py: " .. last_step.y)
        -- check if the next step would have breached boundary
        if not grid.in_bounds(g, last_step.x + step.x, last_step.y + step.y) then
            pointsets[#pointsets + 1] = "Boundary"
            return pointsets
        end
        -- rotate and continue
        px = last_step.x
        py = last_step.y
        dir = next_dir(dir)
    end
end

--[[
    From sets of points, collect the unique set.
]]--
function distinct_points(ps)
    local coords = {}
    for _, row in ipairs(ps) do
        for _, p in ipairs(row) do
            local cs = coords[p.y] or {}
            if list.array_index(cs, p.x) == -1 then
                cs[#cs + 1] = p.x
            end
            coords[p.y] = cs
        end
    end
    -- fold up the coords
    local result = {}
    for y, cs in pairs(coords) do
        for _, x in ipairs(cs) do
            result[#result + 1] = { x=x, y=y }
        end
    end
    return result
end

function part_a(lines)
    -- load grid
    local g = grid.create(lines)
    -- find player
    local px, py = grid.find(g, "^")
    -- collect points
    local pts = run(g, px, py, "N")
    -- remove the terminator indicator
    pts[#pts] = nil
    -- distinct points
    local travelled = distinct_points(pts)
    return #travelled
end

print(part_a(filehelper.read_lines(arg[1])))
