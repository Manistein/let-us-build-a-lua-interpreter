local render = require("modules.core.render")
local object = require("modules.core.object")

local controller = object:inherit()

function controller:init()
	self.value = 1
	local vstr = tostring(self.value)
	render.log("controller object init" .. vstr)
end 

function controller:reset()
	render.log("controller object reset")
end

function controller:exit()
	render.log("controller object")
end

function controller:update(delta)
end

function controller:keypress(k)
	render.log("keypress " .. k)
end

function  controller:test_inc()
	self.value = self.value + 1
end

return controller