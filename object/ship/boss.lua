local core = class("core",obj.plugin.core.ai_core)
core.stype = "core"
function core:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.nextMovement = love.math.random()*3
	self.action = function() end
	self.actionIndex =0
end

function core:update(dt)
	if self.ship.overheat then return end
	self.nextMovement = self.nextMovement - dt
	if self.nextMovement<0 then
		
		self.actionIndex = self.actionIndex + 1
		if self.actionIndex==1 then
			self.nextMovement = 3
			self.action = function()
				self.ship:turn()
				self.ship.openFire = true
			end

		elseif self.actionIndex == 2 then
			self.nextMovement = 3
			self.action = function() 
				self.ship:turn(-1)
				self.ship.openFire = true
			end
		elseif self.actionIndex == 3 then
			self.nextMovement = 3
			self.action = function() 
				
			end
			self.actionIndex = 0
		end
	else
		self:action()
	end
end


local weapon = class("weapon",obj.plugin.universal.weapon)
weapon.stype = "universal"
weapon.fire_cd = 0.1
weapon.heat = 0
weapon.pname = "hell max"
weapon.bullet = obj.others.bullet

local base = obj.ship.base

local ship = class("boss",base)
ship.slot = {
	core = {
		{offx = 0,offy = 0,rot = 0,enabled = true}
	},
	universal = {
		{offx = 1, offy = -1, rot = 1/4,enabled = true},
		{offx = -1, offy = -1, rot = -1/4,enabled = true},
		{offx = 1, offy = 1, rot = 3/4,enabled = true},
		{offx = -1, offy = 1, rot = -3/4,enabled = true},
	},
	engine = {
		{offx = 0, offy = 0, rot = 1,enabled = true},
		{offx = 0, offy = 0, rot = -1,enabled = true},
	},
}

function ship:init(...)
	base.init(self,...)
	self:resetSlots()
	self:add_plugin(core,1)
	for i = 1,4 do
		self:add_plugin(weapon,i)
	end
	self:add_plugin(obj.plugin.engine.engine,1)
	self:add_plugin(obj.plugin.engine.engine,2)
end
return ship