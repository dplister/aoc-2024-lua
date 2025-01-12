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
            list.append(state.inners, p)
            count_region(g, explored, p.x, p.y, state)
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

--[[
	Determine if a new 
]]--
function track_borders(g, x, y, border_id)
	
end

function has_vertical(g, x, y)
	-- if left is nil and right isn't
	-- if right is nil and left isn't
	return (not grid.in_bounds(g[y][x] 
end

function count_edges(inners)
	assert(#inners > 0)
	-- create a grid
	local mx_x, mx_y = inners[1].x, inners[1].y
	for i=2,#inners do
		mx_x = mx_x > inners[i].x and mx_x or inners[i].x
		mx_y = mx_y > inners[i].y and mx_y or inners[i].y
	end
	local g = create_grid(mx_x, mx_y, function () return nil end)
	-- mark all spots with inners
	for _, p in ipairs(inners) do
		g[p.y][p.x] = p
	end
end

function part_b(lines)
    local g = grid.create(lines)
    -- create a duplicate grid to mark explored
    local explored = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return false end)
	local total = 0
	local state = count_region(g, explored, 1, 1, { target = g[1][1] })
	--[[
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
	]]--
	return total
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")
print(part_a(filehelper.read_lines(filename)))
