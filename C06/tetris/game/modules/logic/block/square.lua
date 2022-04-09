local render = require("modules.core.render")
local base = require("modules.logic.block.base")
local const  = require("modules.const")

local square = base:inherit()

function square:init()
	base.init(self)
	self.center_idx = 1 
	self.type = const.BLOCK_TYPE.SQUARE

	self.vertexes = { 
		{x = 0, y = 0}, 
		{x = 0, y = 1}, 
		{x = 1, y = 1}, 
		{x = 1, y = 0},
	}
end

function square:rotate90()
end

return square