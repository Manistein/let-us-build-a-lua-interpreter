local render = require("modules.core.render")
local object = require("modules.core.object")

local score = object:inherit()

function score:init()
	self:reset()
	render.log("score|init|success")
end

function score:reset()
	self.value = 0
	self.x = 0
	self.y = 0
end

function score:set_score(v)
	self.value = v
end

function score:draw()
	local str = "score:" .. tostring(self.value)
	render.draw_text(self.x, self.y, str)
end

function score:get_downward_gap()
	if self.value <= 200 then 
		return 1000
	elseif self.value <= 500 then 
		return 800 
	elseif self.value <= 1000 then 
		return 600
	else
		return 400
	end
end

return score