local d2d = require("d2d")
local background = {}

function background.init()
	d2d.error("background.init")
end

function background.update(delta)
	d2d.begin_draw()
	d2d.draw_box(0, 0, 30, 30, 2)
	d2d.draw_box(50, 50, 50, 50, 3)
	d2d.draw_text(100, 100, "Hello World")
	d2d.end_draw()
end 

function background.destroy()
	d2d.error("background.destroy")
end

return background