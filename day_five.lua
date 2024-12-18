local filehelper = require "filehelper"

function parse_input(line)
	local matches = {}
	for m in string.gmatch(line, "%d+") do
		matches[#matches + 1] = tonumber(m)
	end
    return matches
end

function build_rules_updates(lines)
	-- reads lines into rules until first empty line, rest is update set
	local enc = true
	local result = {}
	local rules = {}
	local updates = {}
	for _, line in ipairs(lines) do
		if #line == 0 then
			enc = false
		else if enc then
			rules[#rules + 1] = parse_input(line)
		else 
			updates[#updates + 1] = parse_input(line)
		end
	end
	result.rules = rules
	result.updates = updates
	return result
end

--[[
	Returns true if left should before right
]]--
function is_before(rules, left, right)

end

function part_a(lines)
	
end

part_a(filehelper.read_lines(arg[1]))
