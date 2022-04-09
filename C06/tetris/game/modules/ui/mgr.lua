local render = require("modules.core.render")
local object = require("modules.core.object")
local score_class  = require("modules.ui.score")
local tips_class = require("modules.ui.tips")
local const = require("modules.const")

local uimgr = object:inherit()

function uimgr:init()
	self.score = score_class:new()
	self.tips = tips_class:new()
	self.game_status = const.GAME_STATUS.RUNNING 
	render.log("uimgr.init success")
end

function uimgr:reset()
	self.score:reset()
	self.game_status = const.GAME_STATUS.RUNNING
	render.log("uimgr.reset")
end

function uimgr:update_score(v)
	self.score:set_score(v)
end

function uimgr:get_downward_gap()
	return self.score:get_downward_gap()
end

function uimgr:draw()
	self.score:draw()
	self.tips:draw()

	if self.game_status == const.GAME_STATUS.GAME_OVER then 
		render.draw_text(250, 300, "Game Over, press enter to restart")
	elseif self.game_status == const.GAME_STATUS.PAUSE then  
		render.draw_text(350, 300, "Game Pause")
	end 
end

function uimgr:set_game_status(status)
	self.game_status = status
end

return uimgr