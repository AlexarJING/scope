local laser = class("laser",obj.plugin.base)

laser.heat = 15
laser.width = 10
laser.range = 300
laser.stype = "universal"
laser.damage = 1
laser.damage_type = "energy"
function laser:init(...)
	obj.plugin.base.init(self,...)
	self.power = 0
end



function laser:hitTest()
	local sx,sy = math.axisRot(
			self.slot.offx*self.ship.scale,
			self.slot.offy*self.ship.scale,
			self.ship.angle)
	
	local ox,oy = self.ship.x+sx,self.ship.y+sy
	self.sx , self.sy = ox,oy
	local angle = self.ship.angle+self.slot.rot*Pi
	local tx,ty = ox + math.sin(angle)*self.range, oy - math.cos(angle)*self.range
	function callback(fixture, x, y, xn, yn, fraction) --0 end 1 continue -1 ignore
		local obj = fixture:getUserData()
		if obj.tag == "ship" and obj.team ~= self.ship.team then
			self.target = obj
			self.target_x = x
			self.target_y = y
			obj:damage(self.damage,self.damage_type)
			return 0
		else
			return -1
		end
	end
	game.world:rayCast(ox,oy,tx,ty,callback)
end

function laser:update(dt)
	self.target = nil
	if self.ship.openFire then
		self.ship.heat = self.ship.heat + self.heat*dt
		self.ship:check_overheat()
		self.power = 1
		self:hitTest()
	else
		self.power = self.power - 3*dt
		if self.power <0 then
			self.power = 0
		else
			self:hitTest()
		end
	end
end

function laser:draw()
	local slot = self.slot
	local range = self.target and math.getDistance(
		self.sx,self.sy,
		self.target_x,self.target_y) or self.range
	for i=self.power*self.width,1,-3 do
		love.graphics.setLineWidth(i)
		local c= 255-i*15<0 and 0 or 255-i*15
		love.graphics.setColor(c, c, 255,a)
		love.graphics.circle("fill", 0,0, i)
		love.graphics.line(0, 0, 0, -range) 
		love.graphics.circle("fill", 0,-range, self.target and i or i/2)
	end
	love.graphics.setLineWidth(1)
end

return laser