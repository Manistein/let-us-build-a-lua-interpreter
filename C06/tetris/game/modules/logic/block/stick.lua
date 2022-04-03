local render = require("modules.core.render")
local base = require("modules.logic.block.base")
local const  = require("modules.const")

local stick = base:inherit()

function stick:init()
	base.init(self)

	self.vertexes = { 
		{x = 0, y = -2}, 
		{x = 0, y = -1}, 
		{x = 0, y = 0}, 
		{x = 0, y = 1},
	}
end

return stick