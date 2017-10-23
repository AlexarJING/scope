local radar = class("radar",obj.plugin.base)
radar.cover = 0.4
radar.heat = 5
radar.pname = "eagle eyes"
radar.stype = "universal"
radar.isSensor = true
radar.radius = 5000
local instant
function radar:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = radar.pname 
    instant = self   
end


function radar:update(dt)
    if self.ship == game.player then
        game.hud.radar = self
    else
        return
    end
    self.x = self.ship.x
    self.y = self.ship.y
    obj.plugin.base.update(self,dt)
    self:findTarget()
end

function radar:radardraw()
	local player = game.player
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

    if player.target then
        local target  =player.target
        love.graphics.push()
        love.graphics.translate(target.x, target.y)
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.rectangle("line", target.x-target.scale, target.y-target.scale, target.scale*2, target.scale*2)
        love.graphics.pop()
    end
end



function radar:findTarget()
    self.target = self.ship.target
    local dist
    if self.target then 
        if self.target.destroyed then 
            self.target = nil 
        else
            dist = math.getDistance(self.target.x,self.target.y,self.x,self.y)
            if dist>self.radius then
                self.target = nil
            end
        end
    end
    if self.target then
        self.targets = {{obj = self.target, dist = dist ,ttype = "ship"}}
        return
    end

    self.targets = {}
    local callback = function(fixture)
        local obj = fixture:getUserData()
        if obj.team ~= self.ship.team and not obj.destroyed then          
            local dist = math.getDistance(self.x,self.y,obj.x,obj.y)
            if dist<self.radius then
                table.insert(self.targets,{obj = obj,dist = dist , ttype = obj.tag})
            end
        end
        return true
    end
    game.world:queryBoundingBox( self.x-self.radius, self.y-self.radius, 
        self.x+self.radius, self.y+self.radius, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
end

return radar