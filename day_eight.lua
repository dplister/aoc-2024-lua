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

--[[
	Retrieves the set of antinodes for a particular antenna array
]]--
function antinode_set(antennas)
	local results = {}
	-- combine each antenna with every other antenna
	for i=1, #antennas do
		for j=i+1, #antennas do
			local nodes = antinodes(antennas[i], antennas[j])
			-- append nodes
			list.append(results, nodes)
		end
	end
	return results
end

function part_a(lines)
    local g = grid.create(lines)
    local antennas = collect_antennas(g)
	-- iterate through each antenna set
	for _, v in ipairs(antennas) do
		print("--- Antenna Set For: " .. v[1].c .. " ---")
		for _, c in ipairs(v) do
			print("x: " .. c.x .. " y: " .. c.y)
		end
		local nodes = antinode_set(v)
		-- remove nodes outside of grid
		print("--- Antinodes ---")
		for _, c in ipairs(nodes) do
			print("x: " .. c.x .. " y: " .. c.y)
		end
	end
	return antennas
end

--[[
    Calculates the distance between two points and gathers the set of antinodes
]]--
function antinodes(a, b)
    local dx, dy = grid.distance(a.x, a.y, b.x, b.y)
    local nodes = {}
    nodes[#nodes + 1] = { x=a.x + dx, y=a.y + dy }
    nodes[#nodes + 1] = { x=b.x + dx, y=b.y + dy }
    nodes[#nodes + 1] = { x=a.x + (dx * -1), y=a.y + (dy * -1) }
    nodes[#nodes + 1] = { x=b.x + (dx * -1), y=b.y + (dy * -1) }
    -- remove elements that conform to a and b
    nodes = list.except(nodes, { a, b }, 
        function (a, b) return a.x == b.x and a.y == b.y end)
    return nodes 
end

print(part_a(filehelper.read_lines(arg[1])))
