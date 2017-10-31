local shield = class("shield",obj.module.base)
shield.shield_coverage = 1
shield.mod_name = "Hercules"
shield.socket = "battle"
shield.power = 30

function shield:update(dt)
	local data = self.ship.data
	if data.action.shield then
		data.shield_power = data.shield_power + self.power
		data.shield_coverage = self.shield_coverage
	end
end

return shield