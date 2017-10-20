local shield = class("shield",obj.plugin.base)
shield.shield_coverage = 0.4
shield.heat = 20
shield.pname = "Hercules"
shield.stype = "universal"
shield.power = 60
function shield:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = shield.pname
	self.ship.shield_coverage = self.shield_coverage
end

function shield:update(dt)
	if self.ship.openShield then
		self.ship.heat = self.ship.heat + self.heat*dt
		self.ship.shieldPower = self.ship.shieldPower + self.power
	end
end

return shield