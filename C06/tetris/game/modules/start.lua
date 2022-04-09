package.path = package.path .. "../?.lua;"
package.cpath = package.cpath .. "../../3rd/clibs/?.dll;"

local const = require("modules.const")
local render = require("modules.core.render")

local ctrl_class = require("modules.controller")
local controller = nil 

GLOBAL_VAR = {}

function __init__(hwnd, width, height)
	srand()

	render.init(hwnd)
	render.log("__init__ " .. tostring(width) .. " " .. tostring(height))

	GLOBAL_VAR.SCREEN_WIDTH = width
	GLOBAL_VAR.SCREEN_HEIGHT = height

	controller = ctrl_class:new()
	__reset__()
	render.log("start|init|success")
end

function __reset__()
	controller:reset()
	render.log("start|reset|success")
end

function __exit__()
	render.log("start|exit|success")
end

function __loop__(delta)
	controller:update(delta)
end

function __move_up__()
	controller:key_event(const.KEY_EVENT.MOVE_UP)
	render.log("start|move up")
end

function __move_down__()
	controller:key_event(const.KEY_EVENT.MOVE_DOWN)
	render.log("start|move down")
end

function __move_left__()
	controller:key_event(const.KEY_EVENT.MOVE_LEFT)
	render.log("start|move left")
end

function __move_right__()
	controller:key_event(const.KEY_EVENT.MOVE_RIGHT)
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
	controller:toggle_pause()
	render.log("start|key space press")
end

function __destroy__()
	render.log("start|destroy")
end
