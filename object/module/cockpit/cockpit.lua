local core = class("input",obj.module.base)
core.socket = "cockpit"
core.mod_name = "驾驶舱"
core.lockTime = 1
local key = require "scr/key_conf"

function core:init(...)
	obj.module.base.init(self,...)
	self.lockTimer = 0
end

function core:update(dt)
	self:checkKey()
	self:checkMouse(dt)
end

function core:checkKey()
	
	local action = {}
	if not self.ship.overheat then  
		if love.keyboard.isDown(key.up) then
			action.push = 1
		elseif love.keyboard.isDown(key.down) then
			action.push = -1
		end

		if love.keyboard.isDown(key.left) then
			action.turn = 1
		elseif love.keyboard.isDown(key.right) then
			action.turn = -1
		end

		if love.keyboard.isDown(key.leftUp) then
			action.side = 1
		elseif love.keyboard.isDown(key.rightUp) then
			action.side = -1
		end 

		if love.keyboard.isDown(key.stop) then
			action.stop = true
		end

		if love.keyboard.isDown(key.fire) then
			action.fire = true
		end

		if love.keyboard.isDown(key.shield) then
			action.shield = true
		end

		if love.keyboard.isDown(key.shield) then
			action.shield = true
		end

		if love.keyboard.isDown(key.teleport) then
			action.teleport = true
		end
	end
	self.ship.data.action = action
end

function core:checkMouse(dt)
	if not game.hud then return end
	local currentTarget
	local callback = function(fixture)
    	local obj = fixture:getUserData()
    	if obj.tag == "ship" and obj.team ~= self.ship.team then
    		currentTarget = obj
    	end
    	return false
	end
	local mx,my = game.hud.cam:toWorld(love.mouse.getPosition())
    
    game.world:queryBoundingBox( mx-5, my-5, mx+5, my+5, callback )
    --if not currentTarget then return end
    if self.target and self.target.state~="active" then
		self.target = nil
	end

    if self.currentTarget and self.currentTarget == currentTarget then
    	self.lockTimer = self.lockTimer + dt
    	if self.lockTimer>self.lockTime then
    		self.target = self.currentTarget
    	end
    else
    	self.lockTimer = 0
    	self.currentTarget  = currentTarget
    end


    self.ship.data.target = self.target
    if love.mouse.isDown(key.aim) then
    	if self.ship.data.mouse then
    		self.ship.data.mouse.x,self.ship.data.mouse.y = mx,my
    	else
    		self.ship.data.mouse = {x=mx,y=my}
    	end
    	self.target = nil
   	else
   		self.ship.data.mouse = nil
    end
end
return core