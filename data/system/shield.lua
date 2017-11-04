return {
	socket = "system",
	mod_name = "护盾",
	heat_radiating = 30,
	heat_volume = 100,
	heat_per_sec = 0,
	power = 30,
	shield_coverage = 0.5,
	action = function(self,dt)
		local data = self.ship.data
		if data.action.shield then
			data.shield_power = data.shield_power + self.power
			data.shield_coverage = self.shield_coverage
		else
			data.shield_power = 0
			data.shield_coverage = 0
		end

	end
}