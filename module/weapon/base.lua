local weapon = class("weapon",cls.mod.base)
weapon.socket = "weapon"
weapon.mod_name = "hell fire"
weapon.heat_produce = 15
weapon.heat_radiating = 30
weapon.heat_volume = 100
weapon.heat_per_sec = 0


weapon.cool_down = 0.2 --发射间隔
weapon.chargeTime = 0 --充能时间
weapon.heat_per_shot = 10 --单次发射的热量
weapon.heat_radiating = 5
weapon.fire_count = 1 --单次发射的子弹量
weapon.fire_offset = 0 --子弹的旋转偏移（可模拟子弹不精确，或随机子弹角度）

weapon.autoFire = false --自动开火
weapon.autoFireRange =  1300 --自动开火范围

weapon.autoTarget = true --自动寻的(武器自转)
weapon.target_type = "ship" --寻的类型 ship/bullet/all
weapon.rotSpeed = Pi--旋转速度 弧度/s
weapon.rotLimit = Pi/4 --单侧旋转角度限制

weapon.bullet = "bullet" --放出子弹类型 bullet/missile/decoy(分散放出型，诱使武器自爆)
weapon.struct = 1
weapon.scale = 10 --子弹碰撞大小
weapon.activeTime = 1 --子弹存活时间
weapon.activeRange = 500 --有效射程
weapon.tracing = false --跟踪能力
weapon.initVelocity = 1200 --发射初速度
weapon.pushPower = 200 --自带推力
weapon.turnPower = 100 --自带扭力
weapon.linearDamping = 0 --线性速度衰减
weapon.angularDamping = 3 --旋转速度限制，提高力量的同时提高限制，提升灵敏程度，不至于跳
weapon.damage_type = "structure"--伤害类型 structure/energy/quantum(量子伤害，真实伤害，无差别的伤害)
weapon.damage_point = 5
weapon.explosion_range = 0 --碰撞后伤害半径如为0则单体伤害
weapon.through = 0 --碰撞后穿透 层数3 0为不穿透
weapon.bullet_tag = "bullet"
weapon.drawTarget = true 
weapon.drawRange = true

weapon.verts = {
	0,-0.5,0.3,0.3,-0.3,0.3
}
function weapon:init(...)
	cls.mod.base.init(self,...)
	self.cd_timer = 0
	self.charge_timer = self.chargeTime
    self.bullet = cls.obj.emission[self.bullet]
	self.rot = 0
end

function weapon:update(dt)
	cls.mod.base.update(self,dt)
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
	self.rot = math.unitAngle(self.rot)
end



function weapon:getTarget()
	self.target = nil
	if self.ship.data.mouse then
		self.target = self.ship.data.mouse
		return
	end

	if self.ship.data.target then
		self.target = self.ship.data.target
		return
	end

	local targets = self.ship.data.world.visual or self.ship.data.world.fire_ctrl
	if not targets then	
		return 
	end
	--table.sort(targets,function(a,b) return a.dist<b.dist end)
	local candidate
	local c_dist = 1/0
	for i = 1,#targets do
		local target = targets[i]
		local dist = self.ship:getDist(targets[i])
		local rot = self:getAzi(target)
		if  target.state == "active" and (self.target_type == targets[i].tag or self.target_type == "all")
				and (target.team and target.team~= self.ship.team) then
			if self.autoTarget then
				local rot = self:getAzi(target)
				if dist<self.autoFireRange and rot> -self.rotLimit and rot< self.rotLimit then
					if dist<c_dist then
						c_dist = dist
						candidate = target
					end
				end
			else
				if dist<c_dist then
					c_dist = dist
					candidate = target
				end
			end
		end	
	end
	self.target = candidate
	self.target_dist = c_dist
end

function weapon:fireControl(dt)
	self.cd_timer = self.cd_timer - dt
	
end

function weapon:action()
    local dt = love.timer.getDelta()
    if self.cd_timer<0 and not self.ship.overheat and 
		((self.target and self.autoFire) or 
		(not self.autoFire and self.ship.data.action.fire))  then
			self.charge_timer =  self.charge_timer - dt
			 if self.charge_timer<=0 and self:produceHeatPerTime(self.fire_count) then
        self.cd_timer = self.cool_down
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
	if not self.target then 
		if self.rot > 0.1 then
			self.rot = self.rot - self.rotSpeed * dt
		elseif self.rot < -0.1 then
			self.rot = self.rot + self.rotSpeed * dt
		end
		return 
	end
    local tx,ty
    if self.target.vx then
    	local t = self.ship:getDist(self.target)/self.initVelocity 
        t = t>2 and 2 or t
    	tx,ty = self.target.vx * t + self.target.x, self.target.vy * t +  self.target.y
    else
    	tx,ty = self.target.x , self.target.y
    end 
	local rot = math.unitAngle(math.getRot(self.x,self.y,tx,ty))
	self.angle = math.unitAngle(self.angle)

    if rot>self.angle and math.abs(rot - self.angle)< math.pi or
		 rot<self.angle and  math.abs(rot - self.angle)> math.pi then
        self.rot = self.rot + self.rotSpeed * dt
	else
		self.rot = self.rot - self.rotSpeed * dt
	end 
	if self.rotLimit == Pi then return end
	if self.rot > self.rotLimit then
		self.rot = self.rotLimit
	end
	if self.rot < - self.rotLimit then
		self.rot = - self.rotLimit
	end
end


return weapon