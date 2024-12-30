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
    collect_antennas(g)
end

print(part_a(filehelper.read_lines(arg[1])))
