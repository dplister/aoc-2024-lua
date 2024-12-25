mathext = require "mathext"
luaunit = require "luaunit"

function test_concat()
    luaunit.assertEquals(mathext.concat(12, 345), 12345)
    luaunit.assertEquals(mathext.concat(1, 0), 10)
    luaunit.assertEquals(mathext.concat(0, 1), 1)
end

os.exit(luaunit.LuaUnit.run())
