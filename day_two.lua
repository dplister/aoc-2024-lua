local fh = require "filehelper"
local insp = require "inspect"

function parse_input(line)
	local matches = {}
	for m in string.gmatch(line, "%d+") do
		matches[#matches + 1] = tonumber(m)
	end
    return matches
end

function collect_reports(filename)
    local reports = {}
    local lines = fh.read_lines(filename)
    for _, line in ipairs(lines) do
        reports[#reports + 1] = parse_input(line)
    end
    return reports
end

function compare(a, b)
    if (a < b) then
        return "ASC", (b - a)
    elseif (b < a) then
        return "DESC", (a - b)
    else
        return "EQUAL", 0
    end
end

function is_valid(report)
    local currentdir
    for i=2, #report do
        local dir, diff = compare(report[i - 1], report[i])
        -- print("r[i -1]: " .. report[i - 1] .. " r[i]: " .. report[i] .. " dir: " .. dir .. " diff: " .. diff)
        if currentdir == nil then
            currentdir = dir
        end
        if dir == "EQUAL" or dir ~= currentdir then
            return false
        end
        if diff < 1 or diff > 3 then
            return false
        end
    end
    return true
end

function part_a(reports)
    local total = 0
    for _, v in ipairs(reports) do
        -- inspect.print_array(v)
        if is_valid(v) then
            total = total + 1
        end
    end
    return total
end

function valid_skip(reports)
    for i=1,#reports do
        -- create a copy except for one value removed
        local subbed = {}
        for x=1,#reports do
            if x ~= i then
                subbed[#subbed + 1] = reports[x]
            end
        end
        if is_valid(subbed) then
            return true
        end
    end
    return false
end

function part_b(reports)
    local total = 0
    for _, v in ipairs(reports) do
        -- inspect.print_array(v)
        if is_valid(v) then
            total = total + 1
        elseif valid_skip(v) then
            total = total + 1
        end
    end
    return total
end

local reports = collect_reports(arg[1])
print(part_b(reports))
