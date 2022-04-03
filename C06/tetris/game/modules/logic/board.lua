local render = require("modules.core.render")
local object = require("modules.core.object")
local const = require("modules.const")

local board = object:inherit()

function board:init()
	self.width = const.BOX_SIZE.WIDTH * const.BOARD_SIZE.X
	self.height = const.BOX_SIZE.HEIGHT * const.BOARD_SIZE.Y

	self.x = (GLOBAL_VAR.SCREEN_WIDTH - self.width) / 2 
	self.y = 0 

	GLOBAL_VAR.BOARD_X = self.x 
	GLOBAL_VAR.BOARD_Y = self.y

	-- self.grids = {}
	-- for i = 1, const.BOARD_SIZE.Y do
	-- 	self.grids[i] = {}
	-- 	for j = 1, const.BOARD_SIZE.X do 
	-- 		self.grids[i][j] = { color = 0, is_occupied = false }
	-- 	end 
	-- end  

	render.log("board|init|success")
end

function board:draw()
	render.draw_box(self.x, self.y, self.width, self.height, -1) 
end

function board:occupy(x, y, color)
	local grid = self.grids[x - 1][y - 1]
	grid.is_occupied = true 
	grid.color = color	
end

return board