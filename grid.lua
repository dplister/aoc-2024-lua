grid = {}

--[[
    Creates a grid from a set of lines of characters
]]--
function grid.create(lines)
    assert(#lines > 0) -- must have a height of at least 1
    assert(#lines[1] > 0) -- must have a width of at least 1
    local g = {}
    for _, line in ipairs(lines) do
        local xs = {}
        for i, x in ipairs(line) do
            xs[i] = x
        end
        g[#g] = xs
    end
    return g
end

function grid.output(g)
    return table.concat(g, '%n')
end

return grid
