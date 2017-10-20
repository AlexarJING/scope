local base = obj.ship.base
local ship = class("ai_ship",base)
function ship:init(...)
	base.init(self,...)
	self:resetSlots()
	self:add_plugin(obj.plugin.core.ai_core,1)
	self:add_plugin(obj.plugin.engine.engine,1)
	self:add_plugin(obj.plugin.universal.weapon,1)
end
return ship