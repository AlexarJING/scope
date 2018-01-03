local ship = class("ship_base",cls.obj.base)
ship.struct_max = 100
ship.energy_max = 100
ship.energy_generate_effect = 100
ship.tag = "ship"
ship.obj_name = "ship_base"
ship.scale = 30
ship.mass = 2000

ship.slot = {
	{socket = "cokpit",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "weapon",offx = 0, offy = -0.8, rot = 0,enabled = true},
	{socket = "engine",offx = 0, offy = 0.5, rot = 1,enabled = true},
	{socket = "hud",offx = 0, offy = 0.5, rot = 1,enabled = true},
	{socket = "radar",offx = 0, offy = 0.5, rot = 1,enabled = true},
	{socket = "system",offx = 0,offy = 0,rot = 0,enabled = true},
	{socket = "univeral",offx = 0,offy = 0,rot = 0,enabled = true}
}

ship.mod_conf = {
	
}

ship.stock = {
	
}

ship.linearDamping = 0.5
ship.angularDamping = 2

ship.verts = {
	0,-1,1,1,0,0.5,-1,1
}


function ship:init(team,x,y,rotation)
	self.team =team
	self.x = x
	self.y = y
	self.scale = self.scale
	self.angle = rotation or 0
	self:physicInit()
	self.struct = self.struct_max
	self.energy = self.energy_max
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
	self:resetSlots()
	for k,v in pairs(self.mod_conf) do
		self:add_plugin(v,k)
	end
end

function ship:physicInit()
	--self.shape = love.physics.newCircleShape(0,0,self.scale)
	local x = self.x
	local y = self.y
	self.body = love.physics.newBody(game.world, x, y, "dynamic")
	self.fixtures = {}
	
	local test ,triangles =pcall(love.math.triangulate,self.verts )
	if not test then return end
	local points={}
	local mainFixture
	for i,triangle in ipairs(triangles) do
		local verts=math.polygonTrans(0, 0,0,self.scale,triangle)
		local test ,shape = pcall(love.physics.newPolygonShape,verts)
		if test then
			local fixture = love.physics.newFixture(self.body, shape,0.2)
			if i==1 then
				self.fixture = fixture
			end
			self.fixtures[i] = fixture
			fixture:setUserData(self)
		end
	end
	self.body:setAngle(self.angle)
	self.body:setMass(self.mass/10000)
end


function ship:energy_ctrl(dt)
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
	--self:heat_ctrl(dt)
	self:energy_ctrl(dt)
end


function ship:exhaust()
	if self.state == "active" then 
		game.hud:makeExplosion(self)
		self.state ="exhausted"
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
	for i, slot in ipairs(self.slot) do
		if slot.enabled and slot.plugin then
			slot.plugin:update(dt)
		end
	end
end

function ship:slot_enable(slot,toggle)
	slot.enabled = toggle
	if slot.plugin and not toggle then
		slot.plugin:shut_down()
		self.energy_occupied = self.energy_occupied - slot.plugin.energy_occupy
	elseif  slot.plugin and toggle then
		self.energy_occupied = self.energy_occupied + slot.plugin.energy_occupy
	end
end

function ship:add_plugin(plugin,position)
	--print(plugin,position)
    local slot = self.slot[position] 
	if slot and (plugin.socket == slot.socket or slot.socket == "universal") 
        and slot.plugin == nil then
        slot.plugin = plugin(self,slot)
		self.energy_occupied = self.energy_occupied + slot.plugin.energy_occupy
	end
end


function ship:damage(damage_point,damage_type,bullet)
	if self.state~="active" or self.destroyed then return end
	local azi = math.unitAngle(self:getAzi(bullet))

	if self.data.action.shield and self.data.shield_coverage~=0 then 
		if azi>math.unitAngle(self.angle)-self.data.shield_coverage*Pi and 
		azi<math.unitAngle(self.angle)+self.data.shield_coverage*Pi then
		self:damage_shield(damage_point,damage_type)
		end
	else
		self:damage_direct(damage_point,damage_type)
	end	
end

function ship:damage_shield(damage_point,damage_type)
	local energy = self.energy
	local shield_power = self.data.shield_power
	local low = self.energy_occupied
	if damage_type == "struct" then
		energy = energy - damage_point*1.5
		if energy<=low then
			energy = low
			self:damage_direct((low-energy)/1.5,damage_type)
		end
	elseif damage_type == "energy" then
		energy = energy - damage_point*0.5
		if energy<=low then
			energy = low
			self:damage_direct((low-energy)/0.5,damage_type)
		end
	elseif damage_type == "quantum" then
		energy = energy - damage_point
		if energy<=low then
			energy = low
			self:damage_direct((low-energy),damage_type)
		end
	end

	self.energy = energy
end

function ship:damage_direct(damage_point,damage_type)
	if damage_type == "struct" then
		self.struct = self.struct - damage_point
	elseif damage_type == "energy" then
		self.struct = self.struct - damage_point*2
	elseif damage_type == "quantum" then
		self.struct = self.struct - damage_point
	end
	if self.struct<=0 then 
		self.struct= 0
		self:exhaust()
	end
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