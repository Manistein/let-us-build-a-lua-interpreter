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
	self.value = self.value + v
end

function score:draw()
	local str = "score:" .. tostring(self.value)
	render.draw_text(self.x, self.y, str)
end

return score