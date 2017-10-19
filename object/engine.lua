local engine = class("engine")
engine.sidePower = 30
engine.turnPower = 150
engine.pushPower = 50
engine.heat = 0.3
engine.pname = "pareto"
engine.stype = "engine"

function engine:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = engine.pname
	self.sidePower = engine.sidePower
	self.turnPower = engine.turnPower
	self.pushPower = engine.pushPower
end

function engine:update(dt)
	self.ship.heat = self.ship.heat + self.heat
	self.ship.sidePower = self.ship.sidePower + self.sidePower
	self.ship.pushPower = self.ship.pushPower + self.pushPower
	self.ship.turnPower = self.ship.turnPower + self.turnPower
end

function engine:draw()

end

return engine