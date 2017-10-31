local core = class("ai",obj.module.base)
core.socket = "system"
core.mod_name = "ai"
function core:update(dt)
	if self.ship.overheat then return end
	if not self.nextMovement then
		self.nextMovement = love.math.random()*3
		self.action = {}
	end
	self.nextMovement = self.nextMovement - dt
	if self.nextMovement<0 then
		self.action = {}
		local rnd = love.math.random()
		if rnd<0.2 then
			self.nextMovement = love.math.random()*5
			self.action.push = 1
		elseif rnd<0.4 then
			self.nextMovement = love.math.random()*2		
			self.action.push = 1
			self.action.turn = 1
		elseif rnd < 0.6 then
			self.nextMovement = love.math.random()*2
			self.action.push = 1
			self.action.turn = -1
		elseif rnd < 0.8 then
			self.nextMovement = love.math.random()*3
			self.action.stop = true
		else
			self.nextMovement = love.math.random()*3
			self.action.fire = true
		end
	end
	self.ship.data.action = self.action
end
return core