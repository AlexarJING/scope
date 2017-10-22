local weapon = class("chain",obj.plugin.base)
weapon.stype = "universal"
weapon.fire_cd = 0.1
weapon.heat = 0.1
weapon.pname = "sun flower"
weapon.bullet = obj.others.bullet
weapon.range =  300
weapon.dr = Pi*2
weapon.rotLimit = Pi/3
weapon.autoTarget = true
weapon.autoFire = true
function weapon:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.fire_timer = 0
	self.name = weapon.pname
	self.rot = 0
	self.angle =self.ship.angle + self.rot
	self.scale = self.ship.scale
end

function weapon:findTarget()
	if not self.autoTarget then return end
	if self.ship.target then self.target = self.ship.target end
	if self.target and self.target.destroyed then self.target = nil end
	if self.target and math.getDistance(self.target.x,self.target.y,self.x,self.y)>self.range then
		self.target = nil
	end
    self.targets = {}
    local callback = function(fixture)
    	local obj = fixture:getUserData()
    	if obj.tag == "ship" and obj.team ~= self.ship.team then
    		local rot = math.unitAngle(math.getRot(self.x,self.y,obj.x,obj.y)-self.ship.angle)
    		local dist = math.getDistance(self.x,self.y,obj.x,obj.y)
    		if rot> - self.rotLimit and rot< self.rotLimit and dist<self.range then
	    		table.insert(self.targets,{obj = obj,dist = dist})
	    	end
    	end
    	return true
	end
    game.world:queryBoundingBox( self.x-self.range, self.y-self.range, self.x+self.range, self.y+self.range, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
    self.target = self.targets[1] and self.targets[1].obj
end

function weapon:traceTarget(dt)
    if not self.target then return end
    local tx,ty = self.target.x,self.target.y
	local rot = math.unitAngle(math.getRot(self.x,self.y,tx,ty)) --这里是计算方位角的一种方法。
	self.angle = math.unitAngle(self.angle)
    if rot>self.angle and math.abs(rot - self.angle)< math.pi or
		 rot<self.angle and  math.abs(rot - self.angle)> math.pi then
		self.rot = self.rot + self.dr * dt
	else
		self.rot = self.rot - self.dr * dt
	end 
	if self.rot > self.rotLimit then
		self.rot = self.rotLimit
	end
	if self.rot < - self.rotLimit then
		self.rot = - self.rotLimit
	end
end

function weapon:getPosition()
	local x,y = math.axisRot(
			self.slot.offx*self.ship.scale,
			self.slot.offy*self.ship.scale,
			self.ship.angle)
	self.x = self.ship.x + x
	self.y = self.ship.y + y
	self.angle = self.ship.angle+self.slot.rot*Pi + self.rot
end

function weapon:checkFire(dt)
	self.fire_timer = self.fire_timer - dt
	if self.fire_timer<0 and 
		(self.target and self.autoFire) or 
		(not self.autoFire and self.ship.openFire) then
		self.fire_timer = self.fire_cd
		self.ship.heat = self.ship.heat + self.heat
		self.ship:check_overheat()
		self.bullet(self.ship,
			self.x,self.y,self.angle)
	end
end


function weapon:update(dt)
	self:getPosition()
	self:findTarget(dt)
	self:traceTarget(dt)
	self:checkFire(dt)

end

function weapon:draw()
	if self.target then
		local target = self.target
		love.graphics.push()
		love.graphics.rotate(-self.ship.angle)
		love.graphics.translate(-self.x, -self.y)		
		love.graphics.translate(target.x, target.y)
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.line(-self.scale,0,self.scale,0)
		love.graphics.line(0,-self.scale,0,self.scale)
		love.graphics.circle("line", 0, 0, self.scale/2)
		love.graphics.pop()
	end
	love.graphics.setColor(0, 255, 0, 50)
	love.graphics.arc("fill", 0, 0, self.range, -self.rotLimit-Pi/2, self.rotLimit-Pi/2)
end

return weapon