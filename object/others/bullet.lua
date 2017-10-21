local bullet = class("bullet")
bullet.vf = 1000
bullet.tag = "bullet"
bullet.damage_type = "structure"
bullet.damage_point = 5
bullet.name = "hell fire"
function bullet:init(ship,x,y,rotation,scale)
	self.ship = ship
	self.team = ship.team
	self.x = x
	self.y = y
	self.scale = scale or 5
	self.shape = love.physics.newCircleShape(0,0,scale or 5)
	self.body = love.physics.newBody(game.world, x, y, "dynamic")
	self.fixture = love.physics.newFixture(self.body, self.shape,0.1)
	self.body:setLinearVelocity(self.vf*math.sin(rotation),-self.vf*math.cos(rotation))
	self.fixture:setUserData(self)
	table.insert(game.objects,self)
	self.timer = 1
end

function bullet:update(dt)
	if self.destroyed then return end
	self:sync()
	self.timer = self.timer - dt
	if self.timer<0 then
		self:destroy()	
	end
end

function bullet:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, self.scale)
end

function bullet:sync()
	self.x,self.y = self.body:getPosition()
	self.angle = self.body:getAngle()
end

function bullet:destroy()
	self.destroyed = true
	self.body:destroy()
end


return bullet