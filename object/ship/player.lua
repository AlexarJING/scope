local ship = class("ship",obj.ship.base)

ship.slot = {
	core = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	},
	universal = {
		{offx = 0.3, offy = -0.3, rot = 1/24,enabled = true},
		{offx = -0.3, offy = -0.3, rot = -1/24,enabled = true},
		{offx = 0, offy = -0.8, rot = 0,enabled = true},
		{offx = -0.3, offy = 0.3, rot = 0,enabled = true},
		{offx = 0.3, offy = 0.3, rot = 0,enabled = true},
		{offx = 0, offy = 0.3, rot = 0,enabled = true},
	},
	engine = {
		{offx = -0.2, offy = 0.5, rot = 1,enabled = true},
		{offx = 0.2, offy = 0.5, rot = 1,enabled = true},
	},
}

function ship:init(...)
	obj.ship.base.init(self,...)
	self:resetSlots()
	self:add_plugin(obj.plugin.universal.weapon,1)
	self:add_plugin(obj.plugin.universal.weapon,2)
	self:add_plugin(obj.plugin.universal.laser,3)
	self:add_plugin(obj.plugin.core.key_core,1)
	self:add_plugin(obj.plugin.engine.engine,1)
	self:add_plugin(obj.plugin.engine.engine,2)
	self:add_plugin(obj.plugin.universal.shield,4)
	self:add_plugin(obj.plugin.universal.radar2,5)
	--self:add_plugin(obj.plugin.universal.firstPerson,6)
end

return ship