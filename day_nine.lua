local filehelper = require "filehelper"
local list = require "list"
local inspect = require "inspect"

function parse(line)
    local ls = list.string_list(line)
    local ns = list.map(ls, tonumber)
    return ns
end

-- part A

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

-- Part B

--[[
    Notifies callbacks of blocks detected.
    Uses a callbacks to detect free / not free.
]]--
function collect_blocks(blocks, free_detected, use_detected)
    local index = 1
    while index < #blocks do
        local kind = blocks[index]
        local starting = index
        -- collect until we have reached end of range (or end of blocks, which is nil)
        while blocks[index] == kind do
            index = index + 1
        end
        local distance = index - starting
        if kind == "." then
            free_detected(starting, distance, kind)
        else
            use_detected(starting, distance, kind)
        end
    end
end

--[[
    Tracks sectors as a linked list
]]--
function sector_detected()
    local first = nil
    local last = nil
    return 
        function ()
            return first
        end, 
        function (starting, distance, kind)
            local node = { index = starting, length = distance, kind = kind, next_node = nil, previous_node = last }
            if last == nil then
                last = node
                first = node
            else
                last.next_node = node
                last = node
            end
        end
end

--[[
    Compresses linked lists of free / used.
]]--
function compress_sectors(free_sectors, used_sectors)
    local first_free = free_sectors
    local first_used = used_sectors
    -- start at the end of used
    local last_used = used_sectors
    while last_used.next_node ~= nil do
        last_used = last_used.next_node
    end
    while last_used.previous_node ~= nil do
        print("Used Index: " .. last_used.index .. " Length: " .. last_used.length .. " Kind: " .. last_used.kind)
        local node = first_free
        while node ~= nil -- must have free space options left
            and node.index < last_used.index -- must be further left than current position
            and node.length < last_used.length -- must fit
        do
            node = node.next_node
        end
        -- found a valid position
        if node ~= nil and node.index < last_used.index then
            node.length = node.length - last_used.length
            last_used.index = node.index
            print("Moved to: " .. node.index)
            print("Free space shortened to: " .. node.length)
            -- bump the index to its new shorter position
            if node.length > 0 then
                node.index = node.index + last_used.length
                print("Free space now starts at: " .. node.index)
            else
                -- ran out of space, kill off node
                if node.previous_node ~= nil then
                    node.previous_node.next_node = node.next_node
                else
                    -- first node has changed (unlikely due to first sector always being a file)
                    first_free = node.next_node
                end
                if node.next_node ~= nil then
                    node.next_node.previous_node = node.previous_node
                end
            end
        end
        last_used = last_used.previous_node
    end
    return first_used
end

function print_nodes(node)
    while node ~= nil do
        print("i: " .. node.index .. " l: " .. node.length .. " k: " .. node.kind)
        node = node.next_node
    end
end

function format_sectors(used_sectors)
    local blocks = {}
    local max_index = 1
    local node = used_sectors
    while node ~= nil do
        for i=node.index,(node.index + node.length - 1) do
            blocks[i] = node.kind
        end
        max_index = node.index > max_index and node.index or max_index
        node = node.next_node
    end
    -- go through and un-nil all empty sectors
    for i=1,max_index do
        if blocks[i] == nil then
            blocks[i] = "."
        end
    end
    return blocks
end

function checksum_nodes(node)
    local result = 0
    while node ~= nil do
        for i=node.index,(node.index + node.length - 1) do
            result = result + ((i - 1) * node.kind)
        end
        node = node.next_node
    end
    return result
end

-- callers

function part_a(line)
    local ns = parse(line)
    local bs = blocks(ns)
    bs = compress(bs)
    print(table.concat(bs, ""))
    return checksum(bs)
end

function part_b(line)
    local ns = parse(line)
    local bs = blocks(ns)
    -- print(table.concat(bs, ""))
    local free_ret, free_det = sector_detected()
    local use_ret, use_det = sector_detected()
    collect_blocks(bs, free_det, use_det)
    -- before
    local blocks = format_sectors(free_ret(), use_ret())
    print(table.concat(blocks, ""))
    -- after
    local use_bl = compress_sectors(free_ret(), use_ret())
    print("Used")
    print_nodes(use_bl)
    blocks = format_sectors(use_bl)
    print(table.concat(blocks, ""))
    print(checksum_nodes(use_bl))
    return 0
end

--print(part_b("2333133121414131402"))
print(part_b(filehelper.read_all(arg[1])))
