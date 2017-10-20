local plugin = class("plugin")
plugin.heat = 0

function plugin:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = self.pname
end

function plugin:update(dt)
	self.ship.heat = self.ship.heat + dt*self.heat
end

function plugin:draw()

end

return plugin