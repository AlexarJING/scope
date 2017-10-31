local mod = class("teleport",obj.module.base)

mod.mod_name = "teleport"
mod.socket = "system"
mod.dist = 300
mod.cool_down = 5


function mod:update(dt)
    obj.module.base.update(self,dt)
   -- if 

end


return mod