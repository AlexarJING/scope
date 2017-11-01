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
	self.unit = unit
	self.status = require("scr/ui_elements/status"):init(self)
	self.actions =  require("scr/ui_elements/actions"):init(self)
	self.mini_map =  require("scr/ui_elements/mini_map"):init(self)

	self.menu = require("scr/ui_elements/menu"):init(self)

	
	return self
end

function ui:update(dt)
	self.status:update(dt)
	self.actions:update(dt)
	self.mini_map:update(dt)
	self.menu:update(dt)
end

function ui:draw()
	suit.diffused = self.diffused
	suit.draw()
	self.status:draw()
	self.actions:draw()
	self.mini_map:draw()
	self.menu:draw()


	--self:drawState()
	--self:drawMini()

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