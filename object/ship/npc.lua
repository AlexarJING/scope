local base = obj.ship.base
local ship = class("ai_ship",base)

ship.verts = {
	-0.3,-1, 0.3,-1,
	0.6,0, 0.3,1,
	-0.3,1 , -0.6,0
}



ship.slot = {
	{socket = "universal",offx = 0, offy = -0.8, rot = 0,enabled = true},
	{socket = "universal",offx = 0, offy = 0.8, rot = 0,enabled = true},
	{socket = "universal",offx = 0, offy = 0.5, rot = 1,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true}
}

function ship:init(...)
	base.init(self,...)
	self:resetSlots()
	self:add_plugin(obj.module.system.ai,1)
	self:add_plugin(obj.module.engine.engine,2)
	--self:add_plugin(obj.plugin.universal.weapon,1)
	--self:add_plugin(obj.plugin.universal.radar,2)
end
return ship