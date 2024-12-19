local filehelper = require "filehelper"
local list = require "list"
local inspect = require "inspect"
local mathext = require "mathext"

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
		elseif enc then
            local ps = parse_input(line)
			local mp = rules[ps[1]] or {}
            mp[#mp + 1] = ps[2]
            rules[ps[1]] = mp
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
function is_before(rules, a, b)
    local lr = rules[a]
    return lr 
        and (list.array_index(lr, b) > -1)
end

--[[
    Returns true if left should come after right
]]--
function is_after(rules, a, b)
    local rr = rules[b]
    return rr 
        and (list.array_index(rr, a) > -1)
end

--[[
    Determines if the ordering is correct on the update
]]--
function is_valid_pair(rules, a, b)
    return is_before(rules, a, b)
        or (not is_after(rules, a, b))
end

--[[
    Validate the update based on the rules
]]--
function is_valid(rules, update)
    for i=2,#update do
        if (not is_valid_pair(rules, update[i - 1], update[i])) then
            return false
        end
    end
    return true
end

function repair(rules, update)
    table.sort(update, function (a, b) 
        return is_before(rules, a, b)
    end)
    return update
end

function repair_updates(rules, invalids)
    local fixed = {}
    for _, update in ipairs(invalids) do
        local revised = repair(rules, update)
        fixed[#fixed + 1] = revised
    end
    return fixed
end

function filter_updates(state)
    local result = { valids = {}, invalids = {} }
    for _, update in ipairs(state.updates) do
        if is_valid(state.rules, update) then
            result.valids[#result.valids + 1] = update
        else
            result.invalids[#result.invalids + 1] = update
        end
    end
    return result
end

function print_state(result)
    print("--- Valids ---")
    for _, v in ipairs(result.valids) do
        print(table.concat(v, ", "))
    end
    print("--- Invalids ---")
    for _, v in ipairs(result.invalids) do
        print(table.concat(v, ", "))
    end
end

function part_a(lines)
    local state = build_rules_updates(lines)
    local result = filter_updates(state)
    local count = 0
    for _, v in ipairs(result.valids) do
        local middle = mathext.round(#v/2)
        print("v: " .. #v .. " " .. middle .. " val: " .. v[middle])
        count = count + v[middle]
    end
    return count
end

function part_b(lines)
    local state = build_rules_updates(lines)
    local result = filter_updates(state)
    local fixed = repair_updates(state.rules, result.invalids)
    local count = 0
    for _, v in ipairs(fixed) do
        local middle = mathext.round(#v/2)
        print(table.concat(v, ", "))
        count = count + v[middle]
    end
    return count
end

print(part_b(filehelper.read_lines(arg[1])))
