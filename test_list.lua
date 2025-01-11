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

function test_arrays_multiple_same_equal()
    luaunit.assertTrue(list.arrays_equal({ "a", "b", "a" }, { "b", "a", "a" }))
    luaunit.assertTrue(list.arrays_equal({ "a", "a", "b" }, { "b", "a", "a" }))
    luaunit.assertTrue(list.arrays_equal({ "a", "a", "b" }, { "a", "a", "b" }))
    luaunit.assertTrue(list.arrays_equal({ }, { }))
end

function test_arrays_multiple_same_not_equal()
    luaunit.assertFalse(list.arrays_equal({ "a", "b" }, { "a", "b", "a" }))
    luaunit.assertFalse(list.arrays_equal({ "a", "b", "a" }, { "a", "b" }))
    luaunit.assertFalse(list.arrays_equal({ "a", "b", "c" }, { "a", "b" }))
    luaunit.assertFalse(list.arrays_equal({ "a", "b" }, { "a", "b", "c" }))
    luaunit.assertFalse(list.arrays_equal({  }, { "a" }))
    luaunit.assertFalse(list.arrays_equal({ "a" }, { }))
end

function test_string_list()
    local tests = {
        "asdf",
        "",
        "1"
    }
    for _, v in ipairs(tests) do
        luaunit.assertEquals(table.concat(list.string_list(v)), v)
    end
end

function test_string_list_empty()
	luaunit.assertEquals(list.string_list(""), {})
end

function test_string_list_transform()
	local t = function (v) return tonumber(v) end
	luaunit.assertEquals(list.string_list("1234", t), { 1, 2, 3, 4 })
end

function test_string_list_transform_nils()
	local t = function (v) return tonumber(v) end
    luaunit.assertEquals(list.string_list("1.34", t), {1, nil, 3, 4})
end

function test_array_index_found()
    luaunit.assertEquals(list.array_index({ 4, 5, 6 }, 5), 2)
    luaunit.assertEquals(list.array_index({ 4, 5, 6 }, 4), 1)
end

function test_array_index_not_found()
    luaunit.assertEquals(list.array_index({ }, 2), -1)
    luaunit.assertEquals(list.array_index({ 1, 3 }, 2), -1)
end

function test_array_index_equals_found()
    local input_list = {
        { x=1, t="a" },
        { x=3, t="c" },
        { x=2, t="b" },
        { x=1, t="d" }
    }
    -- full match
    luaunit.assertEquals(list.array_index(input_list,
        { x=3, t="c" },
        function (a, b) 
            return a.x == b.x and a.t == b.t
        end), 2)
    -- partial match, first match
    luaunit.assertEquals(list.array_index(input_list,
        { x=1 },
        function (a, b)
            return a.x == b.x
        end), 1)
end

function test_array_index_equals_not_found()
    local input_list = {
        { x=1, t="a" },
        { x=3, t="c" },
        { x=2, t="b" },
        { x=1, t="d" }
    }
    -- full match
    luaunit.assertEquals(list.array_index(input_list,
        { x=4, t="c" },
        function (a, b) 
            return a.x == b.x and a.t == b.t
        end), -1)
    -- partial match
    luaunit.assertEquals(list.array_index(input_list,
        { x=4 },
        function (a, b)
            return a.x == b.x
        end), -1)
end

function test_filter()
    local elements = { 1, 2, 3, 4, 5 }
    luaunit.assertEquals(list.filter(elements, function (a) return a end), elements) -- identity
    luaunit.assertEquals(list.filter(elements, function (a) return a > 3 end), { 4, 5 })
end

function test_filter_no_matches()
    local elements = { 1, 2, 3, 4, 5 }
    luaunit.assertEquals(list.filter(elements, function (a) return a > 10 end), {})
end

function test_filter_no_f_param()
    local elements = { 1, 2, 3, 4, 5 }
    luaunit.assertEquals(list.filter(elements, function () return false end), {})
end

function test_filter_scoped()
    local elements = { 1, 2, 3, 4, 5 }
    local n = 0
    luaunit.assertEquals(list.filter(elements, function () 
        n = n + 1
        return n > 2
    end), { 3, 4, 5 })
end

function test_filter_no_elements()
    local elements = {}
    luaunit.assertEquals(list.filter(elements, function (a) return a > 10 end), {})
end

function test_map()
    local elements = { 1, 2, 3, 4, 5 }
    luaunit.assertEquals(list.map(elements, function (a) return a end), elements) -- identity
    luaunit.assertEquals(list.map(elements, function (a) return a + 1 end), { 2, 3, 4, 5, 6 })
end

function test_map_no_f_param()
    local elements = { 1, 2, 3, 4, 5 }
    luaunit.assertEquals(list.map(elements, function () return 1 end), { 1, 1, 1, 1, 1 })
end

function test_map_no_elements()
    local elements = { }
    luaunit.assertEquals(list.map(elements, function (a) return a + 1 end), { })
end

function test_string_numbers()
    luaunit.assertEquals(list.string_numbers("1 2 3"), {1, 2, 3})
    luaunit.assertEquals(list.string_numbers("1: 2, 3"), {1, 2, 3})
    luaunit.assertEquals(list.string_numbers("1:2,3!"), {1, 2, 3})
end

function test_string_numbers_empty()
    luaunit.assertEquals(list.string_numbers(""), {})
end

function test_rest()
    luaunit.assertEquals(list.rest({1, 2, 3}), {2, 3})
    luaunit.assertEquals(list.rest({1}), {})
end

function test_rest_empty()
    luaunit.assertEquals(list.rest({}), {})
end

function test_except()
    luaunit.assertEquals(list.except({1, 2, 3, 4, 5}, {3}), {1, 2, 4, 5})
    luaunit.assertEquals(list.except({1, 2, 3}, {1, 3}), {2})
end

function test_except_complex()
    luaunit.assertEquals(list.except(
    {
        { x=1, y=2 },
        { x=1, y=3 },
        { x=1, y=2 },
        { x=1, y=3 },
        { x=5, y=3 }
    },
    {
        { x=1, y=2 }
    },
    function(a, b) return a.x == b.x and a.y == b.y end),
    {
        { x=1, y=3 },
        { x=1, y=3 },
        { x=5, y=3 }
    })
end

function test_except_empty()
    luaunit.assertEquals(list.except({1, 2, 3}, {}), {1, 2, 3})
    luaunit.assertEquals(list.except({}, {1, 2, 3}), {})
end

function test_distinct()
    luaunit.assertEquals(list.distinct({1, 2, 3}), {1, 2, 3})
    luaunit.assertEquals(list.distinct({1, 2, 3, 2, 3, 1}), {1, 2, 3})
    luaunit.assertEquals(list.distinct({3, 3, 2, 1, 1, 2}), {3, 2, 1})
end

function test_distinct_complex()
    luaunit.assertEquals(list.distinct(
    {
        { x=1, y=2 },
        { x=1, y=3 },
        { x=1, y=2 },
        { x=1, y=3 },
        { x=5, y=3 }
    },
    function(a, b) return a.x == b.x and a.y == b.y end), 
    {
        { x=1, y=2 },
        { x=1, y=3 },
        { x=5, y=3 }
    })
end

function test_distinct_empty()
    luaunit.assertEquals(list.distinct({}), {})
end

function test_append()
	-- ordering test
	luaunit.assertEquals(list.append({ 1, 2, 3 }, { 4, 5 }), {1, 2, 3, 4, 5 })
	-- destructive test
	local initial = { 1, 2, 3 }
	local expected = { 1, 2, 3, 4, 5 }
	luaunit.assertEquals(list.append(initial, {4, 5}), expected)
	luaunit.assertEquals(initial, expected)
end

function test_append_empty()
	luaunit.assertEquals(list.append({1,2,3}, {}), {1,2,3})	
	luaunit.assertEquals(list.append({}, {4, 5}), {4,5})
end

function test_append_nil()
    local initial = nil
    local expected = { 1, 2, 3 }
    local updated = list.append(initial, { 1, 2, 3 })
    luaunit.assertNil(initial, expected)
    luaunit.assertEquals(updated, expected)
end

function test_fold_seed()
    -- sum
    luaunit.assertEquals(list.fold({1, 2, 3},
        function (total, current) return total + current end,
        0),
        6)
end

-- Handles a missing seed by checking within f
function test_fold_no_seed()
    -- max
    luaunit.assertEquals(list.fold({3, 1, 2},
        function (running, current) 
            if running == nil then return current end
            return running > current
                and running
                or current
        end),
        3)
end

os.exit(luaunit.LuaUnit.run())
