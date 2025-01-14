local filehelper = require "filehelper"
local list = require "list"
local mathext = require "mathext"

function parse_xy(line)
    local ls = list.string_numbers(line)
    return { x = ls[1], y = ls[2] }
end

function parse_games(lines)
    local games = {}
    for start=1,#lines,4 do
        games[#games + 1] = {
            button_a = parse_xy(lines[start]),
            button_b = parse_xy(lines[start + 1]),
            prize = parse_xy(lines[start + 2])
        }
    end
    return games
end

function prize_achieved(game, a_presses, b_presses)
    local x = (a_presses * game.button_a.x) + (b_presses * game.button_b.x)
    local y = (a_presses * game.button_a.y) + (b_presses * game.button_b.y)
    return game.prize.x == x
        and game.prize.y == y
end

function count_tokens(game, max_count)
    if max_count == nil then max_count = 100 end
    local a_presses = 0
    local b_presses = max_count
    local cost_options = {}
    -- set maximum for b_press (can't exceed prize by itself)
    b_presses = math.min(math.floor(game.prize.x / game.button_b.x),
            math.floor(game.prize.y / game.button_b.y))
    for b=b_presses,0,-1 do
        -- print("Trying b: " .. b .. " x: (" .. b .. "*" .. game.button_b.x .. ") " .. (b * game.button_b.x) .. " y: (" .. b .. "*" .. game.button_b.y .. ") " .. (b * game.button_b.y))
        local remaining_x = game.prize.x - (b * game.button_b.x)
        local remaining_y = game.prize.y - (b * game.button_b.y)
        -- print("Remaining x: " .. remaining_x .. " y: " .. remaining_y)
        local apx = mathext.round(remaining_x / game.button_a.x)
        local apy = mathext.round(remaining_y / game.button_a.y)
        -- print("apx: " .. apx .. " apy: " .. apy)
        if apx == apy -- needs to be the same amount of presses
            and apx <= max_count
            and prize_achieved(game, apx, b) then
            print("A Presses: " .. apx .. " B Presses: " .. b)
            cost_options[#cost_options + 1] = { a = apx, b = b, cost = b + (apx * 3) }
        end
    end
    -- find the cheapest option
    if #cost_options == 0 then return nil end
    local cheapest = cost_options[1]
    for i=2,#cost_options do
        cheapest = cost_options[i].cost < cheapest.cost and cost_options[i] or cheapest
    end
    print("Cheapest - a:" .. cheapest.a .. " b: " .. cheapest.b)
    return cheapest.cost
end

function part_a(lines)
    local total_tokens = 0
    local games = parse_games(lines)
    for _, g in ipairs(games) do
        print("Button A x: " .. g.button_a.x .. " y: " .. g.button_a.y)
        print("Button B x: " .. g.button_b.x .. " y: " .. g.button_b.y)
        print("Prize x: " .. g.prize.x .. " y: " .. g.prize.y)
        local tokens = count_tokens(g) or 0
        print("Tokens: " .. tokens)
        total_tokens = total_tokens + tokens
    end
    return total_tokens
end

local filename = arg[1]
assert(filename ~= nil and #filename > 0, "First argument must be a filename")
print(part_a(filehelper.read_lines(filename)))
