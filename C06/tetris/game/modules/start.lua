print("hello world")
package.cpath = package.cpath .. "../../3rd/CLibs/?.dll"

local sdl_window = nil
local sdl_surface = nil
local sdlhelper = require("sdlhelper")
print(sdlhelper)

function init()
end

function loop(delta)
end

function uninit()
end

local function test()
	local window = sdlhelper.create_window("test", 640, 480)
	local surface = sdlhelper.get_surface(window)
	sdlhelper.fill_rect(surface, 0x00, 0xff, 0xff)
	sdlhelper.update_window_surface(window)
	sdlhelper.delay(2000)
	sdlhelper.destroy(window)
end

test()