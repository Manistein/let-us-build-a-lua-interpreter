package.path = package.path .. "../?.lua;"
package.cpath = package.cpath .. "../../3rd/clibs/?.dll;"

local render = require("modules.core.render")
render.init()

local controller = require("modules.controller")

function __init__(w)
	render.log("xxxxyyyyy")
	local a1, a2 = tostring(10)
	render.log(a1)
	render.log(a2)
end

function __loop__(delta)
end

function __move_up__()
end

function __move_down__()
end

function __move_left__()
end

function __move_right__()
end

function __escape__()
end

function __destroy__()
end
