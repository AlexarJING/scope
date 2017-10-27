local shield = class("shield",obj.plugin.base)
shield.shield_coverage = 0.4
shield.heat = 20
shield.pname = "Hercules"
shield.stype = "universal"
shield.power = 60
function shield:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = shield.pname
	self.ship.shield_coverage = self.shield_coverage
end

function shield:update(dt)
	if self.ship.openShield then
		self.ship.heat = self.ship.heat + self.heat*dt
		self.ship.shieldPower = self.ship.shieldPower + self.power
	end
end

function shield:drawShield()
	if not self.ship.openShield or self.ship.shieldPower == 0 then return end

	local function to_cut()
		love.graphics.circle("fill", 0, 
			self.ship.scale*2 - 0.5*self.ship.scale/(1-(self.shield_coverage*0.4+0.35)), 
			self.ship.scale/(self.shield_coverage*0.4+0.35))
	end
	love.graphics.stencil(to_cut, "replace", 1)

    love.graphics.setStencilTest("less", 1)
 
    love.graphics.setColor(100, 100, 255, 150)
    love.graphics.circle("fill", 0, 0, self.ship.scale*1.5)
 	
    love.graphics.setStencilTest()

end
return shield