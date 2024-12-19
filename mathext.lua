mathext = {}

function mathext.sign(v)
	return (v >= 0 and 1) or -1
end

function mathext.round(v, bracket)
	bracket = bracket or 1
	return math.floor(v/bracket + mathext.sign(v) * 0.5) * bracket
end

return mathext
