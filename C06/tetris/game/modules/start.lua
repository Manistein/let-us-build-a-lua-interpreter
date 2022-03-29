package.path = package.path .. "../?.lua;"
package.cpath = package.cpath .. "../../3rd/clibs/?.dll;"

local render = require("modules.core.render")
render.init()

local controller = require("modules.controller")

local test_c1 = nil
local test_c2 = nil

function __init__(w)
	test_c1 = controller:new()
	test_c2 = controller:new()

	test_c1:test_inc()

	local txt_t1 = tostring(test_c1.value)
	render.log("test_c1 value " .. txt_t1)

	local txt_t2 = tostring(test_c2.value)
	render.log("test_c2 value " .. txt_t2)
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
