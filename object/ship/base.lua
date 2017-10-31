local ship = class("ship_base")
ship.struct_max = 100
ship.energy_max = 100
ship.heat_max = 100
ship.cool_down_effect = 50
ship.energy_generate_effect = 100
ship.tag = "ship"
ship.slot = {
	cockpit = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	},
	weapon = {	
		{offx = 0, offy = -0.8, rot = 0,enabled = true},
	},
	engine = {
		{offx = 0, offy = 0.5, rot = 1,enabled = true},
	},
	hud = {
		{offx = 0, offy = 0.5, rot = 1,enabled = true}
	},
	radar = {
		{offx = 0, offy = 0.5, rot = 1,enabled = true}
	},
	system = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	},
	universal = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	}
}

ship.linearDamping = 0.5
ship.angularDamping = 2

ship.verts = {
	0,-1,1,1,0,0.5,-1,1
}


function ship:init(team,x,y,scale,rotation)
	self.team =team
	self.x = x
	self.y = y
	self.scale = scale or 30
	self.angle = 0
	self.shape = love.physics.newCircleShape(0,0,self.scale)
	self.body = love.physics.newBody(game.world, x, y, "dynamic")
	self.fixture = love.physics.newFixture(self.body, self.shape,0.1)
	self.fixture:setUserData(self)
	self.struct = 10
	self.energy = 10
	self.heat = 0
	self.energy_occupied = 0
	self.body:setAngularDamping(self.angularDamping)
	self.body:setLinearDamping(self.linearDamping)
	self.state = "active"
	self.data = {
		action = {},
		world = {}
	}
	self.buffs = {

	}
	game:addObject(self)

end

function ship:energy_ctrl(dt)
	self.energy_occupied = 0
	for socket, tab in pairs(self.slot) do
		for i, slot in ipairs(tab) do
			if slot.plugin then
				self.energy_occupied = self.energy_occupied + slot.plugin.energy_occupy
			end
		end
	end
	self.energy = self.energy + self.energy_generate_effect*dt
	if self.energy>self.energy_max then
		self.energy = self.energy_max
	end
end


function ship:update(dt)
	if self.destroyed then return end
	self:sync()
	if self.state == "active" then
		self:slot_update(dt)
	end
	self:heat_ctrl(dt)
	self:energy_ctrl(dt)
end


function ship:exhaust()
	if self.state == "active" then 
		self.state ="exhausted"
		game.hud:makeExplosion(self)
		delay:new(10,function() self:destroy() end)
	end
end


function ship:destroy()
	self.state ="destroyed"
	self.destroyed = true
	self.body:destroy()
end

function ship:resetSlots()
	self.slot = table.copy(self.slot)
end

function ship:sync()
	self.ox,self.oy = self.x,self.y
	self.x,self.y = self.body:getPosition()
	self.vx,self.vy = self.body:getLinearVelocity()
	self.angle = self.body:getAngle()
	self.body:setLinearDamping(self.linearDamping)
	self.data.shield_power = 0
	self.shield_coverage = 0
	--self.data = {}
end

function ship:slot_update(dt)

	for socket, tab in pairs(self.slot) do
		for i, slot in ipairs(tab) do
			if slot.enabled and slot.plugin then
				slot.plugin:update(dt)
			end
		end
	end

end



function ship:add_plugin(plugin,socket,position)
	local slot = self.slot[socket][position] 
	if slot and (plugin.socket == socket or socket == "universal") and slot.plugin == nil then
		slot.plugin = plugin(self,slot)
	end
end

function ship:heat_ctrl(dt)
	if self.heat>=self.heat_max then
		self.heat = self.heat_max
		self.overheat = true
		for socket, tab in pairs(self.slot) do
			for i, slot in ipairs(tab) do
				slot.enabled = false 
			end
		end
		
	end
	self.heat = self.heat - dt*self.cool_down_effect
	
	if self.heat<0 then 
		self.heat=0
		if self.overheat then
			self.overheat = false 
			for socket, tab in pairs(self.slot) do
				for i, slot in ipairs(tab) do
					slot.enabled = true 
				end
			end
		end
	end
end

function ship:damage(damage_point,damage_type)
	if self.state~="active" or self.destroyed then return end
	
	if self.data.action.shield and self.energy>0 then
		--
	end
	self.struct = self.struct - damage_point

	if self.struct<0 then self:exhaust()end

	if damage_type == "structure" then

	elseif damage_type == "energy" then

	elseif damage_type == "quantum" then

	end
end

function ship:damage_shield()

end

function ship:damage_armor()

end


function ship:getDist(target)
	return math.getDistance(self.x,self.y,target.x,target.y)
end

function ship:getAzi(target)
	return math.getRot(self.x,self.y,target.x,target.y)
end

function ship:getNormScale(target)
	local scale = game.hud.zoom
	return (target.x-self.x)/(0.5*w()/scale),(target.y-self.y)/(0.5*h()/scale)
end

function ship:inScreen(target)
	local kx,ky=self:getNormScale(target)
    return math.abs(kx)<= 1 and  math.abs(ky)<=1
end

function ship:predictPosition(preTime)
	return self.vx*preTime + self.x,self.vy*preTime + self.y
end


return ship