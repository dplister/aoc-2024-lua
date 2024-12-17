luaunit = require("luaunit")
grid = require("grid")

function test_create_small_grid()
    local g = grid.create({ "123", "456", "789" })
    local expected = {{ 1, 1, "1" }, {3, 2, "6" }, {2, 1, "2"} }
    for _, v in ipairs(expected) do
        luaunit.assertEquals(v[3], g[v[2]][v[1]])
    end
end

function test_output_small()
    local g = grid.create({ "12", "34" })
    local expected = [[12
34]]
    local result = grid.output(g)
    luaunit.assertEquals(expected, result)
end

function test_project_diagonal()
    local g = grid.create({"123", "456", "789"})
    local expected = { "5", "9" }
    local result = grid.project(g, 2, 2, 1, 1, 2)
    luaunit.assertEquals(expected, result)
end

function test_project_backward()
    local g = grid.create({"123", "456", "789"})
    local expected = { "3", "2", "1" }
    local result = grid.project(g, 3, 1, -1, 0, 3)
    luaunit.assertEquals(expected, result)
end

function test_project_out_of_bound()
    local g = grid.create({"123", "456", "789"})
    local expected = { "6" }
    local result = grid.project(g, 3, 2, 1, 0, 3)
    luaunit.assertEquals(expected, result)
end

function test_in_bounds()
    local g = grid.create({"123", "456", "789"})
    local inputs = { 
        { 0, 1, false }, 
        { 1, 1, true }, 
        { -1, 1, false}, 
        { 4, 2, false }, 
        { 3, 3, true } 
    }
    for _, v in ipairs(inputs) do
        luaunit.assertEquals(v[3], grid.in_bounds(g, v[1], v[2]))
    end
end

os.exit(luaunit.LuaUnit.run())
