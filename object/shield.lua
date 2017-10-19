local plugin = class("plugin")
plugin.cover = 0.4
plugin.heat = 0.2
plugin.pname = "Hercules"
plugin.stype = "universal"
plugin.power = 100
function plugin:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = plugin.pname
	self.ship.cover = self.cover
end

function plugin:update(dt)
	if self.ship.openShield then
		self.ship.heat = self.ship.heat + self.heat
		self.ship.shieldPower = self.ship.shieldPower + self.power
	end
end

function plugin:draw()

end

return plugin