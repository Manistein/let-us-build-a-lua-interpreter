local render = require("modules.core.render")
local base = require("modules.logic.block.base")
local const  = require("modules.const")

local zshape = base:inherit()

function zshape:init()
	base.init(self)
	self.center_idx = 3
	self.type = const.BLOCK_TYPE.ZSHAPE

	if self:try_flip() then 
		self.vertexes = { 
			{x = -1, y = 0}, 
			{x = 0, y = 1}, 
			{x = 0, y = 0}, 
			{x = 1, y = 1},
		}
	else 
		self.vertexes = { 
			{x = -1, y = 1}, 
			{x = 0, y = 1}, 
			{x = 0, y = 0}, 
			{x = 1, y = 0},
		}
	end	 
end

return zshape