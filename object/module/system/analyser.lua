local analyser = class("analyser",obj.module.base)
analyser.heat = 1
analyser.mod_name = "brain"
analyser.mod_type = "system"
analyser.radius = 500
function analyser:init(...)
	obj.module.base.init(self,...)
	self.objBuffer = {}
end
function analyser:update(dt)
	obj.module.base.update(dt)
	local world = self.ship.data.visible_world
	if not world then return end
	local detailData = {}
	for i, data in ipairs(world) do
		local obj = data.obj
		if obj.dist<self.radius then
			detailData[i] = {
				obj = obj,
				team = obj.team,
				struct = obj.struct,
				energy = obj.energy,
				heat = obj.heat,
				slots = obj.slots
			}
		end
	end
	self.ship.data.detailData = detailData
end



return analyser