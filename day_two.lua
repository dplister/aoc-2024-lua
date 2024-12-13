local fh = require "filehelper"
local insp = require "inspect"

function parse_input(line)
	local matches = {}
	for m in string.gmatch(line, "%d+") do
		matches[#matches + 1] = m
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

local reports = collect_reports(arg[1])
insp.print_array(reports[1])
