local list = require "list"
local filehelper = require "filehelper"
local grid = require "grid"

--[[
   Counts the area and the perimeter of the current region.
]]--
function count_region(g, explored, x, y, state)
    -- ensure we don't revisit
    explored[y][x] = true
    -- add region (will use to calculate area)
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
	print("Total: " .. #state.visited)
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
end

function calculate_edges(pts)
    -- todo
end

function part_b(lines)
    local g = grid.create(lines)
    -- create a duplicate grid to mark explored
    local explored = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return false end)
	local total = 0
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
    local state = count_region(g, explored, 1, 1, { target = g[1][1] })
    print_state(state)
    local cost = state.borders * #state.visited
    print("Cost: " .. cost)
    total = total + cost
	return total
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")
print(part_b(filehelper.read_lines(filename)))
