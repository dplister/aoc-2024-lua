list = {}

--[[
    Compares two arrays to determine if their contents are identical.
    Values are not expected to be sorted in identical order.
]]--
function list.arrays_equal(l1, l2)
    if #l1 ~= #l2 then 
        return false 
    end
    local keys = {}
    local values = {}
    for _, v in ipairs(l1) do
        keys[#keys + 1] = v
        values[v] = 1
    end
    for _, v in ipairs(l2) do
        keys[#keys + 1] = v
        values[v] = (values[v] or 0) + 1
    end
    for _, v in ipairs(keys) do
        if values[v] ~= 2 then
            return false
        end
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
