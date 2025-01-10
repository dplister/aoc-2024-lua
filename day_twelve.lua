local list = require "list"
local filehelper = require "filehelper"
local grid = require "grid"

--[[
   Counts the area and the perimeter of the current region.
]]--
function count_region(g, explored, edges, x, y, state)
    -- ensure we don't revisit
    explored[y][x] = true
    -- add region (will use to calcualte area)
    local current = { x = x, y = y }
    state.visited = list.append(state.visited, { current })
    -- get surrounding areas
    local pts = grid.next_dir(g, x, y, { "N", "S", "E", "W" })
    -- if there are less than 4 points, we are hitting grid borders, fence them
    state.borders = (state.borders or 0) + (4 - #pts)
    -- check the surrounding areas
    for _, p in ipairs(pts) do
        if p.c ~= state.target then
            state.borders = state.borders + 1
        elseif not explored[p.y][p.x] then -- is same, explore it too if we haven't been
            current[p.from_dir] = p
            list.append(state.inners, p)
            count_region(g, explored, edges, p.x, p.y, state)
        end
    end
    -- check edges
    if not edges[y][x].vertical_id and has_vertical(g, current) then
        state.max_border_id = (state.max_border_id or 0) + 1
        edges[y][x].vertical_id = max_border_id
        -- go n and s
        local ns = grid.path(g, x, y, 0, -1, function (cx, cy, cc) return cc ~= g[y][x] end)
        local ss = grid.path(g, x, y, 0, 1, function (cx, cy, cc) return cc ~= g[y][x] end)
        list.append(ns, ss)
        for _, vp in ipairs(ns) do
            if has_vertical(g, vp) then
                edges[vp.y][vp.x].vertical_id = max_border_id
            end
        end
    end
    if not edges[y][x].horizontal_id and has_horizontal(g, current) then
        state.max_border_id = (state.max_border_id or 0) + 1
        edges[y][x].horizontal_id = max_border_id
        -- go e and s
        local es = grid.path(g, x, y, 1, 0, function (cx, cy, cc) return cc ~= g[y][x] end)
        local ws = grid.path(g, x, y, -1, 0, function (cx, cy, cc) return cc ~= g[y][x] end)
        list.append(es, ws)
        for _, vp in ipairs(es) do
            if has_horizontal(g, vp) then
                edges[vp.y][vp.x].horizontal_id = max_border_id
            end
        end
    end
    return state
end

-- checks if the point is a vertical edge
function has_vertical(g, p)
    return (p["W"] and not p["E"])
        or (p["E"] and not p["W"])
end

function has_horizontal(g, p)
    return (p["N"] and not p["S"])
        or (p["S"] and not p["N"])
end

function print_state(state)
    print("--- Target: " .. state.target .. " ---")
    -- all visited nodes
    for _, v in ipairs(state.visited) do
        print("x: " .. v.x .. " y: " .. v.y)
    end
	print("Total: " .. #state.visited)
    -- border count
    print("Borders: " .. state.borders)
end

function part_a(lines)
    local g = grid.create(lines)
    -- create a duplicate grid to mark explored
    local explored = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return false end)
    local edges = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return {} end)
	local total = 0
	for y=1,grid.height(g) do
		for x=1,grid.width(g,y) do
			if not explored[y][x] then
				local state = count_region(g, explored, edges, x, y, { target = g[y][x] })
				print_state(state)
				local cost = state.borders * #state.visited
				print("Cost: " .. cost)
				total = total + cost
			end
		end
	end
	return total
end

function part_b(lines)
    local g = grid.create(lines)
    -- create a duplicate grid to mark explored
    local explored = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return false end)
    local edges = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return {} end)
	local total = 0
	for y=1,grid.height(g) do
		for x=1,grid.width(g,y) do
			if not explored[y][x] then
				local state = count_region(g, explored, x, y, { target = g[y][x] })
				print_state(state)
				local cost = state.borders * #state.visited
				print("Cost: " .. cost)
				total = total + cost
			end
		end
	end
	return total
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")
print(part_a(filehelper.read_lines(filename)))
