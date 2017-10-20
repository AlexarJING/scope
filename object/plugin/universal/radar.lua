local radar = class("radar",obj.plugin.base)
radar.cover = 0.4
radar.heat = 5
radar.pname = "eagle eyes"
radar.stype = "universal"
radar.radius = 5000
function radar:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = radar.pname
	game.hud.drawRadar = self.radardraw
end

function radar:radardraw()
	local player = self.player
    for i,s in ipairs(game.enemies) do
        local kx,ky=(s.x-player.x)/(0.5*w()/game.cam.scale),(s.y-player.y)/(0.5*h()/game.cam.scale)
        if math.abs(kx)>1 or math.abs(ky)>1 then -- 在当前视野范围外
            local dist_norm = (kx^2+ky^2)^0.5   -- 归一化距离
            local _=255-dist_norm*20
            if _>0 then
                love.graphics.setColor(255, 0, 0, _)
                if math.abs(kx)>math.abs(ky) then
                    love.graphics.circle("fill", 0.5*math.abs(kx)/kx*w()+0.5*w(), 0.5*h()+h()/math.abs(kx)*ky*0.5, 8)
                else
                    love.graphics.circle("fill", 0.5*w()+w()/math.abs(ky)*kx*0.5, 0.5*math.abs(ky)/ky*h()+0.5*h(), 8)
                end
            end
        end
    end
end

return radar