list = import "list"

function blink(nums)
	for i, v in nums do
		if v == 0 then
			nums[i] = 1
		end
	end
end

function part_a(line)
	local nums = string_list(line, function (v) return tonumber(v) end)
end
