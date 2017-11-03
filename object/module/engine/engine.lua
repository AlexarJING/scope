local engine = class("engine",obj.module.base)
engine.sidePower = 50
engine.turnPower = 150
engine.pushPower = 20
engine.heat_per_sec = 30
engine.heat_radiating = 20
engine.mod_name = "pareto"
engine.socket = "engine"

function engine:update(dt)
	obj.module.base.update(self,dt)
	local action = self.ship.data.action
	self.body = self.ship.body
	self.angle = self.ship.angle

	if action.push and self:produceHeatPerSec() then
		self:push(action.push)
	end

	if action.push and self:produceHeatPerSec() then
		self:push(action.push)
	end
	if action.turn and self:produceHeatPerSec() then
		self:turn(action.turn)
	end
	if action.side and self:produceHeatPerSec() then
		self:side(action.side)
	end
	if action.stop and self:produceHeatPerSec() then
		self:stop(action.stop)
	end

end


function engine:push(a)
	if not a then return end
	local dt = love.timer.getDelta()
	self.body:applyLinearImpulse(a *self.pushPower*math.sin(self.angle)*dt,
		-a*self.pushPower*math.cos(self.angle)*dt)
end

function engine:turn(a)
	if not a then return end
	local dt = love.timer.getDelta()
	self.body:applyAngularImpulse(-a*self.turnPower*dt)
end

function engine:side(a)
	if not a then return end
	local dt = love.timer.getDelta()
	self.body:applyLinearImpulse(-a*self.sidePower*math.cos(self.angle)*dt,
		-a*self.sidePower*math.sin(self.angle)*dt)
end

function engine:stop(toggle)
	if not toggle then return end
	local dt = love.timer.getDelta()
	self.body:setLinearDamping(3)
end

return engine