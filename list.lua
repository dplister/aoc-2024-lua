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
    Creates a list from a string.
	Optional transformer function to convert each value.
]]--
function list.string_list(str, value_transform_f)
    local ls = {}
	if value_transform_f == nil then
		value_transform_f = function (v) return v end
	end
    for i=1, #str do
        ls[i] = value_transform_f(string.sub(str, i, i))
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
    if elements == nil then
        elements = {}
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
    If ls was nil, it will be initialised.
        In case of nil ls, caller will need to remember to bind return value.
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

--[[
    Executes a function across a list carrying a running value.
    f of signature f(running_value, current).
    (Optional) seed value for initial total.
        If seed omitted, f will need to handle nil for initial running total.
]]--
function list.fold(ls, f, seed)
    if #ls == 0 then return seed end
    local result = f(seed, ls[1])
    for i=2,#ls do
        result = f(result, ls[i])
    end
    return result
end

return list
