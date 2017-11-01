local ship = class("player_ship",obj.ship.base)

ship.slot = {
	universal = {
		
		{offx = 0.3, offy = -0.3, rot = 1/24,enabled = true},
		{offx = -0.3, offy = -0.3, rot = -1/24,enabled = true},
		{offx = 0, offy = -0.8, rot = 0,enabled = true},

		{offx = -0.2, offy = 0.5, rot = 1,enabled = true},
		{offx = 0.2, offy = 0.5, rot = 1,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},
		{offx = 0,offy = 0,rot = 0,enabled = true},	
		{offx = 0,offy = 0,rot = 0,enabled = true},	
		{offx = 0,offy = 0,rot = 0,enabled = true},	
	},
}

function ship:init(...)
	obj.ship.base.init(self,...)
	self:resetSlots()
	self:add_plugin(obj.module.weapon.weapon,"universal",1)
	self:add_plugin(obj.module.weapon.weapon,"universal",2)
	self:add_plugin(obj.module.weapon.weapon,"universal",3)
	self:add_plugin(obj.module.engine.engine,"universal",4)
	self:add_plugin(obj.module.engine.engine,"universal",5)
	self:add_plugin(obj.module.cockpit.cockpit,"universal",6)

	self:add_plugin(obj.module.hud.hud,"universal",7)
	self:add_plugin(obj.module.radar.visible_radar,"universal",8)
	self:add_plugin(obj.module.radar.energy_radar,"universal",9)
	self:add_plugin(obj.module.radar.fire_control_radar,"universal",10)
	self:add_plugin(obj.module.system.shield,"universal",11)
	self:add_plugin(obj.module.radar.analyse_radar,"universal",12)
end

return ship