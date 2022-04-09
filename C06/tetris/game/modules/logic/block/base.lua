local render = require("modules.core.render")
local object = require("modules.core.object")
local const  = require("modules.const")

local base = object:inherit()

-- 局部坐标系，center是局部坐标系的世界坐标
function base:init()
	self.center_x = 1 
	self.center_y = 1

	self.vertexes = { {x = 0, y = 0}, {x = 0, y = 0}, {x = 0, y = 0}, {x = 0, y = 0} }	
	self.color = rand(const.BLOCK_COLOR.MAX_COLOR)
	self.center_idx = 0
end

function base:get_type()
	return self.type
end

function base:get_color()
	return self.color
end

function base:random_rotate()
	local rotate_num = rand(const.MAX_ROTATE)
	for i = 1, rotate_num do 
		self:rotate90()
	end
end

function base:print_vertexes()
	for idx, v in ipairs(self.vertexes) do 
		render.log(tostring(v.x) .. " " .. tostring(v.y))
	end 
end

function base:draw()
	for k, v in pairs(self.vertexes) do 
		local grid_x = self.center_x + v.x - 1 
		local grid_y = self.center_y + v.y - 1

		local x = grid_x * const.BOX_SIZE.WIDTH + GLOBAL_VAR.BOARD_X
		local y = grid_y * const.BOX_SIZE.HEIGHT + GLOBAL_VAR.BOARD_Y

		render.draw_box(x, y, const.BOX_SIZE.WIDTH, const.BOX_SIZE.HEIGHT, self.color)
	end
end

function base:update_center(x, y)
	self.center_x = x
	self.center_y = y
end

function base:get_border_pos(vertexes)
	local vertex = vertexes[1]

	local ret = {}
	ret.left_most_x = vertex.x
	ret.right_most_x = vertex.x
	ret.top_most_y = vertex.y 
	ret.down_most_y = vertex.y

	for idx, v in ipairs(vertexes) do 
		if v.x < ret.left_most_x then 
			ret.left_most_x = v.x
		end 

		if v.x > ret.right_most_x then 
			ret.right_most_x = v.x 
		end 

		if v.y > ret.top_most_y then 
			ret.top_most_y = v.y 
		end 

		if v.y < ret.down_most_y then 
			ret.down_most_y = v.y 
		end 
	end

	return ret
end

function base:get_world_pos()
	local wpos = {}

	for idx, v in ipairs(self.vertexes) do 
		wpos[idx] = {}
		wpos[idx].x = v.x + self.center_x
		wpos[idx].y = v.y + self.center_y
	end 

	return wpos
end

function base:get_local_pos()
	return self.vertexes
end

function base:get_center_world_pos()
	local ret = {}
	local ver = self.vertexes[self.center_idx]

	ret.x = self.center_x + ver.x
	ret.y = self.center_y + ver.y

	return ret 
end

function base:get_center()
	return self.center_x, self.center_y
end

function base:move_down(y)
	local pos = self.center_y + y
	local ret = self:get_border_pos(self.vertexes)
	local upmost = ret.top_most_y + pos

	if upmost <= const.BOARD_SIZE.Y then
		self.center_y = pos 
	end
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

function base:gen_rotate90_vertexes()
	local ret = {}
	for idx, v in ipairs(self.vertexes) do 
		local rotate_x = v.y 
		local rotate_y = -v.x

		ret[idx] = {}
		ret[idx].x = rotate_x
		ret[idx].y = rotate_y
	end
	return ret
end

function base:rotate90()
	self.vertexes = self:gen_rotate90_vertexes()
end

function base:set_vertexes(vertexes)
	self.vertexes = vertexes
end

function base:get_vertexes()
	return self.vertexes
end

return base