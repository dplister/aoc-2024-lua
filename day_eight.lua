local grid = require "grid"
local filehelper = require "filehelper"

-- for each unique element
-- find all the distances between elements and generate points on the outside of the pair
--  need to identify which "outside"
--      easy, outside is the only two ways that wouldn't just end up in the opposite point's spot

function element_matcher(target)
    return function (x, y, c)
        return c == target
    end
end

function collect_antennas(g)
    local ps = grid.unique_elements(g)
    ps = list.except(ps, { "." })
    local result = {}
    for _, e in ipairs(ps) do
        local cells = grid.matching_elements(g, element_matcher(e))
        result[#result + 1] = cells
        print("--- " .. e .. " ---")
        for _, c in ipairs(cells) do
            print("x: " .. c.x .. " y: " .. c.y .. " c: " .. c.c)
        end
    end
    return result
end

function part_a(lines)
    local g = grid.create(lines)
    local antennas = collect_antennas(g)
    local fa = antennas[1]
    local pts = antenna_points(fa[1], fa[2])
    print("--- Pts " .. fa[1].c .. " ---")
    for _, c in ipairs(pts) do
        print("x: " .. c.x .. " y: " .. c.y)
    end
end

--[[
    Calculates the distance between two points and extends them out further.
]]--
function antenna_points(a, b)
    local dx, dy = grid.distance(a.x, a.y, b.x, b.y)
    local antennas = {}
    antennas[#antennas + 1] = { x=a.x + dx, y=a.y + dy }
    antennas[#antennas + 1] = { x=b.x + dx, y=b.y + dy }
    antennas[#antennas + 1] = { x=a.x + (dx * -1), y=a.y + (dy * -1) }
    antennas[#antennas + 1] = { x=b.x + (dx * -1), y=b.y + (dy * -1) }
    -- remove elements that conform to a and b
    antennas = list.except(antennas, { a, b }, 
        function (a, b) return a.x == b.x and a.y == b.y end)
    return antennas
end

print(part_a(filehelper.read_lines(arg[1])))
