inspect = {}

function inspect.print_array(ls)
    for i, v in ipairs(ls) do
        print("i: " .. i .. " v: " .. v)
    end
end

function inspect.print_table(tb)
    for k, v in pairs(tb) do
        print("k: " .. k .. " v: " .. v)
    end
end

return inspect
