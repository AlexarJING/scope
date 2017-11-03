local mod = class("mod")
mod.energy_occupy = 3
mod.heat_volume = 100
mod.heat_radiating = 10
mod.heat_per_sec = 0
mod.heat_per_shot = 0
mod.mod_name = "undefined"
mod.socket = "undefined"

function mod:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.heat = 0
	self.name = self.mod_name
end

function mod:update(dt)
	self.heat = self.heat - self.heat_radiating*dt
	if self.heat<0 then self.heat = 0 end
	if self.action then
		self:action(dt)
	end
end


function mod:produceHeatPerSec()
	local dt = love.timer.getDelta()
	if self.heat+self.heat_per_sec*dt >self.heat_volume then
		return false
	else
		self.heat = self.heat + dt*self.heat_per_sec
		return true
	end
end

function mod:produceHeatPerTime(n)
	n = n or 1
	if self.heat+self.heat_per_shot*n >self.heat_volume then
		return false
	else
		self.heat = self.heat + self.heat_per_shot*n
		return true
	end
end

function mod:getAzi(target)
	return math.unitAngle(math.getRot(self.x,self.y,target.x,target.y)-self.ship.angle)
end

function mod:shut_down()

end

return mod