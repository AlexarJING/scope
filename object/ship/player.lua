local ship = class("player_ship",obj.ship.base)

ship.slot = {	
	{socket = "universal",offx = 0.3, offy = -0.3, rot = 1/12,enabled = true},
	{socket = "universal",offx = -0.3, offy = -0.3, rot = -1/12,enabled = true},
	{socket = "universal",offx = 0, offy = -0.8, rot = 0,enabled = true},

	{socket = "universal",offx = -0.2, offy = 0.5, rot = 1,enabled = true},
	{socket = "universal",offx = 0.2, offy = 0.5, rot = 1,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},	
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},	
	{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},	
}

ship.scale = 20
function ship:init(...)
	obj.ship.base.init(self,...)
	
	self:add_plugin(obj.module.weapon.weapon,1)
	self:add_plugin(obj.module.weapon.weapon,2)
	self:add_plugin(obj.module.weapon.weapon,3)
	self:add_plugin(obj.module.engine.engine,4)
	self:add_plugin(obj.module.engine.engine,5)
	self:add_plugin(obj.module.cockpit.cockpit,6)

	self:add_plugin(obj.module.hud.hud,7)
	self:add_plugin(obj.module.radar.visible_radar,8)
	self:add_plugin(obj.module.radar.energy_radar,9)
	self:add_plugin(obj.module.radar.fire_control_radar,10)
	self:add_plugin(obj.module.system.shield,11)
	self:add_plugin(obj.module.radar.analyse_radar,12)
end

return ship