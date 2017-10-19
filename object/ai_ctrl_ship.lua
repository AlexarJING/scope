local base = require "object/ship"

local ship = class("ai_ship",base)
local AICore = require "object/ai_core"
function ship:init(...)
	base.init(self,...)
	self:add_plugin(AICore,1)
end
return ship