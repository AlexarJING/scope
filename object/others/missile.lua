local missile = class("missile")
missile.pushPower = 50
missile.turnPower = 80
missile.tag = "bullet"
missile.damage_type = "structure"
missile.damage_point = 30
missile.name = "snake"
missile.range = 2500
missile.linearDamping = 2
missile.angularDamping = 3
function missile:init(ship,x,y,rotation,scale)
	self.ship = ship
	self.team = ship.team
	self.x = x
	self.y = y
	self.scale = scale or 5
	self.angle = rotation or 0
	self.shape = love.physics.newRectangleShape( -scale/4, -scale/2, scale/2, scale)
	self.body = love.physics.newBody(game.world, x, y, "dynamic")
	self.body:setAngle(self.angle)
	self.fixture = love.physics.newFixture(self.body, self.shape,0.1)
	self.fixture:setUserData(self)
	self.body:setAngularDamping(self.angularDamping)
	self.body:setLinearDamping(self.linearDamping)
	table.insert(game.objects,self)
	self.timer = 5
end

function missile:update(dt)
	if self.destroyed then return end
	self:sync()
	self.timer = self.timer - dt
	if self.timer<0 then
		self:destroy()	
		return
	end
	self:findTarget()
	self:traceTarget()
	self:push()
end

function missile:draw()
	love.graphics.push()
	love.graphics.translate(self.x, self.y)
	love.graphics.rotate(self.angle)
	love.graphics.setColor(255, 255, 255, 255)
	local scale = self.scale
	love.graphics.rectangle("fill", -scale/8, -scale/2, scale/4, scale)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle("fill", -scale/8, -scale/2, scale/4, scale/4)
	love.graphics.pop()

	if self.target then
		local target = self.target
		love.graphics.push()
		love.graphics.translate(target.x, target.y)
		--love.graphics.rotate(target.angle)
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.line(-self.scale,0,self.scale,0)
		love.graphics.line(0,-self.scale,0,self.scale)
		love.graphics.circle("line", 0, 0, self.scale/2)
		love.graphics.pop()
	end
end

function missile:sync()
	self.x,self.y = self.body:getPosition()
	self.angle = self.body:getAngle()
end

function missile:destroy()
	self.destroyed = true
	self.body:destroy()
	obj.others.explosion(self.x,self.y,self.scale/2)
end



function missile:findTarget()
	if self.target and not self.target.destroyed then return end
    self.targets = {}
    local callback = function(fixture)
    	local obj = fixture:getUserData()
    	if obj.tag == "ship" and obj.team ~= self.team then
    		local dist = math.getDistance(self.x,self.y,obj.x,obj.y)
    		if dist < self.range then
	    		table.insert(self.targets,{obj = obj,dist = dist})
	    	end
    	end
    	return true
	end
    game.world:queryBoundingBox( self.x-self.range, self.y-self.range, self.x+self.range, self.y+self.range, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
    self.target = self.targets[1] and self.targets[1].obj
end

function missile:traceTarget()
    if not self.target then return end
    local tx,ty = self.target.x,self.target.y
	local rot = math.unitAngle(math.getRot(self.x,self.y,tx,ty)) --这里是计算方位角的一种方法。
	self.angle = math.unitAngle(self.angle)
    if rot>self.angle and math.abs(rot - self.angle)< math.pi or
		 rot<self.angle and  math.abs(rot - self.angle)> math.pi then
		self:turn(-1)
	else
		self:turn(1)
	end  
end



local function inRect(x,y,rx,ry,rw,rh)
	return x>= rx and x<rx+rw and y>=ry and y<ry+rh 
end


function missile:inScreen()
	return inRect(self.x,self.y,game.cam:getVisible(2))
end

function missile:makePuff()
	if love.math.random()>0.1 then return end
	if not self:inScreen() then return end
	local x,y = math.axisRot(0,0.5*self.scale,self.angle)
	obj.others.puff(self.x+x,self.y+y)
end

function missile:push(a)
	a = a or 1
	local dt = love.timer.getDelta()
	self.body:applyLinearImpulse(a *self.pushPower*math.sin(self.angle)*dt,
		-a*self.pushPower*math.cos(self.angle)*dt)
	self:makePuff()
end

function missile:turn(a)
	a = a or 1
	local dt = love.timer.getDelta()
	self.body:applyAngularImpulse(-a*self.turnPower*dt)
	self:makePuff()
end



return missile