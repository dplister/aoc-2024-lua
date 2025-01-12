local filehelper = require "filehelper"
local grid = require "grid"

--[[
    Returns set of paths that are in incremental order.
]]--
function explore(g, px, py, c, results, visited)
    if c == 9 then
        results[#results + 1] = { x = px, y = py, c = c }
        return results
    end
    -- fetch the next set of steps
    local ds = grid.next_dirs(g, px, py, { "N", "S", "E", "W" })
    -- remove elements that have already been visited
    local next_c = c + 1
    local cv = visited[next_c]
    ds = list.except(ds, cv, function (a, b) return a.x == b.x and a.y == b.y end)
    -- remove elements not the next number
    ds = list.filter(ds, function (e) return e.c == next_c end)
    -- mark all possible directions as visited
    visited[next_c] = list.append(visited[next_c], ds)
    for _, d in ipairs(ds) do
        explore(g, d.x, d.y, d.c, results, visited)
    end
    return results
end

function rate(g, px, py, c)
    if c == 9 then
        return 1
    end
    -- fetch the next set of steps
    local total = 0
    local ds = grid.next_dirs(g, px, py, { "N", "S", "E", "W" })
    for _, d in ipairs(ds) do
        if d.c == c + 1 then
            total = total + rate(g, d.x, d.y, d.c)
        end
    end
    return total
end

function part_a(lines)
    local g = grid.create(lines, function (v) return tonumber(v) end)
    local pts = grid.matching_elements(g, function (x, y, e) return e == 0 end)
    local pts_found = 0
    for _, p in ipairs(pts) do
        local ends = {}
        explore(g, p.x, p.y, p.c, ends, {})
        pts_found = pts_found + #ends
        print("-- Ends For " .. p.x .. " / " .. p.y .. " --")
        for _, v in ipairs(ends) do
            print("x: " .. v.x .. " y: " .. v.y .. " c: " .. v.c)
        end
    end
    return pts_found
end

function part_b(lines)
    local g = grid.create(lines, function (v) return tonumber(v) or "." end)
    local pts = grid.matching_elements(g, function (x, y, e) return e == 0 end)
    local total = 0
    for _, p in ipairs(pts) do
        local rating = rate(g, p.x, p.y, p.c)
        print("Rating For " .. p.x .. " / " .. p.y .. ": " .. rating)
        total = total + rating
    end
    return total
end

print(part_b(filehelper.read_lines(arg[1])))
