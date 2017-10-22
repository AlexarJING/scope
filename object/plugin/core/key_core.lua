local core = class("core",obj.plugin.base)
core.stype = "core"
core.lockTime = 1
function core:init(...)
	obj.plugin.base.init(self,...)
	self.lockTimer = 0
end

function core:update(dt)
	self:checkKey()
	self:checkMouse(dt)
end

function core:checkKey()
	if self.ship.overheat then return end
	if love.keyboard.isDown("w") then
		self.ship:push(1)
	elseif love.keyboard.isDown("s") then
		self.ship:push(-1)
	end

	if love.keyboard.isDown("a") then
		self.ship:turn(1)
	elseif love.keyboard.isDown("d") then
		self.ship:turn(-1)
	end

	if love.keyboard.isDown("q") then
		self.ship:side(1)
	elseif love.keyboard.isDown("e") then
		self.ship:side(-1)
	end 

	if love.keyboard.isDown("c") then
		self.ship:stop()
	end

	if love.keyboard.isDown("space") then
		self.ship.openFire = true
	end

	if love.keyboard.isDown("lshift") then
		self.ship.openShield = true
	end

	if love.keyboard.isDown("escape") then
		self.ship.target = nil
	end
end

function core:checkMouse(dt)
	local currentTarget
	local callback = function(fixture)
    	local obj = fixture:getUserData()
    	if obj.tag == "ship" and obj.team ~= self.ship.team then
    		currentTarget = obj
    	end
    	return false
	end
	local mx,my = game.cam:toWorld(love.mouse.getPosition())
    game.world:queryBoundingBox( mx-5, my-5, mx+5, my+5, callback )
    if not currentTarget then return end

    if self.target == currentTarget then
    	self.lockTimer = self.lockTimer + dt
    	if self.lockTimer>self.lockTime then
    		self.ship.target = self.target
    		self.target = nil
    	end
    else
    	self.lockTimer = 0
    	self.target  = currentTarget
    end
    --print(self.target,self.lockTimer)
end
return core