package.path = package.path .. "../?.lua;"
package.cpath = package.cpath .. "../../3rd/clibs/?.dll;"

local d2d = require("d2d")

local background = require("modules.layers.background")

function __init__(w)
	d2d.init(w)
	d2d.error("call __init__ start")
	background.init()
	d2d.error("__init__")
end

function __loop__(delta)
	background.update(delta)
end

function __move_up__()
	d2d.error("__move_up__")
end

function __move_down__()
	d2d.error("__move_down__")
end

function __move_left__()
	d2d.error("__move_left__")
end

function __move_right__()
	d2d.error("__move_right__")
end

function __escape__()
	d2d.error("__escape__")
end

function __destroy__()
	background.destroy()
	d2d.error("__destroy__")
	d2d.destroy()
end
