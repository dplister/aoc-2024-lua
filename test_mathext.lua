mathext = require "mathext"
luaunit = require "luaunit"

function test_concat()
    luaunit.assertEquals(mathext.concat(12, 345), 12345)
    luaunit.assertEquals(mathext.concat(1, 0), 10)
    luaunit.assertEquals(mathext.concat(0, 1), 1)
end

function test_digits()
	luaunit.assertEquals(mathext.digits(0), 1)
	luaunit.assertEquals(mathext.digits(1), 1)
	luaunit.assertEquals(mathext.digits(34), 2)
	luaunit.assertEquals(mathext.digits(-1), 1)
	luaunit.assertEquals(mathext.digits(345), 3)
end

function test_split_digits()
	local tt = {
		{ 12, 1, 2 },
		{ 1234, 12, 34 },
		-- insufficient digits
		{ 1, 0, 1 },
		-- odd numbers
		{ 123, 1, 23 },
		{ 12345, 12, 345 },
		-- negatives
		{ -12, -1, -2 },
		{ -1, 0, -1 }
	}
	for _, v in ipairs(tt) do
		local l, r = mathext.split_digits(v[1])
		luaunit.assertEquals({l, r}, { v[2], v[3] })
	end
end

os.exit(luaunit.LuaUnit.run())
