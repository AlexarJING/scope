local engine = class("engine",obj.plugin.base)
engine.sidePower = 50
engine.turnPower = 150
engine.pushPower = 50
engine.heat = 14
engine.pname = "pareto"
engine.stype = "engine"

function engine:update(dt)
	self.ship.heat = self.ship.heat + self.heat*dt
	self.ship.sidePower = self.ship.sidePower + self.sidePower
	self.ship.pushPower = self.ship.pushPower + self.pushPower
	self.ship.turnPower = self.ship.turnPower + self.turnPower
end

return engine