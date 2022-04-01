local render = require("modules.core.render")
local base = require("modules.logic.block.base")
local const  = require("modules.const")

local lshape = base:inherit()

function lshape:init()
	base.init(self)
	self.shape = {
		{ 0, 2 },
		{ 0, 1 },
		{ 0, 0 },
		{ 0, -1 },
	}
end

return lshape