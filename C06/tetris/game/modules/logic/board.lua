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

	render.log("board|init|success")
end

function board:draw()
	render.draw_box(self.x, self.y, self.width, self.height, -1) 
end

return board