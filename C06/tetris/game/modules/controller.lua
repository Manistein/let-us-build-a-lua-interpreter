local render = require("modules.core.render")
local uimgrclass  = require("modules.ui.mgr")
local blockmgr_class = require("modules.logic.blockmgr")
local const = require("modules.const")

local object = require("modules.core.object")
local controller = object:inherit()

function controller:init()
	self.uimgr = uimgrclass:new()
	self.blockmgr = blockmgr_class:new()
	self.for_ui_data = { erase_count = 0 }
	render.log("controller object init success")
end 

function controller:reset()
	self.uimgr:reset()
	self.blockmgr:reset()
	render.log("controller object reset")
end

function controller:exit()
	render.log("controller object")
end

function controller:update(delta)
	self.blockmgr:update(delta, self.for_ui_data)
	self.uimgr:update_score(self.for_ui_data.erase_count * const.BOARD_SIZE.X)

	render.begin_draw()
	self.uimgr:draw()
	self.blockmgr:draw()
	render.end_draw()
end

function controller:key_event(event)
	self.blockmgr:key_event(event, self.for_ui_data)
end

return controller