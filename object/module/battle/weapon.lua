local weapon = class("weapon",obj.plugin.base)
weapon.stype = "universal"
weapon.pname = "hell fire"

weapon.fire_cd = 0.1 --发射间隔
weapon.chargeTime = 3 --充能时间
weapon.heat = 0 --单次发射的热量

weapon.fire_count = 1 --单次发射的子弹量
weapon.fire_offset = 0 --子弹的旋转偏移（可模拟子弹不精确，或随机子弹角度）

weapon.autoFire = true --自动开火
weapon.autoFireRange =  1300 --自动开火范围

weapon.autoTarget = true --自动寻的(武器自转)
weapon.target_type = "ship" --寻的类型 ship/bullet/all
weapon.rotSpeed = Pi--旋转速度 弧度/s
weapon.rotLimit = Pi/2 --单侧旋转角度限制


weapon.bullet = obj.others.laser --放出子弹类型 bullet/missile/decoy(分散放出型，诱使武器自爆)
weapon.hp = 1
weapon.scale = 10 --子弹碰撞大小
weapon.activeTime = 0.2 --子弹存活时间
weapon.activeRange = 500 --有效射程
weapon.tracing = true --跟踪能力
weapon.initVelocity = 0 --发射初速度
weapon.pushPower = 200 --自带推力
weapon.turnPower = 100 --自带扭力
weapon.linearDamping = 3 --线性速度衰减
weapon.angularDamping = 3 --旋转速度限制，提高力量的同时提高限制，提升灵敏程度，不至于跳
weapon.damage_type = "structure"--伤害类型 structure/energy/quantum(质子伤害，真实伤害，无差别的伤害)
weapon.damage_point = 5
weapon.explosion_range = 0 --碰撞后伤害半径如为0则单体伤害
weapon.through = 0 --碰撞后穿透 层数3 0为不穿透

weapon.drawTarget = true 
weapon.drawRange = true

weapon.verts = {
	
}
function weapon:init(...)
	obj.plugin.base.init(self,...)
	self.fire_timer = 0
	self.charge_timer = self.chargeTime
	self.rot = 0
end

function weapon:update(dt)
	self:sync()
	if self.autoTarget then
		self:getTarget()
		self:traceTarget(dt)
	end
	self:fireControl(dt)
end

function weapon:sync()
	local x,y = math.axisRot(
			self.slot.offx*self.ship.scale,
			self.slot.offy*self.ship.scale,
			self.ship.angle)
	self.x = self.ship.x + x
	self.y = self.ship.y + y
	self.angle = self.ship.angle+self.slot.rot*Pi + self.rot
end

function weapon:getRadar()
	if not self.detection or not self.detection.enabled then
		for _,slot in ipairs(self.ship.slot.universal) do
			if slot.plugin and slot.plugin.isSensor and slot.plugin.enabled then
				self.detection = slot.plugin
			end
		end
	end
	if not self.detection then self:destroy() end

	if not self.detection or not self.detection.enabled then
		for _,slot in ipairs(self.ship.slot.universal) do
			if slot.plugin and slot.plugin.isSensor and slot.plugin.enabled then
				self.detection = slot.plugin
			end
		end
	end
	if not self.detection then self:destroy() end
end

function weapon:getTarget()
	if not self.radar then self:getRadar() end
	local targets = self.radar.targets
	--self.rot = 0
	self.target = nil
	if not targets then	
		return 
	end
	for i = 1,#targets do
		local target = targets[i].obj
		local dist = targets[i].dist
		local rot = math.unitAngle(math.getRot(self.x,self.y,target.x,target.y)-self.ship.angle)
		if dist<self.autoFireRange and rot> -self.rotLimit and rot< self.rotLimit 
			and (self.target_type == targets[i].ttype or self.target_type == "all")then
			self.target = target
			return
		end
	end
end

function weapon:fireControl(dt)
	self.fire_timer = self.fire_timer - dt
	if self.fire_timer<0 and not self.ship.overheat and 
		((self.target and self.autoFire) or 
		(not self.autoFire and self.ship.openFire))  then
			self.charge_timer =  self.charge_timer - dt
			if self.charge_timer<=0 then
				self.fire_timer = self.fire_cd
				self.ship.heat = self.ship.heat + self.heat
				for i = 1,self.fire_count do
					self.bullet(self,self.x,self.y,
						self.angle-love.math.random()*self.fire_offset*2+self.fire_offset)
				end
			end
	else
		self.charge_timer = self.chargeTime
	end
end

function weapon:traceTarget(dt)
	if not self.target then return end
    local tx,ty = self.target.x,self.target.y
	local rot = math.unitAngle(math.getRot(self.x,self.y,tx,ty))
	self.angle = math.unitAngle(self.angle)
    if rot>self.angle and math.abs(rot - self.angle)< math.pi or
		 rot<self.angle and  math.abs(rot - self.angle)> math.pi then
		self.rot = self.rot + self.rotSpeed * dt
	else
		self.rot = self.rot - self.rotSpeed * dt
	end 

	if self.rot > self.rotLimit then
		self.rot = self.rotLimit
	end
	if self.rot < - self.rotLimit then
		self.rot = - self.rotLimit
	end
end

function weapon:draw()
	if self.ship ~= game.player then return end
	if self.target and self.drawTarget then
		local target = self.target
		love.graphics.push()
		love.graphics.rotate(-self.ship.angle)
		love.graphics.translate(-self.x, -self.y)		
		love.graphics.translate(target.x, target.y)
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.line(-self.scale,0,self.scale,0)
		love.graphics.line(0,-self.scale,0,self.scale)
		love.graphics.circle("line", 0, 0, self.scale/2)
		love.graphics.pop()
		love.graphics.print(tostring(self.target))
	end

	if self.drawRange then
		love.graphics.setColor(0, 255, 0, 20)
		love.graphics.arc("fill", 0, 0, self.autoFireRange, -self.rotLimit-Pi/2, self.rotLimit-Pi/2)
	end
end

return weapon