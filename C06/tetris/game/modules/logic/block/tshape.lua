local render = require("modules.core.render")
local base = require("modules.logic.block.base")
local const  = require("modules.const")

local tshape = base:inherit()

function tshape:init()
	base.init(self)
	self.center_idx = 2
	self.type = const.BLOCK_TYPE.TSHAPE

	self.vertexes = { 
		{x = -1, y = 0}, 
		{x = 0, y = 0}, 
		{x = 1, y = 0}, 
		{x = 0, y = 1},
	}
end

return tshape