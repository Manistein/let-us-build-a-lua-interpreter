local background = {}
local render = nil

function background.init(surface)
	render = surface

	print("background.init")
end

function background.update(delta)
	print("background.update", delta)
end 

function background.destroy()
	print("background.destroy")
end

return background