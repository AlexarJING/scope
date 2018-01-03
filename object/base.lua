local obj = class("obj_base")
obj.cls = "obj"
obj.obj_name = "obj_base"
function obj:init()
	game:addObject(self)
end

function obj:update(dt)
	if self.destroyed then return end
end


function obj:destroy()
	self.destroyed = true
end

return obj