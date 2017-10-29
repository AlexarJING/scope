local radar = class("visible radar",obj.module.base)
radar.coverage = 1
radar.heat = 5
radar.mod_name = "visible radar"
radar.mod_type = "system"
radar.radius = 5000

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
            if dist<self.radius then
                table.insert(self.targets,{
                    ox = obj.ox,oy = obj.oy,x = obj.x, y = obj.y, angle = obj.angle, scale = obj.scale,
                    dist = dist, azi = math.getRot(x,y,obj.x,obj.y),tag = obj.tag,
                    team = obj.visual_team or obj.team, exhausted = obj.exhausted,
                    verts = obj.verts,obj = obj

                })
            end
        end
        return true
    end
    game.world:queryBoundingBox(x-self.radius, y-self.radius, 
        x+self.radius, y+self.radius, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
    self.ship.data.visible_world = self.targets
    self.ship.data.visible_radius = self.radius
end
return radar