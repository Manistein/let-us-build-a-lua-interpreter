-- simple class template
local class = {}

function class:inherit(o)
	o = o or {}
	o._is_class = true
	setmetatable(o, { __index = self })
	return o
end

return class