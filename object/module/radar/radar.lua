local radar = class("radar",obj.module.base)
radar.mod_name = "base_radar"
radar.socket = "radar"
radar.radius = 5000

radar.detect_attribute = {
	"ox","oy","x","y","vx","vy","angle","scale","tag","verts",
	"team","state","heat",
	"dist","azi"	
}

radar.detect_type = "visual"

function radar:init(...)
    obj.module.base.init(self,...)
    self.ship.data[self.detect_type.."_radius"] = self.radius
end

function radar:update(dt)
    obj.module.base.update(self,dt)
    self:findTarget()

end


function radar:findTarget()
    local x,y = self.ship.x,self.ship.y
    local world = {}
    local callback = function(fixture)
        local obj = fixture:getUserData()
        if not obj.destroyed then
        	table.insert(world,obj)     	
        end
        return true
    end
    game.world:queryBoundingBox(x-self.radius, y-self.radius, 
        x+self.radius, y+self.radius, callback )
   -- table.sort(self.targets,function(a,b) return a.dist<b.dist end)
   self.ship.data.world[self.detect_type] = world

end


function radar:shut_down()
    self.ship.data.world[self.detect_type] = {}
end
return radar