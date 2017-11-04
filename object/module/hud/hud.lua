local mod = class("graphic",obj.module.base)
mod.heat_produce = 0
mod.energy_occupy = 0
mod.mod_name = "视图"
mod.socket = "system"
mod.color_style = {
	theme_main = {0,255,0,255},
	overheat = {255,0,0,255},
	unit_player = {255,255,255,255},
	unit_friend = {155,255,155,255},
	unit_neutral = {255,255,155,255},
	unit_enemy = {255,55,55,255},
	exausted = {50,50,50,255},
	energy_spot = {255,255,10,255},
	fire_control = {100,150,255,255}
}

local function circle(segments,alpha)
	segments = segments or 40
	alpha = alpha and 0 or 255
	local vertices = {}
	table.insert(vertices, {0, 0})
	for i=0, segments do
		local angle = (i / segments) * math.pi * 2
		local x = math.cos(angle)
		local y = math.sin(angle)
		table.insert(vertices, {x, y,_,_,_,_,_,alpha})
	end
	return love.graphics.newMesh(vertices, "fan")
end

function mod:init(ship,slot)
	obj.module.base.init(self,ship,slot)	
	self.cam = Camera.new(-5000,-5000,10000,10000)
	self.grid = require("lib/grid").new(self.cam)
	self.zoom = 1
	self.energy_spot_mesh = circle(20,0)
	self.fadeout = require("scr/fadeout"):init()
	self.explosion = require("scr/explosion"):init()
	game.hud = self
	self.ui = require("scr/ui"):init(self)
	self.canvas = love.graphics.newCanvas()
	self.diffused = love.graphics.newCanvas()
end

function mod:update(dt)
	obj.module.base.update(self,dt)
	game.hud = self
	
end



local code=[[
	
	float step = 0.01;
	
	vec4 effect( vec4 color, Image texture, vec2 tc, vec2 sc ){
		vec4 c = vec4(0,0,0,0);
		c = Texel(texture,vec2(tc.x ,tc.y- step))+
		Texel(texture,vec2(tc.x ,tc.y))+
		Texel(texture,vec2(tc.x ,tc.y+ step))+
		Texel(texture,vec2(tc.x - step,tc.y))+
		Texel(texture,vec2(tc.x + step,tc.y))
		;
		return color*(c/8);
	}
]]
local shader = love.graphics.newShader(code)

function mod:draw()
	local dt = love.timer.getDelta()
	self.cam:followTarget(self.ship,0,10)
	self.fadeout:update(dt)
	self.explosion:update(dt)
	self.ui:update(dt)


	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	self.cam:draw(function()
		self.fadeout:draw()
	end)
	self:drawGrid()
	--self:drawPlayer() --包括飞机，slot,shield 等
	self:drawVisibleWorld()
	self.cam:draw(function()
		self.explosion:draw()
	end)
	--self:drawExplosion()
	self:drawPlayer()
	self:drawEnergyWorld()
	self:drawFireCtrl()
	self:drawAnalyser()
	self:drawTarget()
	love.graphics.setCanvas()
	love.graphics.setCanvas(self.diffused)
	love.graphics.clear()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setShader(shader)
	love.graphics.draw(self.canvas)
	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas)
	suit.theme.bgTexture = self.diffused
	self.ui:draw()
end

function mod:drawGrid()
	love.graphics.setColor(255, 255, 255, 255)
	self.grid.draw()
end

function mod:drawShield(ship)
	local data = ship.data
	if not data then return end
	if not data.action.shield or not  data.shield_coverage then return end

	for i = 0 , data.shield_coverage, 0.02 do
		love.graphics.setColor(200, 150, 255,5)
		--love.graphics.setLineWidth(5-i*8)
		love.graphics.arc("fill", 0, 0, ship.scale*1.2, -Pi/2 - i*Pi, -Pi/2 + i*Pi)
		love.graphics.arc("line", 0, 0, ship.scale*1.2, -Pi/2 - i*Pi, -Pi/2 + i*Pi)
	end
end

function mod:drawLaser(laser)
	local slot = laser.slot
	local range = laser.target and math.getDistance(
		laser.x,laser.y,
		laser.target_x,laser.target_y) or laser.weapon.activeRange
	
	love.graphics.push()
		love.graphics.translate(slot.offx, slot.offy)
		love.graphics.rotate(slot.rot)
		for i=laser.power*laser.scale,1,-3 do
			love.graphics.setLineWidth(i)
			local c= 255-i*15<0 and 0 or 255-i*15
			love.graphics.setColor(c, c, 255,a)
			love.graphics.circle("fill", 0,0, i)
			love.graphics.line(0, 0, 0, -range) 
			love.graphics.circle("fill", 0,-range, laser.target and i or i/2)
		end
		love.graphics.setLineWidth(1)
	love.graphics.pop()

end


function mod:drawObj(object)
	self.cam:draw(function()	
	love.graphics.push()
	love.graphics.translate(object.x, object.y)
	love.graphics.rotate(object.angle)
	if object.tag == "laser" then
		self:drawLaser(object)
	elseif object.verts then
		love.graphics.outlinePolygon(object.verts,object.scale)
		self:drawShield(object)
	end
	love.graphics.pop()
	end)
end

function mod:drawSlot(ship)
	self.cam:draw(function()	
	love.graphics.push()
	love.graphics.translate(ship.x, ship.y)
	love.graphics.rotate(ship.angle)	
		for i,slot in ipairs(ship.slot) do
			if slot.plugin and slot.plugin.socket == "weapon" then
				love.graphics.push()
				love.graphics.translate(slot.offx*ship.scale, slot.offy*ship.scale)
				love.graphics.rotate(slot.plugin.rot)
				love.graphics.setColor(250, 250, 250, 250)
				love.graphics.circle("line", 0, 0, ship.scale/6)
				love.graphics.rectangle("fill", -ship.scale/16,-ship.scale/2,ship.scale/8,ship.scale/2)
				
				love.graphics.pop()
			end
		end
	
	love.graphics.pop()
	end)
end

function mod:drawPlayer()
	love.graphics.setColor(self.color_style.unit_player)
	self:drawObj(self.ship)
	self:drawSlot(self.ship)
end



function mod:getColor(obj)
	local color
	if obj.state == "exhausted" then
		color = self.color_style.exausted
	elseif obj.team ==1 then --player
		color = self.color_style.unit_player
	elseif obj.team>1 then--friend
		color = self.color_style.unit_friend
	elseif obj.team == 0 then  --neutral
		color = self.color_style.unit_neutral
	else -- team<0 enemy
		color = self.color_style.unit_enemy
	end
	return color
end

function mod:drawVisibleWorld()
	local player = self.ship
	local world = self.ship.data.world.visual
	--print(#world)
	if not world then return end
	
	for i , obj in ipairs(world) do		
		local kx,ky = self.ship:getNormScale(obj)
        local team = obj.team
    	local color = self:getColor(obj)

        if math.abs(kx)>1 or math.abs(ky)>1 then -- 在当前视野范围外
            local dist_norm = (kx^2+ky^2)^0.5   -- 归一化距离
            local a=255-dist_norm*20
            love.graphics.setColor(color[1],color[2],color[3], color[4]*a)
            if obj.tag == "ship" then
	            if math.abs(kx)>math.abs(ky) then
	                love.graphics.circle("fill", 0.5*math.abs(kx)/kx*w()+0.5*w(), 0.5*h()+h()/math.abs(kx)*ky*0.5, 8)
	            else
	                love.graphics.circle("fill", 0.5*w()+w()/math.abs(ky)*kx*0.5, 0.5*math.abs(ky)/ky*h()+0.5*h(), 8)
	            end
	        end
        else
	    	love.graphics.setColor(color)
			self:drawObj(obj)
			if obj.tag == "ship" then
				self.fadeout:addLine(obj.ox,obj.oy,obj.x,obj.y,color,obj.scale)
			end
        end
	end
	
end


local spot_size = 10 --heat == 100时

function mod:drawEnergyWorld()
	local world = self.ship.data.world.energy
	if not world then return end
	self.cam:draw(function()	
	for i , obj in ipairs(world) do
		if self.ship:inScreen(obj) then
			love.graphics.setColor(self.color_style.energy_spot)
			if obj.slot then
				love.graphics.push()
				love.graphics.translate(obj.x, obj.y)
				love.graphics.rotate(obj.angle)
				for i,slot in ipairs(obj.slot) do
					if slot.plugin and slot.plugin.heat>0 or obj.heat and obj.heat>0 then
						love.graphics.push()
						love.graphics.translate(slot.offx*obj.scale, slot.offy*obj.scale)
						love.graphics.rotate(slot.plugin.angle)
						local scale = spot_size*(slot.plugin.heat/slot.plugin.heat_volume)
						--print(slot.plugin.heat)
						love.graphics.draw(self.energy_spot_mesh,0,0,0,scale,scale)
						love.graphics.pop()
					end
				end
				love.graphics.pop()
			end
		end
	end
	end)
end

local spot_size = 30
local predict_time = 0.3
function mod:drawFireCtrl()
	local world = self.ship.data.world.fire_ctrl
	if not world then return end
	self.cam:draw(function()
	love.graphics.setLineWidth(1)	
	for i , obj in ipairs(world) do
		if obj.tag == "ship" and self.ship:inScreen(obj) then
			love.graphics.setColor(self.color_style.fire_control)
			love.graphics.push()
			love.graphics.translate(obj.x, obj.y)
			love.graphics.rotate(obj.angle)
			love.graphics.rectangle("line", -spot_size/2, -spot_size/2, spot_size, spot_size)
			love.graphics.pop()
			love.graphics.push()
			local px,py = obj:predictPosition(predict_time)
			love.graphics.translate(px,py)
			love.graphics.circle("line", 0, 0,spot_size/2)
			love.graphics.pop()
			love.graphics.line(obj.x, obj.y, px,py)
		end
	end
	end)
end

function mod:drawAnalyser()
	local world = self.ship.data.world.analyse
	if not world then return end
	self.cam:draw(function()
	love.graphics.setLineWidth(1)	
	for i , ship in ipairs(world) do
		if ship.tag == "ship" and self.ship:inScreen(ship) and ship.state == "active" then
			love.graphics.setColor(50, 255, 50, 50)
			love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-20, ship.scale*2, 5)
			love.graphics.setColor(50, 255, 50, 255)
			love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-20, ship.scale*2*ship.struct/ship.struct_max, 5)
			love.graphics.setColor(255, 55, 250, 50)
			love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-15, ship.scale*2, 5)
			love.graphics.setColor(255, 55, 250, 255)
			love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-15, ship.scale*2*ship.energy/ship.energy_max, 5)
			love.graphics.setColor(100, 100, 100, 255)
			love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-15, ship.scale*2*ship.energy_occupied/ship.energy_max, 5)
			--love.graphics.setColor(255, 255, 0, 50)
			--love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-10, ship.scale*2, 5)
			--love.graphics.setColor(255, 255, 0, 255)
			--love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-10, ship.scale*2*ship.heat/ship.heat_max, 5)
		end
	end
	end)
end

function mod:drawTarget()
	local target = self.ship.data.target
	if target then
		self.cam:draw(function() 
		love.graphics.push()
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.translate(target.x, target.y)
		local scale = target.scale
		local len = scale/4
		love.graphics.line(-scale,-scale+len,-scale,-scale,-scale+len,-scale)
		love.graphics.line(scale,-scale+len,scale,-scale,scale-len,-scale)
		love.graphics.line(-scale,scale-len,-scale,scale,-scale+len,scale)
		love.graphics.line(scale,scale-len,scale,scale,scale-len,scale)
		love.graphics.pop()
		end)
	end
	if self.ship.data.mouse then
		local mx,my = self.ship.data.mouse.x,self.ship.data.mouse.y
		self.cam:draw(function() 
		love.graphics.push()
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.translate(mx, my)
		local len = 20
		love.graphics.line(-len,-len,-len/2,-len/2)
		love.graphics.line(len,len,len/2,len/2)
		love.graphics.line(len,-len,len/2,-len/2)
		love.graphics.line(-len,len,-len/2,len/2)	
		love.graphics.pop()
		end)
	end
end
--x,y,angle,verts,scale,color
function mod:makeExplosion(t)
	game.hud.cam:shake()	
	self.explosion:add(t.x,t.y,t.angle,t.verts,t.scale,self:getColor(t))
end


function mod:setZoom(d)
    local last = self.zoom
    self.zoom = self.zoom + d/10
    if self.zoom < 0.1 then self.zoom = 0.1 end
    
    if w()/2/self.zoom > self.ship.data.visual_radius then
        self.zoom = last
    end
    self.cam:setScale(self.zoom)
    self.cam.x,self.cam.y = self.ship.x,self.ship.y
end


return mod