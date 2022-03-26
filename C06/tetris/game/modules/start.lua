print("hello world")
package.path = package.path .. "../?.lua;"
package.cpath = package.cpath .. "../../3rd/CLibs/?.dll;"

local background = require("modules.layers.background")
local window = nil

function __init__(w)
	print("call __init__ start")
	window = w
	background.init(w)
	print("__init__")
end

function __loop__(delta)
	print("call __loop__ start")
	background.update(delta)
end

function __move_up__()
	print("__move_up__")
end

function __move_down__()
	print("__move_down__")
end

function __move_left__()
	print("__move_left__")
end

function __move_right__()
	print("__move_right__")
end

function __escape__()
	print("__escape__")
end

function __destroy__()
	background.destroy()
	print("__destroy__")
end
