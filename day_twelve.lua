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
    local pts = grid.next_dirs(g, x, y, { "N", "S", "E", "W" })
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

function mark_vertical(g, x, y, condition_f, setter_f)
    -- project N and S and mark
    local f = function (px, py, p)
        -- f is reason to terminate
        return type(p) ~= "table" or not condition_f(g, px, py)
    end
    local vn = grid.path(g, x, y, 0, -1, f)
    local vs = grid.path(g, x, y, 0, 1, f)
    vn = list.append(vn, vs)
    -- print("Vertical search yielded " .. #vn .. " pts")
    for _, p in ipairs(vn) do
        setter_f(p)
    end
end

function mark_horizontal(g, x, y, condition_f, setter_f)
    -- project W and E and mark
    -- f is reason to terminate
    local f = function (px, py, p)
        return type(p) ~= "table" or not condition_f(g, px, py)
    end
    local vw = grid.path(g, x, y, -1, 0, f)
    local ve = grid.path(g, x, y, 1, 0, f)
    vw = list.append(vw, ve)
    -- print("Horizontal search yielded " .. #vw .. " pts")
    for _, p in ipairs(vw) do
        setter_f(p)
    end
end

--[[
    Extend all borders present from x,y.
    Returns the last created border_id
]]--
function track_borders(g, x, y, border_id)
    -- print("Check x: " .. x .. " y: " .. y)
    if not g[y][x].left_border_id and has_vertical_left(g, x, y) then
        -- print("Left border identified for " .. x .. "/" .. y)
        border_id = border_id + 1
        mark_vertical(g, x, y, has_vertical_left, function (p) g[p.y][p.x].left_border_id = border_id end)
    end
    if not g[y][x].right_border_id and has_vertical_right(g, x, y) then
        -- print("Right border identified for " .. x .. "/" .. y)
        border_id = border_id + 1
        mark_vertical(g, x, y, has_vertical_right, function (p) g[p.y][p.x].right_border_id = border_id end)
    end
    if not g[y][x].above_border_id and has_horizontal_above(g, x, y) then
        -- print("Above border identified for " .. x .. "/" .. y)
        border_id = border_id + 1
        mark_horizontal(g, x, y, has_horizontal_above, function (p) g[p.y][p.x].above_border_id = border_id end)
    end
    if not g[y][x].below_border_id and has_horizontal_below(g, x, y) then
        -- print("Below border identified for " .. x .. "/" .. y)
        border_id = border_id + 1
        mark_horizontal(g, x, y, has_horizontal_below, function (p) g[p.y][p.x].below_border_id = border_id end)
    end
    return border_id
end

function has_vertical_left(g, x, y)
    return has_edge(g, x, y, "W")
end

function has_vertical_right(g, x, y)
    return has_edge(g, x, y, "E")
end

function has_horizontal_above(g, x, y)
    return has_edge(g, x, y, "N")
end

function has_horizontal_below(g, x, y)
    return has_edge(g, x, y, "S")
end

function has_edge(g, x, y, outside)
    local outside_pt = grid.next_dir(g, x, y, outside)
    -- outside bounds returns nil
    return (outside_pt == nil or outside_pt.c == 0)
end

function calculate_edges(pts)
    assert(#pts > 0)
    -- create a grid
    local mx_x, mx_y = pts[1].x, pts[1].y
    for i=2,#pts do
        mx_x = mx_x < pts[i].x and pts[i].x or mx_x
        mx_y = mx_y < pts[i].y and pts[i].y or mx_y
    end
    local g = grid.create_f(mx_x, mx_y, function () return 0 end)
    for _, p in ipairs(pts) do
        g[p.y][p.x] = { p = p }
    end
    print("Border dimensions w:" .. grid.width(g, 1) .. " h:" .. grid.height(g))
    for y=1,mx_y do
        local line = ""
        for x=1,mx_x do
            if type(g[y][x]) == "table" then 
                line = line .. "T" 
            else 
                line = line .. g[y][x]
            end
        end
        print(line)
    end
    -- mark all the edges
    local border_id = 0
    for _, p in ipairs(pts) do
        border_id = track_borders(g, p.x, p.y, border_id)
    end
    return border_id
end

function part_b(lines)
    local g = grid.create(lines)
    -- create a duplicate grid to mark explored
    local explored = grid.create_f(grid.width(g, 1), grid.height(g), 
        function (x, y) return false end)
	local total = 0
	for y=1,grid.height(g) do
		for x=1,grid.width(g,y) do
			if not explored[y][x] then
                local state = count_region(g, explored, x, y, { target = g[y][x] })
                local border_count = calculate_edges(state.visited)
                print("Border count: " .. border_count)
                local cost = border_count * #state.visited
                print("Cost: " .. cost)
                total = total + cost
            end
        end
    end
	return total
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")
print(part_b(filehelper.read_lines(filename)))
