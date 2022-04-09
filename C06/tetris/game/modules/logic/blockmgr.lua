local render = require("modules.core.render")
local object = require("modules.core.object")
local board_class = require("modules.logic.board")
local lshape_class = require("modules.logic.block.lshape")
local square_class = require("modules.logic.block.square")
local stick_class = require("modules.logic.block.stick")
local tshape_class = require("modules.logic.block.tshape")
local zshape_class = require("modules.logic.block.zshape")
local const = require("modules.const")

local default_downward_gap = 1000 
local duration = 0

local blockmgr = object:inherit()

function blockmgr:init()
	self.board = board_class:new()
	self.game_status = const.GAME_STATUS.RUNNING
	self.downward_gap_by_millisecond = default_downward_gap 

	self:next_turn()	
	render.log("blockmgr|init|success")
end

function blockmgr:next_turn()
	if self.next_shape then 		
		self.current_shape = self.next_shape
	else
		self.current_shape = self:create_block()
		self.current_shape:random_rotate()
	end
	local vertexes = self.current_shape:get_vertexes()
	local boarder_pos = self.current_shape:get_border_pos(vertexes)
	self.current_shape:update_center(5, -boarder_pos.top_most_y)

	self.next_shape = self:create_block()
	self.next_shape:update_center(14, 6)
	self.next_shape:random_rotate()
end

function blockmgr:set_game_status(status)
	self.game_status = status
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
	self.board:reset()
	self:next_turn()
	self.game_status = const.GAME_STATUS.RUNNING
	self.downward_gap_by_millisecond = default_downward_gap 
end

function blockmgr:draw()
	render.draw_text(630, 0, "next block:")
	self.board:draw()
	self.current_shape:draw()
	self.next_shape:draw()
end

function blockmgr:key_event(event, for_ui_data)
	if self.game_status ~= const.GAME_STATUS.RUNNING then
		return 
	end

	local center_x, center_y = self.current_shape:get_center()
	local vertexes = self.current_shape:get_vertexes()
	local boarder_pos = self.current_shape:get_border_pos(vertexes)
	local is_rotate = false

	if event == const.KEY_EVENT.MOVE_LEFT then 
		center_x = center_x - 1
	elseif event == const.KEY_EVENT.MOVE_RIGHT then 
		center_x = center_x + 1
	elseif event == const.KEY_EVENT.MOVE_UP then 
		if self.current_shape:get_type() ~= const.BLOCK_TYPE.SQUARE then 
			vertexes = self.current_shape:gen_rotate90_vertexes()
			boarder_pos = self.current_shape:get_border_pos(vertexes)
			is_rotate = true
		end
	elseif event == const.KEY_EVENT.MOVE_DOWN then 
		center_y = center_y + 1
	end	

	local center = self.board:try_fix(center_x, center_y, vertexes, boarder_pos)
	if center then 
		self.current_shape:update_center(center.x, center.y)
		if is_rotate then 
			self.current_shape:set_vertexes(vertexes)
		end
	end

	local erase_count = self:try_occupy()
	if erase_count >= 0 then 
		for_ui_data.erase_count = for_ui_data.erase_count + erase_count
	end
end

function blockmgr:try_occupy()
	local center = self.current_shape:get_center_world_pos()
	local vertexes = self.current_shape:get_local_pos()

	if self.board:can_occupy(center.x, center.y, vertexes) then 
		local erase_count = self.board:occupy(center.x, center.y, vertexes, self.current_shape:get_color())
		if erase_count == -1 then 
			self.game_status = const.GAME_STATUS.GAME_OVER
		else 
			self:next_turn()
		end 

		return erase_count, true
	else
		return 0, false
	end	
end

function blockmgr:run_game(delta, for_ui_data)
	if duration >= self.downward_gap_by_millisecond then 
		local erase_count, can_occupy = self:try_occupy()

		if self.game_status == const.GAME_STATUS.RUNNING then  
			for_ui_data.erase_count = for_ui_data.erase_count + erase_count

			if not can_occupy then 
				self.current_shape:move_down(1)
			end
		end

		duration = 0
	end
	duration = duration + delta
end

function blockmgr:update(delta, for_ui_data)
	if self.game_status == const.GAME_STATUS.RUNNING then 
		self:run_game(delta, for_ui_data)
	end

	return self.game_status
end

function blockmgr:get_game_status()
	return self.game_status
end

function blockmgr:set_downward_gap(v)
	self.downward_gap_by_millisecond = v
end

return blockmgr