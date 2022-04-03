local render = require("modules.core.render")
local object = require("modules.core.object")
local board_class = require("modules.logic.board")
local lshape_class = require("modules.logic.block.lshape")
local square_class = require("modules.logic.block.square")
local stick_class = require("modules.logic.block.stick")
local tshape_class = require("modules.logic.block.tshape")
local zshape_class = require("modules.logic.block.zshape")
local const = require("modules.const")

local blockmgr = object:inherit()

function blockmgr:init()
	self.board = board_class:new()

	self:next_turn()	
	render.log("blockmgr|init|success")
end

function blockmgr:next_turn()
	self.current_shape = self:create_block()
	self.current_shape:update_center(4, 0)
	self.current_shape:random_rotate()

	self.next_shape = self:create_block()
	self.next_shape:update_center(13, 5)
	self.next_shape:random_rotate()
end

function blockmgr:create_block()
	local block_type = rand(const.BLOCK_TYPE.TOTAL)
	if block_type == const.BLOCK_TYPE.LSHAPE then 
		return lshape_class:new()
	elseif block_type == const.BLOCK_TYPE.SQUARE then 
		return square_class:new()
	elseif block_type == const.BLOCK_TYPE.STICK then 
		return stick_class:new()
	elseif block_type == const.BLOCK_TYPE.TSHAPE then 
		return tshape_class:new()
	else
		return zshape_class:new()
	end
end

function blockmgr:reset()
end

function blockmgr:draw()
	render.draw_text(740, 0, "next block:")
	self.board:draw()
	self.current_shape:draw()
	self.next_shape:draw()
end

function blockmgr:key_event(event)
	if event == const.KEY_EVENT.MOVE_LEFT then 
		self.current_shape:move_left(1)
	elseif event == const.KEY_EVENT.MOVE_RIGHT then 
		self.current_shape:move_right(1)
	elseif event == const.KEY_EVENT.MOVE_UP then 
		self.current_shape:rotate90()
	elseif event == const.KEY_EVENT.MOVE_DOWN then 
		self.current_shape:move_down(1)
	end	
end

return blockmgr