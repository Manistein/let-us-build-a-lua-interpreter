local render = require("modules.core.render")
local object = require("modules.core.object")
local board_class = require("modules.logic.board")
local lshape_class = require("modules.logic.block.lshape")
local const = require("modules.const")

local blockmgr = object:inherit()

function blockmgr:init()
	self.board = board_class:new()

	self.current_shape = lshape_class:new()
	render.log("blockmgr|init|success")
end

function blockmgr:reset()
end

function blockmgr:draw()
	self.board:draw()
	self.current_shape:draw()
end

function blockmgr:key_event(event)
	render.log("blockmgr:key_event " .. tostring(event) .. " " .. tostring(const.KEY_EVENT.MOVE_LEFT))
	if event == const.KEY_EVENT.MOVE_LEFT then 
		self.current_shape:move_left(1)
		render.log("blockmgr:key_event move_left")
	elseif event == const.KEY_EVENT.MOVE_RIGHT then 
		self.current_shape:move_right(1)
	elseif event == const.KEY_EVENT.MOVE_UP then 
		self.current_shape:move_up(1)
	elseif event == const.KEY_EVENT.MOVE_DOWN then 
		self.current_shape:move_down(1)
	end	
end

return blockmgr