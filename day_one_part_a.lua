local fh = require "filehelper"

print(type(fh))
print(fh)

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

left, right = collect_numbers("one_example.txt")
print("x: " .. left[1] .. " y: " .. right[1])
