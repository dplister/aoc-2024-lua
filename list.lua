list = {}

--[[
    Compares two arrays to determine if their contents are identical.
    Values are not expected to be sorted in identical order.
]]--
function list.arrays_equal(l1, l2)
    if #l1 ~= #l2 then 
        return false 
    end
    local values = {}
    -- increment first set
    for _, v in ipairs(l1) do
        values[v] = (values[v] or 0) + 1
    end
    -- decrement second set
    for _, v in ipairs(l2) do
        if values[v] == nil or values[v] < 1 then return false end
        values[v] = values[v] - 1
    end
    -- check first set again to see if all are zeroed
    for _, v in ipairs(l1) do
        if values[v] ~= 0 then return false end
    end
    return true
end

--[[
    Creates a list from a string
]]--
function list.string_list(str)
    local ls = {}
    for i=1, #str do
        ls[#ls + 1] = string.sub(str, i, i)
    end
    return ls
end

--[[
    Returns index of first target match in array.
    If equals is supplied, will compare using it.
]]--
function list.array_index(arr, target, equals)
    if equals == nil then
        for i, v in ipairs(arr) do
            if target == v then
                return i
            end
        end
    else
        for i, v in ipairs(arr) do
            if equals(target, v) then
                return i
            end
        end
    end
    return -1
end

--[[
    Returns the set of elements that are true for the supplied filter function.
]]--
function list.filter(ls, f)
    local result = {}
    for _, v in ipairs(ls) do
        if f(v) then
            result[#result + 1] = v
        end
    end
    return result
end

--[[
    Returns the set of elements, with f applied to each value.
]]--
function list.map(ls, f)
    local result = {}
    for _, v in ipairs(ls) do
        result[#result + 1] = f(v)
    end
    return result
end

--[[
    Converts a string to a list of numbers.
]]--
function list.string_numbers(line)
	local matches = {}
	for m in string.gmatch(line, "%d+") do
		matches[#matches + 1] = tonumber(m)
	end
    return matches
end

--[[
    Returns a new copy of the list, except the first element.
]]--
function list.rest(ls)
    local result = {}
    for i=2,#ls do
        result[#result + 1] = ls[i]
    end
    return result
end

--[[
    Returns set of items except for those present in elements.
    Optional compare function for element comparison, otherwise == used.
    Uses linear search to enable table comparison.
]]--
function list.except(ls, elements, compare)
    if compare == nil then
        compare = function (a, b) return a == b end
    end
    local result = {}
    for i = 1, #ls do
        for j = 1, #elements do
            if compare(ls[i], elements[j]) then
                goto except_found
            end
        end
        result[#result + 1] = ls[i]
        ::except_found::
    end
    return result
end

--[[ 
    Returns the set of elements that are distinct in a list.
    Optional compare function for element comparison, otherwise == used.
    Uses linear search to enable table comparison.
]]--
function list.distinct(ls, compare)
    if compare == nil then
        compare = function (a, b) return a == b end
    end
    local result = {}
    for i = 1, #ls do
        for j = 1, #result do
            if compare(ls[i], result[j]) then
                goto match_added
            end
        end
        result[#result + 1] = ls[i]
        ::match_added::
    end
    return result
end

--[[
	Appends elements to end of ls.
	Affects supplied ls.
]]--
function list.append(ls, elements)
    if ls == nil then
        ls = {}
    end
	for _, v in ipairs(elements) do
		ls[#ls + 1] = v	
	end
	return ls
end

return list
