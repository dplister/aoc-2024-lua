luaunit = require("luaunit")
list = require("list")

function test_arrays_equal_diff_length()
    luaunit.assertFalse(list.arrays_equal({ 1 }, { 1, 2 }))
end

function test_arrays_equal_identical_order()
    luaunit.assertTrue(list.arrays_equal({ 1, 2 }, { 1, 2 }))
end

function test_arrays_equal_different_order()
    luaunit.assertTrue(list.arrays_equal({ 2, 1 }, { 1, 2 }))
end

function test_arrays_equal_strings()
    luaunit.assertTrue(list.arrays_equal({ "a", "c" }, { "c", "a" }))
end

function test_string_list()
    local tests = {
        "asdf",
        "",
        "1"
    }
    for _, v in ipairs(tests) do
        luaunit.assertEquals(v, table.concat(list.string_list(v)))
    end
end

os.exit(luaunit.LuaUnit.run())
