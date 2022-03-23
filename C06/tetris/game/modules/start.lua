print("hello world")
package.cpath = package.cpath .. "../../3rd/CLibs/?.dll"

local sdl_window = nil
local sdl_surface = nil
local sdlhelper = require("sdlhelper")
print(sdlhelper)

local KEY_TYPE = {
	ESC = 27,
}

function __init__()
	local window = sdlhelper.create_window("test", 640, 480)
	local surface = sdlhelper.get_surface(window)
	sdlhelper.fill_rect(surface, 0x00, 0xff, 0xff)
	sdlhelper.update_window_surface(window)

	print("__init__")
end

function __loop__(delta)
end

function __keypress__(type) 
	print(type)
	print(KEY_TYPE.ESC)
	print("__keypress__")
end

function __destroy__()
	sdlhelper.destroy(window)
	print("__destroy__")
end
