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

return list
