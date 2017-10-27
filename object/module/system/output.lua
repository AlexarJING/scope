local mod = class("ui",obj.module.base)
mod.heat_produce = 0
mod.energy_occupy = 0
mod.mod_name = "user interface"
mod.mod_type = "system"
mod.color_style = {
	theme_main = {0,255,0,255},
	overheat = {255,0,0,255},
	unit_player = {255,255,255,255},
	unit_friend = {155,255,155,255},
	unit_neutral = {255,255,155,255},
	unit_enemy = {255,55,55,255},
	exausted = {50,50,50,255},
	energy_spot = {255,10,10,255},
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
	game.hud = self
end

function mod:update(dt)
	obj.module.base.update(self,dt)
	game.hud = self
	self.cam:followTarget(self.ship,0,10)
	self.fadeout:update(dt)
end

function mod:draw()
	self.cam:draw(function()
		self.fadeout:draw()
	end)
	self:drawGrid()
	--self:drawPlayer() --包括飞机，slot,shield 等
	self:drawVisibleWorld()
	
	self:drawPlayer()
	self:drawEnergyWorld()
	self:drawFireCtrl()
	--self:drawAnalyser()
	self:drawUI()
end

function mod:drawGrid()
	self.grid.draw()
end

function mod:slotDraw(x,y,angle,offx,offy,rot,scale)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.translate(offx, offy)
	love.graphics.rotate(rot)
	love.graphics.setColor(50, 250, 50, 150)
	love.graphics.rectangle("fill",  - scale/10,  - scale/10, scale/5, scale/5)
	love.graphics.setColor(255, 255, 255, 250)
	love.graphics.polygon("fill", 0, - scale/10, - scale/10, slot_size/10, slot_size/10,slot_size/10)
	love.graphics.pop()
end

function mod:inScreen(x,y)
	local player = self.ship
	local kx,ky=(x-player.x)/(0.5*w()/self.cam.scale),(y-player.y)/(0.5*h()/self.cam.scale)
    return math.abs(kx)<= 1 and  math.abs(ky)<=1
end

function mod:drawShip(ship)
	self.cam:draw(function()	
	love.graphics.push()
	love.graphics.translate(ship.x, ship.y)
	love.graphics.rotate(ship.angle)
	love.graphics.outlinePolygon(ship.verts,ship.scale)
	love.graphics.pop()
	end)
end

function mod:drawPlayer()
	love.graphics.setColor(self.color_style.unit_player)
	self:drawShip(self.ship)
end

function mod:drawVisibleWorld()
	local player = self.ship
	local world = self.ship:getData("visible_world")
	--print(#world)
	if not world then return end
	
	for i , data in ipairs(world) do		
		local kx,ky=(data.x-player.x)/(0.5*w()/self.cam.scale),(data.y-player.y)/(0.5*h()/self.cam.scale)
        local team = data.team
    	local color 
		if data.exausted then
			color = self.color_style.exausted
		elseif team ==1 then --player
			color = self.color_style.unit_player
		elseif team>1 then--friend
			color = self.color_style.unit_friend
		elseif team == 0 then  --neutral
			color = self.color_style.unit_neutral
		else -- team<0 enemy
			color = self.color_style.unit_enemy
		end	
		
        if math.abs(kx)>1 or math.abs(ky)>1 then -- 在当前视野范围外
            local dist_norm = (kx^2+ky^2)^0.5   -- 归一化距离
            local _=255-dist_norm*20
            if _>0 then
                love.graphics.setColor(color[1],color[2],color[3], _)
                if math.abs(kx)>math.abs(ky) then
                    love.graphics.circle("fill", 0.5*math.abs(kx)/kx*w()+0.5*w(), 0.5*h()+h()/math.abs(kx)*ky*0.5, 8)
                else
                    love.graphics.circle("fill", 0.5*w()+w()/math.abs(ky)*kx*0.5, 0.5*math.abs(ky)/ky*h()+0.5*h(), 8)
                end
            end
        else
        	--self.cam:draw(function()
        	love.graphics.setColor(color)
			self:drawShip(data)
			self.fadeout:addLine(data.ox,data.oy,data.x,data.y,color,data.scale)
			--end)
        end
	end
	
end


local spot_size = 30 --heat == 100时

function mod:drawEnergyWorld()
	local world = self.ship:getData("energy_world")
	if not world then return end
	self.cam:draw(function()	
	for i , data in ipairs(world) do
		if self:inScreen(data.x,data.y) then
			love.graphics.setColor(self.color_style.energy_spot)
			local scale = spot_size*data.heat/100
			love.graphics.draw(self.energy_spot_mesh,data.x,data.y,0,scale,scale)
		end
	end
	end)
end

function mod:drawFireCtrl()
	local world = self.ship:getData("fire_control")
	if not world then return end
	self.cam:draw(function()	
	for i , data in ipairs(world) do
		love.graphics.setColor(self.color_style.fire_control)
		love.graphics.push()
		love.graphics.translate(data.x, data.y)
		love.graphics.rotate(angle)
		love.graphics.rectangle("line", -spot_size, -spot_size, spot_size*2, spot_size*2)
		love.graphics.pop()
		love.graphics.push()
		love.graphics.translate(data.tx, data.ty)
		love.graphics.circle("line", 0, 0,spot_size)
		love.graphics.pop()
		love.graphics.line(data.x, data.y, data.tx, data.ty)
	end
	end)
end

function mod:drawAnalyser()

	game.cam:draw(function()
	for i,ship in ipairs(game.enemies) do
		if analyser:inRadius(ship) then
		love.graphics.setColor(50, 255, 50, 50)
		love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-20, ship.scale*2, 5)
		love.graphics.setColor(50, 255, 50, 255)
		love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-20, ship.scale*2*ship.armor/ship.armor_max, 5)
		love.graphics.setColor(255, 55, 250, 50)
		love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-15, ship.scale*2, 5)
		love.graphics.setColor(255, 55, 250, 255)
		love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-15, ship.scale*2*ship.shield/ship.shield_max, 5)
		love.graphics.setColor(255, 255, 0, 50)
		love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-10, ship.scale*2, 5)
		love.graphics.setColor(255, 255, 0, 255)
		love.graphics.rectangle("fill", ship.x-ship.scale, ship.y-ship.scale-10, ship.scale*2*ship.heat/ship.heat_max, 5)
		end
	end
	end)
end

function mod:setZoom(d)
    local last = self.zoom
    self.zoom = self.zoom + d/10
    if self.zoom < 0.1 then self.zoom = 0.1 end
    
    if w()/2/self.zoom > self.ship.data.visible_radius then
        self.zoom = last
    end
    self.cam:setScale(self.zoom)
    self.cam.x,self.cam.y = self.ship.x,self.ship.y
end

function mod:drawUI()
	suit.draw()
end

function mod:drawState()

end

function mod:drawMiniMap()

end


return mod