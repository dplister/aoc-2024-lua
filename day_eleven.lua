list = require "list"
mathext = require "mathext"
filehelper = require "filehelper"

function blink(nm_mp)
    local result = {}
	for k, v in pairs(nm_mp) do
        if k == 0 then
            result[1] = (result[1] or 0) + v
        elseif mathext.digits(k) % 2 == 0 then
            local l, r = mathext.split_digits(k)
            result[l] = (result[l] or 0) + v
            result[r] = (result[r] or 0) + v
        else
            local r = k * 2024
            result[r] = (result[r] or 0) + v
        end
    end
    return result
end

function loop(nums, repeats)
    local nm = {}
    for _, v in ipairs(nums) do
        nm[v] = (nm[v] or 0) + 1
    end
    for i=1,repeats do 
        nm = blink(nm)
    end
    -- report on blink state
    for k, v in pairs(nm) do
        print("k: " .. k .. " v: " .. v)
    end
    local total = 0
    for _, v in pairs(nm) do
        total = total + v
    end
    return total
end

function part_ab(line, iterations)
	local nums = list.string_numbers(line)
    print("Nums: " .. table.concat(nums, ", "))
    local result = loop(nums, iterations)
    return result
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")

local iterations = tonumber(arg[2])
assert(iterations, "Second argument must be a valid number")

print(string.format("%.f", part_ab(filehelper.read_all(filename), iterations)))
