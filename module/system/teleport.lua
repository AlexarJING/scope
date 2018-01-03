return {
	socket = "system",
	mod_name = "短距传送",
	heat_radiating = 30,
	heat_volume = 100,
	heat_per_sec = 0,
	socket = "system",
	teleport_dist = 500,
	cool_down = 1,
    work_mode = "manual",
	action = function(self,dt)
		local data = self.ship.data
		if  self.cd_timer<0 then
			if data.mouse and self.ship:getDist(data.mouse)<=self.teleport_dist then
                self.cd_timer = self.cool_down
                self.ship.body:setPosition(data.mouse.x,data.mouse.y)
                
            else
                data.showRange = {
                    w = 30,
                    max_r = self.teleport_dist, -- circle ring line fan 
                    min_r = 100,
                    percent = 1,
                }
            end
		end
	end,
    always = function(self,dt)
		self.cd_timer = self.cd_timer or self.cool_down
		self.cd_timer = self.cd_timer - love.timer.getDelta()
    end
}