return {
	socket = "system",
	mod_name = "短距传送",
	heat_radiating = 30,
	heat_volume = 100,
	heat_per_sec = 0,
	socket = "system",
	teleport_dist = 200,
	cool_down = 5,
	action = function(self,dt)
		local data = self.ship.data
		self.cd_timer = self.cd_timer or self.cool_down
		self.cd_timer = self.cd_timer - dt
		if data.action.teleport and self.cd_timer<0 then
			self.cd_timer = self.cool_down
			local x,y = self.ship.x,self.ship.y
			local angle = self.ship.angle
			x = x + math.sin(angle)*self.teleport_dist
			y = y - math.cos(angle)*self.teleport_dist
			self.ship.body:setPosition(x,y)
		end		

	end
}