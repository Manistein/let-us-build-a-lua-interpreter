print("test module")
local module = {}

function module.hello()
	print("module.hello")
end 

function module.world()
	print("module.world")
end

return module