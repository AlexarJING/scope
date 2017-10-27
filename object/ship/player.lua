local ship = class("player_ship",obj.ship.base)

ship.slot = {
	system = {
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},	
	},
	battle = {
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
	self:add_plugin(obj.module.battle.weapon,1)
	--self:add_plugin(obj.plugin.universal.weapon,2)
	--self:add_plugin(obj.plugin.universal.weapon,3)
	--self:add_plugin(obj.plugin.core.key_core,1)
	self:add_plugin(obj.module.engine.engine,1)
	self:add_plugin(obj.module.engine.engine,2)
	self:add_plugin(obj.module.system.input,1)
	self:add_plugin(obj.module.system.output,2)
	self:add_plugin(obj.module.system.visible_radar,3)
	self:add_plugin(obj.module.system.energy_radar,4)
	self:add_plugin(obj.module.system.fire_control_radar,5)
end

return ship