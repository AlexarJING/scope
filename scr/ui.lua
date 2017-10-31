local ui = {}
ui.color = {
	normal   = {bg = { 66, 66, 166,50}, fg = {188,188,188}},
	hovered  = {bg = { 50,153,187}, fg = {255,255,255}},
	active   = {bg = {255,153,  0}, fg = {225,225,225}}
}
local unit = h()/80

function ui:init(hud)
	self.ship = hud.ship
	self.hud = hud
	self.state = {
		panel = {x = 10,y = h()-10-unit*20,w = unit*35,h=unit*20 },
		ship = {x = 10+ unit, y =h()-10-unit*20+unit, w = unit*10,h = unit*10, obj = self.hud.ship },
		buff = {x = 10+ unit, y =h()-10-unit*10+5*unit, w = unit*4, h = unit*4},
		bar = {offx = 6*unit, offy = unit*3, x = 10+ 12*unit, y= h()-10-unit*18,w = unit*15 ,h = unit*1.5}
	}

	self.action = {x = 20+ unit*35,y = h()- 10 - 8* unit, w = 81*unit , h = 8*unit , bw = 6*unit,bh = 6*unit }

	self.miniMap = {x = w()-22*unit-10,y = h()-10-22*unit,w = 22*unit,h = 22*unit}
	self.shop = {x = w()/2-40*unit, y = h()/2-30*unit, w = 80*unit, h = 45*unit, title = "xxxx trading center",bw = unit*10,bh = unit*4}
	--"status,stockage,message,event,exchange,dockyard,"
	self.popButton = {txt = "<",x = 10,y = 10, w = 2*unit, h =4*unit}
	self.mainMenu = {ox = -w(), tx = 5*unit, cx = 20+2*unit, y = 10,bw = 10*unit,bh = 4*unit}
	self.mainMenu.buttons = {"status","stockage","message","event","exchange","dockyard"}
	self.windows = {
		status = {show  = self.statusShow, draw = self.statusDraw},
		stockage = {show = self.stockageShow,draw = self.stockageDraw},
		message = {show = self.messageShow,draw = self.messageDraw},
		event = self.eventShow,
		exchange = self.exchangeShow,
		dockyard = self.dockyardShow
	}
	self.status = {x = w()/2-40*unit, y = h()/2-28*unit, w = 80*unit, h = 45*unit,
		 title = "xxxx ship status",bw = unit*10,bh = unit*4}
	self.stockage = {x = w()/2-40*unit, y = h()/2-28*unit, w = 80*unit, h = 45*unit,
		 title = "xxxx ship stockage",info = {min = 0,max = 10,step = 1,value = 0,vertical=true},}
	return self
end

function ui:update(dt)
	local panel = self.state.panel
	suit.Panel(panel.x,panel.y,panel.w,panel.h)
	local buff = self.state.buff
	for i = 1,8 do
		suit.Button("buff\n"..i,buff.x + (i-1)*(buff.w+2),buff.y,buff.w,buff.h)
	end
	
	local count = 0
	local mods = {}
	for socket, tab in pairs(self.ship.slot) do
		for i, slot in ipairs(tab) do
			count = count + 1
			local tab = {
				slot = slot,
				socket = socket,
				mod = slot.plugin,
				enabled = slot.enabled,
			}
			if tab.mod then
				tab.name = tab.mod.mod_name
				tab.timer = tab.mod.cd_timer
				tab.cd = tab.mod.cool_down
			else
				tab.name = "not used"
			end
			mods[count] = tab
		end
	end
	self.action.mods = mods
	local action = self.action
	
	if #mods<13 then
		suit.Panel(action.x,action.y,action.w,action.h)
		for i = 1, 12 do
			local mod = mods[i]
			if mod then
				local name = i.." ".."\n"..mod.name
				if suit.Button(name,
					{toggle = mod.slot.enabled},action.x + (i-1)*action.bw+6*i , action.y+unit,action.bw,action.bh).hit then
					mod.slot.enabled = not mod.slot.enabled
				end
			end
		end
	else
		suit.Panel(action.x,action.y-action.bh,action.w,action.h+action.bh)
		for i = 1, 12 do
			local mod = mods[i]
			if mod then
				local name = i.." ".."\n"..mod.name
				if suit.Button(name,
					{toggle = mod.slot.enabled},action.x + (i-1)*action.bw+6*i , action.y+unit-action.bh,action.bw,action.bh).hit then
					mod.slot.enabled = not mod.slot.enabled
				end
			end
		end
		for i = 13, 24 do
			local mod = mods[i]
			if mod then
				local name = i.." ".."\n"..mod.name
				if suit.Button(name,
					{toggle = mod.slot.enabled},action.x + (i-13)*action.bw+6*(i-13) , action.y+unit,action.bw,action.bh).hit then
					mod.slot.enabled = not mod.slot.enabled
				end
			end
		end
	end
	
	local mini = self.miniMap
	suit.Panel(mini.x,mini.y,mini.w,mini.h)
	

	local menu = self.mainMenu
	--tx = 20+2*unit
	for i = 1, 6 do
		if suit.Button(menu.buttons[i],menu.cx+(i-1)*(menu.bw+unit),menu.y,menu.bw,menu.bh).hit then
			self.currentWindow = menu.buttons[i]
		end
	end
	local pop = self.popButton
	if suit.Button(pop.txt,pop.x,pop.y,pop.w,pop.h).hit then
		if pop.txt == "<" then
			pop.txt = ">"
			pop.tween = tween.new(1,menu,{cx = menu.ox},"inOutQuart")

		else
			pop.txt = "<"
			pop.tween = tween.new(1,menu,{cx = menu.tx},"inOutQuart")
		end
	end
	if pop.tween then pop.tween:update(dt) end

	if self.currentWindow then
		self.windows[self.currentWindow].show(self)
	end
end

function ui:draw()
	suit.diffused = self.diffused
	suit.draw()
	self:drawCoolDown()
	self:drawState()
	self:drawMini()

	if self.currentWindow then
		self.windows[self.currentWindow].draw(self)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(tostring(self.ship.data.target),200,200)
	
	--self:drawShop()
end

function ui:drawRectPie(x,y,w,h,percent)
	if percent<0 then return end
	local function to_cut()
		love.graphics.arc("fill", x+w/2, y+h/2, w*2, -Pi/2, 2*Pi*(1-percent) -Pi/2)
	end
	love.graphics.stencil(to_cut, "replace", 1)

    love.graphics.setStencilTest("less", 1)
 
    love.graphics.setColor(100, 100, 255, 250)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(0, 0, 0, 250)    
end


function ui:drawCoolDown()
	local mods = self.action.mods
	local action = self.action
	if #mods<13 then
		for i = 1, 12 do
			local mod = mods[i]
			if mod and mod.cd then
				self:drawRectPie(action.x + (i-1)*action.bw+6*i , action.y+unit,action.bw,action.bh,mod.timer/mod.cd)
			end
		end
	else
		suit.Panel(action.x,action.y-action.bh,action.w,action.h+action.bh)
		for i = 1, 12 do
			local mod = mods[i]
			if mod and mod.cd then
				self:drawRectPie( action.x + (i-1)*action.bw+6*i , action.y+unit-action.bh,action.bw,action.bh,mod.timer/mod.cd)
			end
		end
		for i = 13, 24 do
			local mod = mods[i]
			if mod and mod.cd then
				self:drawRectPie( action.x + (i-13)*action.bw+6*(i-13) , action.y+unit,action.bw,action.bh,mod.timer/mod.cd)
			end
		end
	end
end


function ui:drawState()
	local ship = self.state.ship
	love.graphics.setColor(self.color.normal.fg)
	love.graphics.rectangle("line", ship.x, ship.y, ship.w, ship.h)
	love.graphics.push()
	love.graphics.translate(ship.x + ship.w/2,ship.y+ship.h/2)

	love.graphics.rotate(-ship.obj.angle)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("-Y", -ship.w/2, -ship.h/2,ship.w,"center")
	love.graphics.printf("+Y", -ship.w/2, ship.h/2 -love.graphics.getFont():getHeight(),ship.w,"center")
	love.graphics.print("-X", -ship.w/2, -love.graphics.getFont():getHeight()/2)
	love.graphics.print("+X", ship.w/2 -love.graphics.getFont():getWidth("+X") , -love.graphics.getFont():getHeight()/2)
	love.graphics.setColor(self.color.normal.bg)
	love.graphics.line(-ship.w/2, 0, ship.w/2, 0)
	love.graphics.line(0, -ship.h/2, 0, ship.h/2)
	love.graphics.circle("line", 0, 0, ship.w/2)

	love.graphics.setColor(255, 10, 155, 255)
	local vx,vy = ship.obj.body:getLinearVelocity()
	local angle = math.getRot(vx,vy,0,0)
	love.graphics.circle("fill", -math.sin(angle)*ship.w/2, math.cos(angle)*ship.w/2,3)

	love.graphics.rotate(ship.obj.angle)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.outlinePolygon(ship.obj.verts,unit*2)
	
	love.graphics.pop()

	love.graphics.printf(string.format("coord: %2d,%2d",ship.obj.x,ship.obj.y),ship.x,ship.y+ship.h+unit,ship.w+unit*3,"center")
	love.graphics.printf(string.format("speed: %2d,%2d",vx,vy),ship.x + ship.w+unit*5,ship.y+ship.h+unit,ship.w+unit*3,"center")
	local bar = self.state.bar
	love.graphics.print("struct", bar.x,bar.y )
	love.graphics.print("energy", bar.x,bar.y + bar.offy )
	love.graphics.print("heat", bar.x,bar.y + bar.offy*2)

	local player = self.hud.ship
    love.graphics.setColor(50, 255, 50, 50)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y, bar.w, bar.h)
    love.graphics.setColor(50, 255, 50, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx, bar.y, bar.w*player.struct/player.struct_max ,bar.h)
 
    love.graphics.setColor(255, 55, 250, 50)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy, bar.w, bar.h)
    love.graphics.setColor(255, 55, 250, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy, bar.w*player.energy/player.energy_max, bar.h)
    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy, bar.w*player.energy_occupied/player.energy_max, bar.h)
    love.graphics.setColor(255, 255, 0, 50)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy*2, bar.w, bar.h)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy*2, bar.w*player.heat/player.heat_max,bar.h)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(string.format("%3d/%3d",player.struct,player.struct_max), bar.x + bar.offx , bar.y , bar.w,"center")
    love.graphics.printf(string.format("%3d/%3d/%3d",player.energy_occupied,player.energy-player.energy_occupied,player.energy_max),bar.x + bar.offx , bar.y + bar.offy, bar.w,"center")
    love.graphics.printf(string.format("%3d/%3d",player.heat,player.heat_max),bar.x + bar.offx , bar.y + bar.offy*2, bar.w,"center")
end

function ui:drawMini()
	if not self.ship.data.visual_radius then return end
	local ship = self.ship
	local mini = self.miniMap
	local world_w = ship.data.visual_radius*2
	local fire_ctrl_w = ship.data.fire_ctrl_radius
	love.graphics.push()
	love.graphics.setLineWidth(1)
	love.graphics.translate(mini.x + mini.w/2, mini.y + mini.h/2)
	love.graphics.setColor(self.color.normal.bg)
	love.graphics.line(-mini.w/2, 0, mini.w/2, 0)
	love.graphics.line(0, -mini.h/2, 0, mini.h/2)
	love.graphics.circle("line", 0, 0, mini.w*fire_ctrl_w/world_w/2)
	love.graphics.setColor(255, 0, 0, 255)
	
	
	for i,tar in ipairs(ship.data.world.visual) do
		local x,y = tar.x - ship.x, tar.y - ship.y
		love.graphics.circle("fill", x*mini.w/world_w, y*mini.h/world_w, 2) 
	end

	love.graphics.pop()
end

function ui:drawShop()
	local shop = self.shop
	love.graphics.setColor(255, 255, 255, 255)
	local fh = love.graphics.getFont():getHeight()
	local fw = love.graphics.getFont():getWidth(shop.title)
	love.graphics.print(shop.title, shop.x + unit*5, shop.y - fh - unit)
	love.graphics.line(shop.x + unit*3,shop.y,
		shop.x + unit*5,shop.y - fh - 2*unit,
		shop.x + unit*5 + fw, shop.y - fh - 2*unit,
		shop.x + unit*7 + fw, shop.y
		)

end

function ui:statusShow()
	local s = self.status
	
	if suit.Button(s.title,s.x,s.y-s.h/10,s.w,s.h/10).hit then
		self.currentWindow = nil
	end
	suit.Panel(s.x,s.y,s.w,s.h)
	suit.Panel(s.x,s.y,s.w/4,s.h)
	suit.Label("hers is description of the ship,or the hovered slot",s.x,s.y,s.w/4,s.h)
	suit.Panel(s.x + s.w-s.w/2.5,s.y,s.w/2.5,s.h)
	for i = 1,12 do 
		suit.Button("slot "..i.." name",s.x + s.w-s.w/2.5,s.y +(i-1)*s.h/12,s.w/2.5,s.h/12)
	end
end

local slot_size = 30

function ui:slotDraw(offx,offy,rot,index)
	love.graphics.push()
	love.graphics.translate(offx, offy)
	love.graphics.rotate(rot)
	love.graphics.setColor(50, 250, 50, 150)
	love.graphics.rectangle("fill",  - slot_size/2,  - slot_size/2, slot_size, slot_size)
	love.graphics.setColor(255, 255, 255, 250)
	love.graphics.polygon("fill", 0, - slot_size/2, - slot_size/2, slot_size/2, slot_size/2,slot_size/2)
	love.graphics.rotate(-rot)
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.printf(index, - slot_size/2,  -2, slot_size, "center")
	love.graphics.pop()
end

function ui:statusDraw()
	local s = self.status
	local ship = self.ship
	local cx,cy = w()/2 - 5*unit, h()/2-5*unit
	love.graphics.push()
	love.graphics.translate(cx,cy)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.outlinePolygon(ship.verts,unit*10)
	local index = 0
	for slot_type,slots in pairs(ship.slot) do
		for i,slot in ipairs(slots) do
			index = index + 1
			self:slotDraw(unit*slot.offx*10,unit*slot.offy*10,slot.rot*Pi,index)
		end
	end
	love.graphics.pop()

end

function ui:stockageShow()
	local s = self.stockage
	
	if suit.Button(s.title,s.x,s.y-s.h/10,s.w,s.h/10).hit then
		self.currentWindow = nil
	end

	
	suit.Panel(s.x,s.y,s.w,s.h)
	suit.Panel(s.x,s.y,s.w/4,s.h)
	suit.Label("hers is description of the items",s.x,s.y,s.w/4,s.h)
	suit.Panel(s.x +s.w/4,s.y,s.w - s.w/4,s.h)
	if suit.Slider(s.info,s.info,
		s.x+s.w ,s.y + 5,unit*2,s.h-10).changed then
	end
	local w = (3*s.w/4)
	local h = s.h/9
	--for i = 1,5 do
		for j = 1,9 do 
			suit.Button("container"..j.."\n item name",
				s.x +s.w/4 , s.y + (j-1)*h,w,h)
		end
	--end
end

function ui:stockageDraw()

end

function ui:messageShow()
	local s = self.stockage
	
	if suit.Button(s.title,s.x,s.y-s.h/10,s.w,s.h/10).hit then
		self.currentWindow = nil
	end

	
	suit.Panel(s.x,s.y,s.w,s.h)
	suit.Panel(s.x,s.y,s.w/4,s.h)
	suit.Label("hers is description of the items",s.x,s.y,s.w/4,s.h)
	suit.Panel(s.x +s.w/4,s.y,s.w - s.w/4,s.h)
	if suit.Slider(s.info,s.info,
		s.x+s.w ,s.y + 5,unit*2,s.h-10).changed then
	end
	local w = (3*s.w/4)/5
	local h = s.h/9
	--for i = 1,5 do
		for j = 1,9 do 
			suit.Button("container"..j.."\n item name",
				s.x +s.w/4 , s.y + (j-1)*h,w,h)
		end
	--end
end

function ui:messageDraw()

end


return ui