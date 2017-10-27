local radar = class("fire ctrl radar",obj.module.base)
radar.coverage = 1
radar.heat = 5
radar.mod_name = "firectrl radar"
radar.mod_type = "system"
radar.radius = 1000
radar.predict_time = 1
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
                local vx,vy = self.ship.body:getLinearVelocity()
                table.insert(self.targets,{
                    x = obj.x, y = obj.y,
                    vx = vx, vy = vy,
                    tx = vx*self.predict_time , ty = vy*self.predict_time
                })
            end
        end
        return true
    end
    game.world:queryBoundingBox( self.x-self.radius, self.y-self.radius, 
        self.x+self.radius, self.y+self.radius, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
    self.ship.data.fire_control = self.targets
end

return radar