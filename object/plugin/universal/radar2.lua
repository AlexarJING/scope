local radar = class("radar2",obj.plugin.base)
radar.cover = 0.4
radar.heat = 5
radar.pname = "sky eyes"
radar.stype = "universal"
radar.radius = 5000
function radar:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = radar.pname
	game.hud.drawRadar = self.radardraw
end

function radar:radardraw()
	love.graphics.setColor(0, 255, 0, 255)
	local rad = h()/3
    love.graphics.circle("line", w()/2, h()/2, rad)

	local player = self.player
    for i,s in ipairs(game.enemies) do
       	local dist = math.getDistance(player.x,player.y,s.x,s.y)
        if dist*game.cam.scale>rad then
            local angle = math.getRot(player.x,player.y,s.x,s.y)
            love.graphics.circle("fill", w()/2+math.sin(angle)*rad, h()/2-math.cos(angle)*rad, 5)
        end
    end
end


return radar