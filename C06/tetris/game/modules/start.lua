package.path = package.path .. "../?.lua;"
package.cpath = package.cpath .. "../../3rd/clibs/?.dll;"

local render = require("modules.core.render")
render.init()

local controller = require("modules.controller")

function __init__(w)
	__reset__()
	render.log("start|init|success")
end

function __reset__()
	render.log("start|reset|success")
end

function __exit__()
	render.log("start|exit|success")
end

function __loop__(delta)
end

function __move_up__()
	render.log("start|move up")
end

function __move_down__()
	render.log("start|move down")
end

function __move_left__()
	render.log("start|move left")
end

function __move_right__()
	render.log("start|move right")
end

function __escape__()
	render.log("start|key esc press")
end

function __key_enter__()
	__reset__()
	render.log("start|key enter press")
end

function __key_space__()
	render.log("start|key space press")
end

function __destroy__()
	render.log("start|destroy")
end
