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