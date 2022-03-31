local render = require("modules.core.render")
local object = require("modules.core.object")

local tips = object:inherit()

function tips:init()
	self.x = 0
	self.y = 100
	self.text = "key press tips:\nw:rotate\ns:speedup\na:move to left\nd:move to right\nesc:exit game\nspace:pause/resume\nenter:restart"
end

function tips:draw()
	render.draw_text(self.x, self.y, self.text)
end

return tips