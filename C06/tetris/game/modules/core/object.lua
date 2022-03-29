local render = require("modules.core.render")
local class = require("modules.core.class")
local object = class:inherit()

function object:new()
	local o = {}
	setmetatable(o, { __index = self })

	if o.init then 
		o:init()
	end

	return o
end

function object:draw()
end

function object:release()
	for k, v in pairs(self) do 
		self[k] = nil
	end 
end

return object