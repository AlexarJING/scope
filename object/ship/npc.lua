local base = obj.ship.base
local ship = class("ai_ship",base)

ship.slot = {
	core = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	},
	universal = {	
		{offx = 0, offy = -0.8, rot = 0,enabled = true},
		{offx = 0, offy = 0.8, rot = 0,enabled = true},
	},
	engine = {
		{offx = 0, offy = 0.5, rot = 1,enabled = true},
	},
}

function ship:init(...)
	base.init(self,...)
	self:resetSlots()
	self:add_plugin(obj.plugin.core.ai_core,1)
	self:add_plugin(obj.plugin.engine.engine,1)
	self:add_plugin(obj.plugin.universal.weapon,1)
	self:add_plugin(obj.plugin.universal.radar,2)
end
return ship