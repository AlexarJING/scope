local menu = {}
local unit

menu.windowName = {"selfcheck","stockage","message","logbook","exchange","dockyard"}
function menu:init(ui)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	unit = self.ui.unit
	self.popButton = {txt = "<",x = 10,y = 10, w = 2*unit, h =4*unit}
	self.mainMenu = {ox = -w(), tx = 5*unit, cx = 20+2*unit, y = 10,bw = 10*unit,bh = 4*unit}
	self.currentWindow = nil
	--[[
	self.windows = {
	selfcheck = require("scr/ui_elements/selfcheck"):init(menu),
	stockage = require("scr/ui_elements/selfcheck"):init(menu),
	message = require("scr/ui_elements/selfcheck"):init(menu),
	logbook = require("scr/ui_elements/selfcheck"):init(menu),
	exchange = require("scr/ui_elements/selfcheck"):init(menu),
	dockyard = require("scr/ui_elements/selfcheck"):init(menu),
	}]]
	self.buttons = {
		buttons = {
		{text = "close"},
		{text = "buy"}}
	}

	self.items = {
		{"test 1"},
		{"test 2"},
		{"test 3"},
		{"test 4"},
		{"test 5"},
		{"test 6"},
		{"test 7"},
		{"test 8"},
	}

	self.list = {
		item_height = 100,
		items = self.items
	}
	return self
end


function menu:update(dt)
	local main = self.mainMenu
	--tx = 20+2*unit
	for i = 1, 6 do
		if suit.Button(self.windowName[i],main.cx+(i-1)*(main.bw+unit),main.y,main.bw,main.bh).hit then
			self.currentWindow = menu.buttons[i]
		end
	end
	local pop = self.popButton
	if suit.Button(pop.txt,pop.x,pop.y,pop.w,pop.h).hit then
		if pop.txt == "<" then
			pop.txt = ">"
			pop.tween = tween.new(1,main,{cx = main.ox},"inOutQuart")

		else
			pop.txt = "<"
			pop.tween = tween.new(1,main,{cx = main.tx},"inOutQuart")
		end
	end
	if pop.tween then pop.tween:update(dt) end
	--frame.update({title = "xxxxxxxxxxxxxx trading center xxxxxxxxxxxxxx",x = w()/2-400,y = h()/2-250,w = 800, h = 400})
	
	

	suit.Frame("trading center No.10231",self.buttons,w()/2-400, h()/2-250, 800,400)

	suit.List("test",self.list,300,100,400,500)
	
end

function menu:draw()

end

return menu