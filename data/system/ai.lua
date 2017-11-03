return {
	socket = "system",
	mod_name = "无意识",
	heat_radiating = 30,
	heat_volume = 100,
	heat_per_sec = 0,
	action = function(self,dt)
		--[[
		if not self.nextMovement then
			self.nextMovement = love.math.random()*3
			self.actions = {}
		end
		self.nextMovement = self.nextMovement - dt
		if self.nextMovement<0 then
			self.actions = {}
			local rnd = love.math.random()
			if rnd<0.2 then
				self.nextMovement = love.math.random()*5
				self.actions.push = 1
			elseif rnd<0.4 then
				self.nextMovement = love.math.random()*2		
				self.actions.push = 1
				self.actions.turn = 1
			elseif rnd < 0.6 then
				self.nextMovement = love.math.random()*2
				self.actions.push = 1
				self.actions.turn = -1
			elseif rnd < 0.8 then
				self.nextMovement = love.math.random()*3
				self.actions.stop = true
			else
				self.nextMovement = love.math.random()*3
				self.actions.fire = true
			end
		end	
		self.ship.data.action = self.actions]]
		self.ship.data.action.fire = true
	end
}