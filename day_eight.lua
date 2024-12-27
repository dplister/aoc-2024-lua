local grid = require "grid"

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
    local result = {}
    for _, e in ipairs(ps) do
        local cells = grid.matching_elements(g, element_matcher(e))
        result[#result + 1] = cells
    end
    return result
end
