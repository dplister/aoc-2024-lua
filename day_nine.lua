local filehelper = require "filehelper"
local list = require "list"
local inspect = require "inspect"

function parse(line)
    local ls = list.string_list(line)
    local ns = list.map(ls, tonumber)
    return ns
end

function blocks(ns)
    local result = {}
    local id = 0
    local is_file = true
    for _, v in ipairs(ns) do
        for i=1, v do
            if is_file then
                result[#result + 1] = id
            else
                result[#result + 1] = "."
            end
        end
        if is_file then
            id = id + 1
        end
        is_file = not is_file
    end
    return result
end

function compress(blocks)
    local start_index = 1
    local end_index = #blocks
    while start_index < end_index do
        if blocks[end_index] == "." then
            -- shift end index left
            end_index = end_index - 1
        elseif blocks[start_index] == "." then
            -- sub with number at end index
            blocks[start_index] = blocks[end_index]
            blocks[end_index] = "."
            -- shift start index right
            start_index = start_index + 1
        else
            -- shift start index right to find next empty spot
            start_index = start_index + 1
        end
    end
    return blocks
end

function checksum(blocks)
    local result = 0
    for i, v in ipairs(blocks) do
        if v ~= "." then
            result = result + ((i - 1) * v)
        end
    end
    return result
end

function part_a(line)
    local ns = parse(line)
    local bs = blocks(ns)
    bs = compress(bs)
    print(table.concat(bs, ""))
    return checksum(bs)
end

--print(part_a("12345"))
print(part_a(filehelper.read_all(arg[1])))
