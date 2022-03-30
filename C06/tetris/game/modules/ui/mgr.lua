local render = require("modules.core.render")
local object = require("modules.core.object")
local score_class  = require("modules.ui.score")

local uimgr = object:inherit()

function uimgr:init()
	self.score = score_class:new()
	render.log("uimgr.init success")
end

function uimgr:reset()
	self.score:reset()
	render.log("uimgr.reset")
end

function uimgr:update_score(v)
	self.score:set_score()
	render.log("uimgr.update_score " .. tostring(v))
end

function uimgr:draw()
	self.score:draw()
end

return uimgr