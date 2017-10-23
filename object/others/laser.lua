local laser = class("laser")

function laser:init(weapon)
	self.weapon = weapon
	self.ship = weapon.ship
	self.team = self.ship.team
	self.slot = self.weapon.slot
	self.scale = weapon.scale
	self.timer = weapon.activeTime
	self.through = weapon.through
	self.power = 1
	self.angle = self.weapon.angle
	table.insert(game.objects,self)
end



function laser:hitTest()
	self.target = nil	
	local function callback(fixture, x, y, xn, yn, fraction) --0 end 1 continue -1 ignore
		local obj = fixture:getUserData()
		if (obj.tag == self.weapon.target_type or 
			self.weapon.target_type == "all") and obj.team ~= self.ship.team then
			self.target = obj
			self.target_x = x
			self.target_y = y
			self.through = self.through - 1
			obj:damage(self.weapon.damage_point*self.power,self.damage_type)
			if self.through>0 then
				return -1
			else
				return 0
			end
		else
			return -1
		end
	end
	--print(self.ox,self.oy,self.tx,self.ty,callback)
	game.world:rayCast(self.ox,self.oy,self.tx,self.ty,callback)
end

function laser:sync()
	local sx,sy = math.axisRot(
			self.slot.offx*self.ship.scale,
			self.slot.offy*self.ship.scale,
			self.ship.angle)		
	self.ox , self.oy = self.ship.x+sx,self.ship.y+sy
	
	self.tx, self.ty = self.ox + math.sin(self.angle)*self.weapon.activeRange, 
		self.oy - math.cos(self.angle)*self.weapon.activeRange

end


function laser:update(dt)
	self:sync()
	
	self.timer = self.timer - dt
	if self.timer<0 then
		self.fading = true
	end
	if self.fading then
		self.power = self.power - 3*dt
		if self.power <0 then
			self.power = 0
			self:destroy()
		else
			self:hitTest()
		end
		
	else
		self:hitTest()		
	end
end

function laser:destroy()
	self.destroyed = true
end

function laser:draw()
	local slot = self.slot
	local range = self.target and math.getDistance(
		self.ox,self.oy,
		self.target_x,self.target_y) or self.weapon.activeRange
	
	love.graphics.push()
		love.graphics.translate(self.ox, self.oy)
		love.graphics.rotate(self.angle)
		for i=self.power*self.scale,1,-3 do
			love.graphics.setLineWidth(i)
			local c= 255-i*15<0 and 0 or 255-i*15
			love.graphics.setColor(c, c, 255,a)
			love.graphics.circle("fill", 0,0, i)
			love.graphics.line(0, 0, 0, -range) 
			love.graphics.circle("fill", 0,-range, self.target and i or i/2)
		end
		love.graphics.setLineWidth(1)
	love.graphics.pop()
end

return laser