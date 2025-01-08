mathext = {}

function mathext.sign(v)
	return (v >= 0 and 1) or -1
end

function mathext.round(v, bracket)
	bracket = bracket or 1
	return math.floor(v/bracket + mathext.sign(v) * 0.5) * bracket
end

--[[
	Concatenates the digits of the first number to the second.
	i.e. mathext.concat(12, 34) -> 1234
]]--
function mathext.concat(a, b)
    return tonumber (a .. b)
end

--[[
	Retrieves the amount of digits in a number.
]]--
function mathext.digits(n)
	if n < 0 then
		n = n * -1
	end
	return #(tostring(n))
end

--[[
	Splits the set of digits into two numbers.
	i.e. mathext.split_digits(1234) -> 12, 34
]]--
function mathext.split_digits(n)
	local sgn = mathext.sign(n)
	n = n * sgn
	if n < 10 then -- insufficient digits
		return 0, (sgn * n)
	end
	local nmstr = tostring(n)
	local hlf = #nmstr / 2
	return 
		sgn * tonumber(string.sub(nmstr, 1, hlf)),
		sgn * tonumber(string.sub(nmstr, hlf + 1, #nmstr))
end

return mathext
