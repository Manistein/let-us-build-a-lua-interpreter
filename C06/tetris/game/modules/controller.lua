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
	if self.blockmgr:get_game_status() ~= const.GAME_STATUS.GAME_OVER then 
		return 
	end

	self.uimgr:reset()
	self.blockmgr:reset()
	self.for_ui_data.erase_count = 0
	render.log("controller object reset")
end

function controller:exit()
	render.log("controller object")
end

function controller:update(delta)
	local game_status = self.blockmgr:update(delta, self.for_ui_data)

	self.uimgr:set_game_status(game_status)
	self.uimgr:update_score(self.for_ui_data.erase_count * const.BOARD_SIZE.X)
	self.blockmgr:set_downward_gap(self.uimgr:get_downward_gap())

	render.begin_draw()
	self.blockmgr:draw()
	self.uimgr:draw()
	render.end_draw()
end

function controller:key_event(event)
	self.blockmgr:key_event(event, self.for_ui_data)
end

function controller:toggle_pause()
	local game_status = self.blockmgr:get_game_status()
	if game_status == const.GAME_STATUS.RUNNING then 
		self.blockmgr:set_game_status(const.GAME_STATUS.PAUSE)
	elseif game_status == const.GAME_STATUS.PAUSE then 
		self.blockmgr:set_game_status(const.GAME_STATUS.RUNNING)
	end
end

return controller