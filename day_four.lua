local fh = require "filehelper"
local grid = require "grid"
local inspect = require "inspect"
local list = require "list"

function collect_conforming_projections(g, x, y, str)
    local matching_directions = {}
    for key, step in pairs(grid.step_directions) do
        local ps = grid.project(g, x, y, step.x, step.y, #str)
        local retrieved = table.concat(ps)
        if str == retrieved then
            matching_directions[#matching_directions + 1] = step
        end
    end
    return matching_directions
end

function is_cross(g, x, y, chars)
    local tl = grid.project(g, x - 1, y - 1, 1, 1, #chars)
    if #tl < #chars then return false end
    local bl = grid.project(g, x - 1, y + 1, 1, -1, #chars)
    if #bl < #chars then return false end
    return list.arrays_equal(tl, chars)
        and list.arrays_equal(bl, chars)
end

function count_matching_string(g, str)
    local count = 0
    local prefix = string.sub(str, 1, 1)
    for y=1, grid.height(g) do
        for x=1, grid.width(g, y) do
            if g[y][x] == prefix then
                count = count + #collect_conforming_projections(g, x, y, str)
            end
        end
    end
    return count
end


function count_cross(g, chars)
    local count = 0
    local prefix = chars[2]
    for y=1, grid.height(g) do
        for x=1, grid.width(g, y) do
            if g[y][x] == prefix then
                count = count + (is_cross(g, x, y, chars) and 1 or 0)
            end
        end
    end
    return count
end

function part_a(lines)
    local g = grid.create(lines)
    local total = count_matching_string(g, "XMAS")
    return total
end

function part_b(lines)
    local g = grid.create(lines)
    local total = count_cross(g, { "M", "A", "S" })
    return total
end

print(part_b(filehelper.read_lines(arg[1])))
