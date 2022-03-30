local d2d = require("d2d")

local render = {}

function render.init(w)
	d2d.init(w)
end

function render.destroy()
	d2d.destroy()
end

function render.begin_draw()
	d2d.begin_draw()
end

function render.end_draw()
	d2d.end_draw()
end

function render.draw_box(x, y, width, height, color)
	d2d.draw_box(x, y, width, height, color)
end

function render.draw_text(x, y, text)
	d2d.draw_text(x, y, text)
end

function render.log(text)
	local str = tostring(text)
	d2d.error(str)
end

return render