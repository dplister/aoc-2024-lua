luaunit = require("luaunit")
matching = require("matching")
inspect = require("inspect")

function test_single_match()
    local ptn = matching.multi_pattern("1234", { "(%d+)" })
    luaunit.assertEquals(ptn[1].capture, "1234")
    luaunit.assertEquals(ptn[1].index, 1)
    luaunit.assertEquals(ptn[1].pattern, "(%d+)")
end

function test_multiple_matches()
    local ptn = matching.multi_pattern("1234 5678", { "(%d+)" })
    luaunit.assertEquals(ptn[1].capture, "1234")
    luaunit.assertEquals(ptn[1].index, 1)
    luaunit.assertEquals(ptn[1].pattern, "(%d+)")
    luaunit.assertEquals(ptn[2].capture, "5678")
    luaunit.assertEquals(ptn[2].index, 6)
    luaunit.assertEquals(ptn[2].pattern, "(%d+)")
end

function test_multiple_patterns_once()
    local ptn = matching.multi_pattern("1234 abcd", { "(%d+)", "(%a+)" })
    luaunit.assertEquals(ptn[1].capture, "1234")
    luaunit.assertEquals(ptn[1].index, 1)
    luaunit.assertEquals(ptn[1].pattern, "(%d+)")
    luaunit.assertEquals(ptn[2].capture, "abcd")
    luaunit.assertEquals(ptn[2].index, 6)
    luaunit.assertEquals(ptn[2].pattern, "(%a+)")
end

function test_multiple_patterns_index_order()
    local ptn = matching.multi_pattern("abcd 1234", { "(%d+)", "(%a+)" })
    luaunit.assertEquals(ptn[1].capture, "abcd")
    luaunit.assertEquals(ptn[1].index, 1)
    luaunit.assertEquals(ptn[1].pattern, "(%a+)")
    luaunit.assertEquals(ptn[2].capture, "1234")
    luaunit.assertEquals(ptn[2].index, 6)
    luaunit.assertEquals(ptn[2].pattern, "(%d+)")
end

function test_multiple_patterns_pattern_order()
    local ptn = matching.multi_pattern("abcd", { "(%a+)", "(%w+)" })
    luaunit.assertEquals(ptn[1].capture, "abcd")
    luaunit.assertEquals(ptn[1].index, 1)
    luaunit.assertEquals(ptn[1].pattern, "(%a+)")
    luaunit.assertEquals(ptn[2].capture, "abcd")
    luaunit.assertEquals(ptn[2].index, 1)
    luaunit.assertEquals(ptn[2].pattern, "(%w+)")
end

function test_multiple_patterns_multiple_matches()
    local ptn = matching.multi_pattern("abc 123 def 456", { "(%a+)", "(%d+)" })
    local expected = { 
        { index = 1, capture = "abc", pattern = "(%a+)" },
        { index = 5, capture = "123", pattern = "(%d+)" },
        { index = 9, capture = "def", pattern = "(%a+)" },
        { index = 13, capture = "456", pattern = "(%d+)" }
    }
    luaunit.assertEquals(#expected, #ptn)
    for i, v in ipairs(ptn) do
        luaunit.assertEquals(v.capture, expected[i].capture)
        luaunit.assertEquals(v.index, expected[i].index)
        luaunit.assertEquals(v.pattern, expected[i].pattern)
    end
end

os.exit(luaunit.LuaUnit.run())
