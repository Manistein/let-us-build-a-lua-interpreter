local background = {}
local render = nil

function background.init(window)
	render = window 

	print("background.init")
end

function background.update(delta)
end 

function background.destroy()
	print("background.destroy")
end

return background