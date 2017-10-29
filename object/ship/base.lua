local ship = class("ship_base")
ship.armor_max = 100
ship.shield_max = 100
ship.heat_max = 100
ship.cool_down_effect = 50
ship.energy_occupied = 0
ship.tag = "ship"
ship.slot = {
	system = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	},
	battle = {	
		{offx = 0, offy = -0.8, rot = 0,enabled = true},
	},
	engine = {
		{offx = 0, offy = 0.5, rot = 1,enabled = true},
	},
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
	self.armor = 10
	self.shield = 10
	self.heat = 0
	self.energy_occupied = 0
	self.body:setAngularDamping(self.angularDamping)
	self.body:setLinearDamping(self.linearDamping)

	game:addObject(self)

end



function ship:update(dt)
	if self.destroyed then return end
	self:sync()
	if self.exhausted  then return end
	self:slot_update(dt)
	self:heat_ctrl(dt)
end


function ship:exaust()
	self.exhausted = true
	game.hud:makeExplosion(self)
	delay:new(10,function() self:destroy() end)
end


function ship:destroy()
	self.destroyed = true
	self.body:destroy()
end

function ship:resetSlots()
	self.slot = table.copy(self.slot)
end

function ship:sync()
	self.ox,self.oy = self.x,self.y
	self.x,self.y = self.body:getPosition()
	self.angle = self.body:getAngle()
	self.body:setLinearDamping(self.linearDamping)
	self.data = {}
	
end

function ship:slot_update(dt)	
	for i,slot in ipairs(self.slot.system) do
		if slot.enabled and slot.plugin then 
			slot.plugin:update(dt)
		end
	end
	for i,slot in ipairs(self.slot.battle) do
		if slot.enabled and slot.plugin then 
			slot.plugin:update(dt)
		end
	end
	for i,slot in ipairs(self.slot.engine) do
		if slot.enabled and slot.plugin then 
			slot.plugin:update(dt)
		end
	end
end



function ship:add_plugin(plugin,position)
	--print(plugin.mod_type,position)
	local slot = self.slot[plugin.mod_type][position]
	slot.plugin = plugin(self,slot)
end

function ship:heat_ctrl(dt)
	if self.heat>=self.heat_max then
		self.heat = self.heat_max
		self.overheat = true
		for i,s in ipairs(self.slot.engine) do
			s.enabled = false
		end
		for i,s in ipairs(self.slot.battle) do
			s.enabled = false
		end
	end
	self.heat = self.heat - dt*self.cool_down_effect
	
	if self.heat<0 then 
		self.heat=0
		if self.overheat then
			self.overheat = false 
			for i,s in ipairs(self.slot.engine) do
				s.enabled = true
			end
			for i,s in ipairs(self.slot.battle) do
				s.enabled = true
			end
		end
	end
end

function ship:damage(damage_point,damage_type)
	if self.exhausted or self.destroyed then return end
	if self.open_shield and self.shieldPower>0 then
		damage_point = damage_point - damage_point*shieldPower/100
	end
	self.armor = self.armor - damage_point
	if self.armor<0 then self:exaust()end
	if damage_type == "structure" then

	elseif damage_type == "energy" then

	elseif damage_type == "quantum" then

	end
end

function ship:damage_shield()

end

function ship:damage_armor()

end

function ship:getData(key)
	return self.data[key]
end

function ship:setData(key,value)
	self.data[key] = value
end

return ship