local core = class("core",obj.plugin.base)
core.stype = "core"
function core:update(dt)
	if self.ship.overheat then return end
	if not self.nextMovement then
		self.nextMovement = love.math.random()*3
		self.action = function() end
	end
	self.nextMovement = self.nextMovement - dt
	if self.nextMovement<0 then
		
		local rnd = love.math.random()
		if rnd<0.2 then
			self.nextMovement = love.math.random()*5
			self.action = function()
				self.ship:push()
			end
		elseif rnd<0.4 then
			self.nextMovement = love.math.random()*2
			self.action = function()
				self.ship:turn()
				self.ship:push()
			end
		elseif rnd < 0.6 then
			self.nextMovement = love.math.random()*2
			self.action = function()
				self.ship:turn(-1)
				self.ship:push()
			end
		elseif rnd < 0.8 then
			self.nextMovement = love.math.random()*3
			self.action = function()
				self.ship:stop()
			end
		else
			self.nextMovement = love.math.random()*3
			self.action = function() 
				self.ship.openFire = true
			end
		end
	else
		self:action()
	end
end
return core