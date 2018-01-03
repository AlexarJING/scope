local info = {}
local unit
function info:init(ui)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	unit = self.ui.unit
	self.x = w()-16*unit
	self.y = h()/2 - 25*unit
	self.w = 15*unit 
	self.h = 10*unit
	return self
end

function info:update(dt)
	local target = self.ship.data.target
	if not target then return end
	suit.Panel(self.x,self.y,self.w,self.h)
    suit.Label(
        string.format("name: %s\ngrade: %d",target.ship_name,target.grade),
        self.x,self.y+10*unit,self.w,10*unit)
end



function info:draw()
	love.graphics.print(self.ship.data.target and self.ship.data.target.ship_name or "nil",self.x-500,self.y)
	local target = self.ship.data.target
	if not target then return end
	love.graphics.setColor(100, 100, 255, 255)
	love.graphics.push()
	love.graphics.translate(self.x+self.w/2, self.y+5*unit)
	love.graphics.outlinePolygon(self.ship.verts,unit*4)
	love.graphics.pop()
end


return info