local render = require("modules.core.render")
local object = require("modules.core.object")
local const  = require("modules.const")

local base = object:inherit()

-- 局部坐标系，center是局部坐标系的原点
function base:init()
	self.center_x = 5 
	self.center_y = 10
	self.center_idx = 0
	self.vertexes = { {x = 0, y = 0}, {x = 0, y = 0}, {x = 0, y = 0}, {x = 0, y = 0} }	
	self.color = rand(const.BLOCK_COLOR.MAX_COLOR)
end

function base:draw()
	for k, v in pairs(self.vertexes) do 
		local grid_x = self.center_x + v.x 
		local grid_y = self.center_y + v.y

		local x = grid_x * const.BOX_SIZE.WIDTH + GLOBAL_VAR.BOARD_X
		local y = grid_y * const.BOX_SIZE.HEIGHT + GLOBAL_VAR.BOARD_Y

		render.draw_box(x, y, const.BOX_SIZE.WIDTH, const.BOX_SIZE.HEIGHT, self.color)
	end
end

function base:update_center(x, y)
	self.center_x = x
	self.center_y = y
end

function base:get_world_pos()
	local ret = {}

	for idx, v in ipairs(self.vertexes) do 
		ret[idx] = { self.center_x + v.x, self.center_y + v.y }
	end

	return ret
end

function base:move_left(x)
	self.center_x = self.center_x - x 
end

function base:move_right(x)
	self.center_x = self.center_x + x
end

function base:move_up(y)
	self.center_y = self.center_y - y
end

function base:move_down(y)
	self.center_y = self.center_y + y
end

function base:destroy()
end

function base:try_flip()
	local t = rand(2)
	if t == const.FLIP_TYPE.NORMAL then 
		return false
	else
		return true
	end
end

function base:rotate90()
	for idx, v in ipairs(self.vertexes) do 
		local rotate_x = v.y 
		local rotate_y = -v.x

		self.vertexes[idx].x = rotate_x
		self.vertexes[idx].y = rotate_y
	end
end

return base