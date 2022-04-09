local render = require("modules.core.render")
local base = require("modules.logic.block.base")
local const  = require("modules.const")

render.log("lshape class " .. tostring(base))
local lshape = base:inherit()

function lshape:init()
	base.init(self)
	self.center_idx = 3 
	self.type = const.BLOCK_TYPE.LSHAPE

	if self:try_flip() then 
		self.vertexes = { 
			{x = 0, y = 2}, 
			{x = 0, y = 1}, 
			{x = 0, y = 0}, 
			{x = 1, y = 0},
		}
	else 
		self.vertexes = { 
			{x = 0, y = 2}, 
			{x = 0, y = 1}, 
			{x = 0, y = 0}, 
			{x = -1, y = 0},
		}
	end	 
end

return lshape