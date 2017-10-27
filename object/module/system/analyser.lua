local analyser = class("analyser",obj.module.base)
analyser.coverage = 0.4
analyser.heat = 1
analyser.mod_name = "brain"
analyser.mod_type = "universal"
analyser.radius = 5000
function analyser:init(ship,slot)
	obj.module.base.init(self,ship,slot)
	game.hud.drawFoeState = self.foedraw
end


function analyser:inRadius(ship)
	local player = game.player
	local rad = h()/3
	local dist = math.getDistance(player.x,player.y,ship.x,ship.y)
    return dist*game.cam.scale<rad
end



return analyser