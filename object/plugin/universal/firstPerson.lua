local f = class("first",obj.plugin.base)
f.stype = "universal"
f.pname = "nake eye"
function f:update(dt)
	game.cam:setAngle(self.ship.angle)
	game.cam:setPosition(self.ship.x+200*math.sin(self.ship.angle),self.ship.y-200*math.cos(self.ship.angle))
end

return f