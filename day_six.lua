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
    local loopdetection = {}
    while true
    do
        local step = grid.step_directions[dir]
        local path = grid.path(g, px, py, step.x, step.y, function (tx, ty, cval)
            return cval == "#"
        end)
        -- if we are boxed in, we may need to spin out
        if #path > 0 then
            pointsets[#pointsets + 1] = path
            local last_step = path[#path]
            -- print("Start px: " .. px .. " py: " .. py)
            -- print("End px: " .. last_step.x .. " py: " .. last_step.y)
            -- check if the next step would have breached boundary
            if not grid.in_bounds(g, last_step.x + step.x, last_step.y + step.y) then
                pointsets[#pointsets + 1] = "Boundary"
                return pointsets
            end
            -- check is not a loop
            local last_stepdir = {x=last_step.x, y=last_step.y, d=dir }
            if list.array_index(loopdetection, last_stepdir, function (a, b)
                return a.x == b.x and a.y == b.y and a.d == b.d
            end) > -1 then
                pointsets[#pointsets + 1] = "Loop"
                return pointsets
            end
            -- add to loop detection
            loopdetection[#loopdetection + 1] = last_stepdir
            print("Added: X:" .. last_stepdir.x .. " Y:" .. last_stepdir.y .. " D:" .. last_stepdir.d)
            -- rotate and continue
            px = last_step.x
            py = last_step.y
        end
        dir = next_dir(dir)
    end
end

--[[
    Uses each point in the path to insert an obstruction
    and simulates if it would cause a loop.
    Returns all valid obstruction places.
]]--
function obstruction_simulate(g, px, py, dir, points)
    local obs_locs = {}
    -- obstruction can't be in player start position
    local possible_points = list.filter(points, function (p) return p.x ~= px or p.y ~= py end)
    for _, p in ipairs(possible_points) do
        -- set the block
        print("Setting block at X:" .. p.x .. " Y:" .. p.y)
        g[p.y][p.x] = "#"
        -- determine if a loop
        local pointset = run(g, px, py, dir)
        if pointset[#pointset] == "Loop" then
            obs_locs[#obs_locs + 1] = p
        end
        -- unset the block
        g[p.y][p.x] = "."
    end
    return obs_locs
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

function part_b(lines)
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
    -- find all places that can cause loops
    local obstructions = obstruction_simulate(g, px, py, "N", travelled)
    return #obstructions
end

print(part_b(filehelper.read_lines(arg[1])))
