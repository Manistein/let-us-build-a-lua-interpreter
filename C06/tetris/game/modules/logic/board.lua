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

	self.grids = {}
	self:reset()

	render.log("board|init|success")
end

function board:draw()
	render.draw_box(self.x, self.y, self.width, self.height, -1) 

	for i = 1, const.BOARD_SIZE.X do 
		for j = 1, const.BOARD_SIZE.Y do 
			local grid = self.grids[i][j]
			if grid.is_occupied then
				local grid_x = i - 1 
				local grid_y = j - 1

				local x = grid_x * const.BOX_SIZE.WIDTH + GLOBAL_VAR.BOARD_X
				local y = grid_y * const.BOX_SIZE.HEIGHT + GLOBAL_VAR.BOARD_Y
				render.draw_box(x, y, const.BOX_SIZE.WIDTH, const.BOX_SIZE.HEIGHT, grid.color)
			end 
		end 
	end 	
end

function board:erase(row) 
	if row <= 0 then
		return 
	end 

	for i = row, 2, -1 do 
		for j = 1, const.BOARD_SIZE.X do 
			self.grids[j][i].is_occupied = self.grids[j][i - 1].is_occupied
			self.grids[j][i].color = self.grids[j][i - 1].color

			self.grids[j][i - 1].is_occupied = false
			self.grids[j][i - 1].color = 0
		end
	end
end

function board:try_erase()
	local erase_count = 0

	for row = 1, const.BOARD_SIZE.Y do 
		local occupy_count = 0
		for col = 1, const.BOARD_SIZE.X do 
			local grid = self.grids[col][row]
			if grid and grid.is_occupied then 
				occupy_count = occupy_count + 1
			end
		end 

		if occupy_count >= const.BOARD_SIZE.X then 
			self:erase(row)
			erase_count = erase_count + 1
		end 
	end 

	return erase_count
end

function board:occupy(x, y, vertexes, color)
	for idx, v in ipairs(vertexes) do 
		local gx = v.x + x 
		local gy = v.y + y

		-- game over
		if gy <= 0 then 
			return -1
		end

		local grid = self.grids[gx][gy]
		grid.is_occupied = true 
		grid.color = color
	end

	return self:try_erase()
end

function board:can_occupy(x, y, vertexes)
	local ret = false

	for idx, v in ipairs(vertexes) do 
		local gx = x + v.x
		local gy = y + v.y

		if gy >= const.BOARD_SIZE.Y then 
			ret = true
			break
		end 

		local grid = self.grids[gx][gy + 1]
		if grid and grid.is_occupied then 
			ret = true 
			break
		end
	end 

	return ret 
end

function board:can_fix(x, y, vertexes)
	local ret = true

	for idx, v in ipairs(vertexes) do 
		local gx = x + v.x 
		local gy = y + v.y 

		if gx <= 0 or gx > const.BOARD_SIZE.X then
			ret = false
			break
		end

		if gy > const.BOARD_SIZE.Y then 
			ret = false
			break
		end

		local grid = self.grids[gx][gy]
		if grid and grid.is_occupied then 
			ret = false
			break
		end
	end 

	return ret 
end

function board:try_fix(x, y, vertexes, board_pos)
	local center = {}
	center.x = x 
	center.y = y

	local max_move_times = -board_pos.left_most_x
	local shift_right = -1 
	for i = 0, max_move_times do 
		if self:can_fix(x + i, y, vertexes) then
			shift_right = i
			break
		end
	end 

	if shift_right >= 0 then 
		center.x = center.x + shift_right
		return center
	end 

	max_move_times = board_pos.right_most_x
	local shift_left = -1 
	for i = 0, max_move_times do 
		if self:can_fix(x - i, y, vertexes) then 
			shift_left = i
			break
		end
	end 

	if shift_left >= 0 then 
		center.x = center.x - shift_left
		return center
	end

	return nil
end

function board:reset()
	for i = 1, const.BOARD_SIZE.X do
		self.grids[i] = {}
		for j = 1, const.BOARD_SIZE.Y do 
			self.grids[i][j] = { color = 0, is_occupied = false }
		end
	end  
end

return board