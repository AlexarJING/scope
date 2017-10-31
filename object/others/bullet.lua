local bullet = class("bullet")
bullet.tag = "bullet"
bullet.verts = {
	0,-0.5,0.3,0.3,-0.3,0.3
}

function bullet:init(weapon,x,y,angle)
	self.weapon = weapon
	self.ship = weapon.ship
	self.team = self.ship.team
	self.ox,self.oy = self.ship.x,self.ship.y
	self.x = x
	self.y = y
	self.angle = angle
	self.scale = weapon.scale
	self.hp = weapon.hp
	self.shape = love.physics.newCircleShape(0,0,self.scale)
	self.body = love.physics.newBody(game.world, x, y, "dynamic")
	self.fixture = love.physics.newFixture(self.body, self.shape,0.01)
	local vx,vy = self.ship.body:getLinearVelocity()
	self.body:setLinearVelocity(weapon.initVelocity*math.sin(angle)+vx,
		-weapon.initVelocity*math.cos(angle)+vy)
	self.body:setAngle(self.angle)
	self.fixture:setUserData(self)	
	self.timer = weapon.activeTime
	self.body:setAngularDamping(weapon.angularDamping)
	self.body:setLinearDamping(weapon.linearDamping)
	self.through = weapon.through
	self.target = weapon.target
	self.state = "active"
	game:addObject(self)
end

function bullet:update(dt)
	if self.destroyed then return end
	self:sync()
	self.timer = self.timer - dt
	if self.timer<0 or math.getDistance(self.x,self.y,self.ox,self.oy)> self.weapon.activeRange then
		self:destroy()
		return
	end

	if self.weapon.tracing then
		self:traceTarget()
	end
end


function bullet:sync()
	self.heat = 0
	self.x,self.y = self.body:getPosition()
	self.angle = self.body:getAngle()
	--self.radar:getPosition(self)
	if self.target and self.target.destroyed then
		self.target = self.weapon.target
	end
end

function bullet:destroy()
	self.destroyed = true
	self.body:destroy()
	--[[
	if self.weapon.explosion_range~=0 then
		obj.others.explosion(self.x,self.y,self.weapon.explosion_range)
	elseif self.weapon.pushPower~=0 then
		obj.others.explosion(self.x,self.y,self.scale/2)
	end]]
end



local function inRect(x,y,rx,ry,rw,rh)
	return x>= rx and x<rx+rw and y>=ry and y<ry+rh 
end


function bullet:inScreen()
	return inRect(self.x,self.y,game.cam:getVisible(2))
end


function bullet:push(a)
	a = a or 1
	local dt = love.timer.getDelta()
	self.body:applyLinearImpulse(a *self.weapon.pushPower*math.sin(self.angle)*dt,
		-a*self.weapon.pushPower*math.cos(self.angle)*dt)
	self.heat = self.heat * self.weapon.heat_generate* love.timer.getDelta()
end

function bullet:turn(a)
	a = a or 1
	local dt = love.timer.getDelta()
	self.body:applyAngularImpulse(-a*self.weapon.turnPower*dt)
	self.heat = self.heat * self.weapon.heat_generate* love.timer.getDelta()
end

function bullet:traceTarget()
    --self.target = self.weapon.target
    self:push()
    --if self.target and self.target.destroyed then self.target = nil end
    if not self.target then return end
    local tx,ty 
    if self.target.vx then
    	local t = self.target_dist/self.initVelocity 
    	tx,ty = self.target.vx * t + self.target.x, self.target.vy * t +  self.target.y
    else
    	tx,ty = self.target.x , self.target.y
    end 
	local rot = math.unitAngle(math.getRot(self.x,self.y,tx,ty))
	self.angle = math.unitAngle(self.angle)
    if rot>self.angle and math.abs(rot - self.angle)< math.pi or
		 rot<self.angle and  math.abs(rot - self.angle)> math.pi then
		self:turn(-1)
	else
		self:turn(1)
	end  
end

function bullet:checkRangeDamage()
	local callback = function(fixture)
        local obj = fixture:getUserData()
        if obj.tag == "ship" and obj.team ~= self.ship.team and not obj.destroyed then
            local dist = math.getDistance(self.x,self.y,obj.x,obj.y)
            if  dist<self.weapon.explosion_range then
                obj:damage(self.weapon.damage_point,self.weapon.damage_type)
            end
        end
        return true
    end
    game.world:queryBoundingBox( self.x-self.weapon.explosion_range, self.y-self.weapon.explosion_range,
     self.x+self.weapon.explosion_range, self.y+self.weapon.explosion_range, callback )
end

function bullet:hit(target)
	if self.weapon.explosion_range == 0 then
		target:damage(self.weapon.damage_point,self.weapon.damage_type)
		if self.through>0 then
			self.through = self.through - 1
		else
			self:destroy()
		end		
	else
		self:checkRangeDamage()
		self:destroy()
	end
end

function bullet:damage(point)
	self.hp =self.hp - point
	if self.hp<0 then
		self:destroy()
	end
end

return bullet