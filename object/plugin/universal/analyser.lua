local analyser = class("analyser",obj.plugin.base)
analyser.cover = 0.4
analyser.heat = 1
analyser.pname = "brain"
analyser.stype = "universal"
analyser.radius = 5000
function analyser:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = analyser.pname
	game.hud.drawFoeState = self.foedraw
end


function analyser:inRadius(ship)
	local player = game.player
	local rad = h()/3
	local dist = math.getDistance(player.x,player.y,ship.x,ship.y)
    return dist*game.cam.scale<rad
end

function analyser:foedraw()
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

return analyser