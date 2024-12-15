-- lua doesn't have pattern matching alternates, so we'll create a simple alternative
matching = {}

--[[
    Finds the element in the array and returns its position.
]]
function matching.index_of(arr, element)
    for i=1,#arr do
        if arr[i] == element then
            return i
        end
    end
    return 0
end

--[[ 
    Matches a set of patters against the input.
    Returns an array of matches in the order they are found.
    If two patterns both find a match at the same index, the first pattern
    takes precedence.
 ]]
function matching.multi_pattern(input, patterns)
    local matches = {}
    -- iterate through each pattern and find the matches
    for _, p in ipairs(patterns) do
        local index = 1
        while index < (#input + 1) do
            local st, en, cap = string.find(input, p, index)
            -- print("pattern: " .. p .. " st: " .. (st or "") .. " en: " .. (en or "") .. " cap: " .. (cap or ""))
            if st then
                matches[#matches + 1] = { index = st, capture = cap, pattern = p }
                index = en + 1
            else
                index = #input + 1
            end
        end
    end
    -- order by index and then pattern location
    table.sort(matches, function(a, b)
        if (a.index < b.index) then
            return true
        elseif (a.index == b.index) then
            return matching.index_of(patterns, a.pattern)
                < matching.index_of(patterns, b.pattern)
        else
            return false
        end
    end)
    return matches
end

return matching
