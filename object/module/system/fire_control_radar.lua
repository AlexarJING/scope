local radar = class("fire ctrl radar",obj.module.base)
radar.coverage = 1
radar.heat = 5
radar.mod_name = "firectrl radar"
radar.mod_type = "system"
radar.radius = 2000
radar.predict_time = 0.3
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
                local vx,vy = obj.body:getLinearVelocity()
                table.insert(self.targets,{
                    x = obj.x, y = obj.y,angle = obj.angle,
                    vx = vx, vy = vy,
                    tx = vx*self.predict_time + obj.x, ty = vy*self.predict_time+obj.y,
                    obj = obj,tag = obj.tag,dist = dist
                })
            end
        end
        return true
    end
    game.world:queryBoundingBox( x-self.radius, y-self.radius, 
        x+self.radius, y+self.radius, callback )
    self.ship.data.fire_control_world = self.targets
    self.ship.data.fire_ctrl_radius = self.radius
end

return radar