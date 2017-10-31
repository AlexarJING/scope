local mod = class("mod")
mod.heat_produce = 10
mod.energy_occupy = 3
mod.mod_name = "undefined"
mod.socket = "undefined"

function mod:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = self.mod_name
end

function mod:update(dt)
	self.ship.heat = self.ship.heat + dt*(self.heat_produce or 0)
	self.ship.energy_occupied = self.ship.energy_occupied + (self.ship.energy_occupy or 0)
end

function mod:getAzi(target)
	return math.unitAngle(math.getRot(self.x,self.y,target.x,target.y)-self.ship.angle)
end

return mod