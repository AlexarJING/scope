local weapon = class("weapon",obj.plugin.base)
weapon.stype = "universal"
weapon.fire_cd = 0.6
weapon.heat = 15
weapon.pname = "snake"
weapon.bullet = obj.others.missile
function weapon:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.fire_timer = 0
	self.name = weapon.pname
end

function weapon:update(dt)
	self.fire_timer = self.fire_timer - dt
	if self.fire_timer<0 and self.ship.openFire then
		self.fire_timer = self.fire_cd
		self.ship.heat = self.ship.heat + self.heat
		self.ship:check_overheat()
		local x,y = math.axisRot(
			self.slot.offx*self.ship.scale,
			self.slot.offy*self.ship.scale,
			self.ship.angle)
		self.bullet(self.ship,
			self.ship.x+x,
			self.ship.y+y,
			self.ship.angle+self.slot.rot*Pi,self.ship.scale)
	end
end


return weapon