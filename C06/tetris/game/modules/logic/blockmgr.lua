local render = require("modules.core.render")
local object = require("modules.core.object")
local board_class = require("modules.logic.board")

local blockmgr = object:inherit()

function blockmgr:init()
	self.board = board_class:new()
	render.log("blockmgr|init|success")
end

function blockmgr:reset()
end

function blockmgr:draw()
	self.board:draw()
end

return blockmgr