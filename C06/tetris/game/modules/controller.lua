local render = require("modules.core.render")
local uimgrclass  = require("modules.ui.mgr")
local blockmgr_class = require("modules.logic.blockmgr")

local object = require("modules.core.object")
local controller = object:inherit()

function controller:init()
	self.uimgr = uimgrclass:new()
	self.blockmgr = blockmgr_class:new()
	render.log("controller object init success")
end 

function controller:reset()
	self.uimgr:reset()
	render.log("controller object reset")
end

function controller:exit()
	render.log("controller object")
end

function controller:update(delta)
	render.begin_draw()
	self.uimgr:draw()
	self.blockmgr:draw()
	render.end_draw()
end

function controller:key_event(event)
	self.uimgr:update_score(1)
end

return controller