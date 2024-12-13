filehelper = {} 

function filehelper.read_lines(filename)
    local f = io.open(filename, "rb")
	assert(f)
	local data = {}
	for line in f:lines() do
		data[#data + 1] = line
    end
	f:close()
	return data
end
	
return filehelper
