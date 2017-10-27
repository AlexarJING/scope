local radar = class("energy radar",obj.module.base)
radar.coverage = 1
radar.heat = 5
radar.mod_name = "energy radar"
radar.mod_type = "system"
radar.radius = 2000

function radar:update(dt)
    obj.module.base.update(self,dt)
    self:findTarget()
end

function radar:findTarget()
    local x,y = self.ship.x,self.ship.y
    self.targets = {}
    local callback = function(fixture)
        local obj = fixture:getUserData()
        if not obj.destroyed then          
            local dist = math.getDistance(x,y,obj.x,obj.y)
            if dist<self.radius and obj.heat>0  then
                table.insert(self.targets,{
                    x = obj.x, y = obj.y, 
                    dist = dist, azi = math.getRot(x,y,obj.x,obj.y),
                    heat = obj.heat
                })
            end
        end
        return true
    end
    game.world:queryBoundingBox( x-self.radius, y-self.radius, 
        x+self.radius, y+self.radius, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
    self.ship.data.energy_world = self.targets
    self.ship.data.energy_radius = self.radius
end

return radar