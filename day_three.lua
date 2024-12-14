local fh = require "filehelper"
local insp = require "inspect"

function collect_muls(line)
	local matches = {}
	for m in string.gmatch(line, "mul%(%d+,%d+%)") do
		matches[#matches + 1] = m
	end
    return matches
end

function collect_nums(mul)
    local matches = {}
    for m in string.gmatch(mul, "%d+") do
        matches[#matches + 1] = tonumber(m)
    end
    return matches
end

function part_a(line)
    local muls = collect_muls(line)
    local total = 0 
    for _, v in ipairs(muls) do
        local nums = collect_nums(v)
        total = total + (nums[1] * nums[2])
    end
    return total
end

print(part_a(filehelper.read_all(arg[1])))
