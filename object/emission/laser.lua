local laser = class("laser",cls.obj.base)
laser.tag = "laser"
laser.obj_name = "laser"
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
	self.body = love.physics.newBody(game.world,0,0,"dynamic")
	self.shape = love.physics.newCircleShape(0,0,1)
	self.fixture = love.physics.newFixture(self.body, self.shape,0.01)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self:sync()
	table.insert(game.objects,self)
end



function laser:hitTest()
	self.target = nil	
	local function callback(fixture, x, y, xn, yn, fraction) --0 end 1 continue -1 ignore
		local obj = fixture:getUserData()
		if  obj.team ~= self.ship.team then
			self.target = obj
			self.target_x = x
			self.target_y = y
			self.through = self.through - 1
			obj:damage(self.weapon.damage_point*self.power,self.weapon.damage_type,{x = x,y = y})
			if self.through>0 then
				return -1
			else
				return 0
			end
		else
			return -1
		end
	end
	game.world:rayCast(self.x,self.y,self.tx,self.ty,callback)
end

function laser:sync()
	local sx,sy = math.axisRot(
			self.slot.offx*self.ship.scale,
			self.slot.offy*self.ship.scale,
			self.ship.angle)		
	self.x , self.y = self.ship.x+sx,self.ship.y+sy
	
	self.tx, self.ty = self.x + math.sin(self.angle)*self.weapon.activeRange, 
		self.y - math.cos(self.angle)*self.weapon.activeRange

	self.body:setPosition(self.x,self.y)
end


function laser:update(dt)
	self:sync()
	
	self.timer = self.timer - dt
	if self.timer<0 then
		self.fading = true
	end
	if self.fading then
		self.power = self.power - (1/self.weapon.activeTime)*dt
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
	self.body:destroy()
	self.destroyed = true
end

function laser:draw()
	local slot = self.slot
	local range = self.target and math.getDistance(
		self.ox,self.oy,
		self.target_x,self.target_y) or self.weapon.activeRange
	
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
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