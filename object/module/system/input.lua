local core = class("input",obj.module.base)
core.mod_type = "system"
core.mod_name = "input"
core.lockTime = 1
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
		if love.keyboard.isDown("w") then
			action.push = 1
		elseif love.keyboard.isDown("s") then
			action.push = -1
		end

		if love.keyboard.isDown("a") then
			action.turn = 1
		elseif love.keyboard.isDown("d") then
			action.turn = -1
		end

		if love.keyboard.isDown("q") then
			action.side = 1
		elseif love.keyboard.isDown("e") then
			action.side = -1
		end 

		if love.keyboard.isDown("c") then
			action.stop = true
		end

		if love.keyboard.isDown("space") then
			action.fire = true
		end

		if love.keyboard.isDown("lshift") then
			action.shield = true
		end

		if love.keyboard.isDown("escape") then
			self.target = nil
		end
	end
	self.ship.data.action = action
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
	local mx,my = game.hud.cam:toWorld(love.mouse.getPosition())
    game.world:queryBoundingBox( mx-5, my-5, mx+5, my+5, callback )
    --if not currentTarget then return end

    if self.target and self.target.destroyed then
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
    if love.mouse.isDown(2) then
    	self.ship.data.mouseX = mx
    	self.ship.data.mouseY = my
    end
end
return core