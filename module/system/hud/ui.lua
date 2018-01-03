local ui = {}
local root = "module/system/hud/ui_elements/"
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
	self.status = require(root.."status"):init(self)
	self.actions =  require(root.."actions"):init(self)
	self.mini_map =  require(root.."mini_map"):init(self)
	self.menu = require(root.."menu"):init(self)
	self.res = require(root.."resource"):init(self)
	self.target_info = require(root.."target_info"):init(self)
	return self
end

function ui:update(dt)
	self.status:update(dt)
	self.actions:update(dt)
	self.mini_map:update(dt)
	self.menu:update(dt)
	self.res:update(dt)
	self.target_info:update(dt)
end

function ui:draw()
	suit.diffused = self.diffused
	suit.draw()
	self.status:draw()
	self.actions:draw()
	self.mini_map:draw()
	self.menu:draw()
	self.res:draw()
	self.target_info:draw()
end


return ui