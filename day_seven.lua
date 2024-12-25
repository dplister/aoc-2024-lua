local filehelper = require "filehelper"
local list = require "list"
local mathext = require "mathext"

function parse_inputs(lines)
    local ls = {}
    for _, v in ipairs(lines) do
        ls[#ls + 1] = list.string_numbers(v)
    end
    return ls
end

function add(a, b)
    return a + b
end

function mult(a, b)
    return a * b
end

local concat = mathext.concat

function calculate(expected, nums, allowConcat)
    local operands = {}
    local totals = {}
    local depth = 2
    -- print(expected .. ": " .. table.concat(nums, ", "))
    totals[1] = nums[1]
    while true
    do
        --print("Depth: " .. depth)
        -- end check
        if depth > #nums then
            --print("Totals check: " .. totals[depth - 1])
            if totals[depth - 1] == expected then
                return operands
            else
                depth = depth - 1
            end
        -- fell back to level 1, escape
        elseif depth == 1 then
            --print("Depth = 1, escape")
            return nil
        -- ran out of options at this level
        elseif operands[depth - 1] == "*" then 
            --print("Run out of options")
            operands[depth - 1] = nil -- reset for next attempt
            depth = depth - 1
            ::continue::
        -- operand processing
        elseif operands[depth - 1] == nil and allowConcat then
            operands[depth - 1] = "||"
            totals[depth] = concat(totals[depth - 1], nums[depth])
            depth = depth + 1
        elseif operands[depth - 1] == nil or (allowConcat and operands[depth - 1] == "||") then
            operands[depth - 1] = "+"
            totals[depth] = add(totals[depth - 1], nums[depth])
            --print("+ Operand: " .. totals[depth-1] .. "+" .. nums[depth] .. "=" .. totals[depth])
            depth = depth + 1
        elseif operands[depth - 1] == "+" then
            operands[depth - 1] = "*"
            totals[depth] = mult(totals[depth - 1], nums[depth])
            --print("* Operand: " .. totals[depth-1] .. "*" .. nums[depth] .. "=" .. totals[depth])
            depth = depth + 1
        end
    end
    return nil
end

function part_a(lines)
    local count = 0
    for _, ln in ipairs(lines) do
        local nums = list.string_numbers(ln)
        local result = calculate(nums[1], list.rest(nums))
        if result ~= nil then
            count = count + nums[1]
        end
    end
    return count
end

function part_b(lines)
    local count = 0
    for _, ln in ipairs(lines) do
        local nums = list.string_numbers(ln)
        local result = calculate(nums[1], list.rest(nums), true)
        if result ~= nil then
            print(nums[1])
            count = count + nums[1]
        end
    end
    return count
end

print(part_b(filehelper.read_lines(arg[1])))
