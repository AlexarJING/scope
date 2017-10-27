local mod = class("mod")
mod.heat_produce = 0
mod.energy_occupy = 0
mod.mod_name = "undefined"
mod.mod_type = "undefined"
function mod:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = self.mod_name
end

function mod:update(dt)
	self.ship.heat = self.ship.heat + dt*(self.heat_produce or 0)
	self.ship.energy_occupied = self.ship.energy_occupied + (self.ship.energy_occupy or 0)
end

function mod:draw()
	
end

return mod