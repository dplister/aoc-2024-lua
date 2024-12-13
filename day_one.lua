local fh = require "filehelper"
local insp = require "inspect"

function parse_input(line)
	local matches = {}
	for m in string.gmatch(line, "%d+") do
		matches[#matches + 1] = m
	end
	return matches[1], matches[2]
end

function collect_numbers(filename)
    local left = {}
	local right = {}
    local lines = fh.read_lines(filename)
	for _, line in ipairs(lines) do
		left[#left + 1], right[#right + 1] = parse_input(line)
	end
	return left, right
end

function distance(x, y)
    return math.max(x, y) - math.min(x, y)
end

function compress(arr)
    local ctr = {}
    for _, v in ipairs(arr) do
       ctr[v] = (ctr[v] or 0) + 1
       -- print("v: " .. v .. " ctr[v]: " .. ctr[v])
    end
    return ctr
end

function part_a(left, right)
    local total = 0
    for i=1, #left do
        local res = distance(left[i], right[i])
        -- print("left: " .. left[i] .. " right: " .. right[i] .. " result: " .. res)
        total = total + res
    end
    return total
end

function part_b(left, right)
    local total = 0
    for k, v in pairs(left) do
        -- print("k: " .. k ..  " v: " .. v .. " r: " .. (right[k] or 0))
        total = total + (k * v * (right[k] or 0))
    end
    return total
end

left, right = collect_numbers(arg[1])
table.sort(left)
table.sort(right)
-- print(part_a(left, right))
left = compress(left)
right = compress(right)
-- print("left table")
-- inspect.print_table(left)
-- print("right table")
-- inspect.print_table(right)
print(part_b(left, right))
