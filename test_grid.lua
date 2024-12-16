luaunit = require("luaunit")
grid = require("grid")

function test_create_small_grid()
    local g = grid.create({ "123", "456", "789" })
    luaunit.assertEquals(true)
end
