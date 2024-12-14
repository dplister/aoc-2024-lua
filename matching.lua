-- lua doesn't have alternates, so we'll create a simple alternative
matching = {}

-- returns an array of matches in the order they are found
-- if two patterns both find a match at the same index, the first pattern
-- takes precedence
function matching.multi_pattern(input, patterns)
    local matches = {}
    -- iterate through each pattern and find the matches
    for _, p in ipairs(patterns) do
        local index = 1
        local st, en, cap = string.find(input, p, index)
        if st then
            matches[#matches + 1] = { index = st, capture = cap, pattern = p }
        end
    end
    return matches
end

return matching
