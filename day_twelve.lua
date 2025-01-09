local list = require "list"
local filehelper = require "filehelper"
local grid = require "grid"

--[[
   Counts the area and the perimeter of the current region.
]]--
function count_region(g, explored, x, y, state)
    -- ensure we don't revisit
    explored[y][x] = true
    -- add region (will use to calcualte area)
    state.visited = list.append(state.visited, { { x = x, y = y } })
    -- get surrounding areas
    local pts = grid.next_dir(g, x, y, { "N", "S", "E", "W" })
    -- if there are less than 4 points, we are hitting grid borders, fence them
    state.borders = (state.borders or 0) + (4 - #pts)
    -- check the surrounding areas
    for _, p in ipairs(pts) do
        if p.c ~= state.target then
            state.borders = state.borders + 1
        elseif not explored[p.y][p.x] then -- is same, explore it too if we haven't been
            count_region(g, explored, p.x, p.y, state)
        end
    end
    return state
end

function print_state(state)
    print("--- Target: " .. state.target .. " ---")
    -- all visited nodes
    for _, v in ipairs(state.visited) do
        print("x: " .. v.x .. " y: " .. v.y)
    end
    -- border count
    print("Borders: " .. state.borders)
end

function part_a(lines)
    local g = grid.create(lines)
    -- create a duplicate grid to mark explored
    local explored = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return false end)
    local state = count_region(g, explored, 1, 1, { target = "A" })
    print_state(state)
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")
print(part_a(filehelper.read_lines(filename)))
