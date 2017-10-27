local engine = class("engine",obj.module.base)
engine.sidePower = 50
engine.turnPower = 150
engine.pushPower = 50
engine.heat = 30
engine.mod_name = "pareto"
engine.mod_type = "engine"

function engine:update(dt)
	local action = self.ship.data.action
	self.body = self.ship.body
	self.angle = self.ship.angle
	self:push(action.push)
	self:turn(action.turn)
	self:side(action.side)
	self:stop(action.stop)
	
	

end


function engine:push(a)
	if not a then return end
	local dt = love.timer.getDelta()
	self.body:applyLinearImpulse(a *self.pushPower*math.sin(self.angle)*dt,
		-a*self.pushPower*math.cos(self.angle)*dt)
	self.ship.heat = self.ship.heat + self.heat*dt
end

function engine:turn(a)
	if not a then return end
	local dt = love.timer.getDelta()
	self.body:applyAngularImpulse(-a*self.turnPower*dt)
	self.ship.heat = self.ship.heat + self.heat*dt
end

function engine:side(a)
	if not a then return end
	local dt = love.timer.getDelta()
	self.body:applyLinearImpulse(-a*self.sidePower*math.cos(self.angle)*dt,
		-a*self.sidePower*math.sin(self.angle)*dt)
	self.ship.heat = self.ship.heat + self.heat*dt
end

function engine:stop(toggle)
	if not toggle then return end
	local dt = love.timer.getDelta()
	self.body:setLinearDamping(3)
	self.ship.heat = self.ship.heat + self.heat*dt
end

return engine