local frag=class("fragment")




function frag:init(x,y,rot,canvas)	
	self.during=3
	self.life=self.during
	self.speed=0.1
	self.selfRot=0
	self.rate=4
	self.canvas=canvas
	self.quads={}
	self.sw=canvas:getWidth()
	self.sh=canvas:getHeight()
	self.sizeX=self.sw/self.rate
	self.sizeY=self.sh/self.rate
	self.x=x
	self.y=y
	self.rot=rot
	self:separate()
	self:setSpeed()
	table.insert(game.objects,self)
end

function frag:separate()
	for x= 1,self.rate do
		self.quads[x]={}
		for y= 1,self.rate do
			self.quads[x][y]  = love.graphics.newQuad((x-1)*self.sizeX,(y-1)*self.sizeY,
												self.sizeX, self.sizeY, self.sw, self.sh)
		end
	end
end

function frag:setSpeed()
	self.qX={}
	self.qY={}
	self.qSpeedX={}
	self.qSpeedY={}
	self.qSRot={}
	self.qSRotSpeed={}
	for x= 1,self.rate do
		self.qSpeedX[x]={}
		self.qSpeedY[x]={}
		self.qSRotSpeed[x]={}
		self.qSRot[x]={}
		self.qX[x]={}
		self.qY[x]={}

		for y= 1,self.rate do
			self.qSRotSpeed[x][y] = love.math.random()*0.03
			self.qSRot[x][y] = 0
			self.qX[x][y]=self.x-self.sw/2+self.sizeX*x-0.5*self.sizeX
			self.qY[x][y]=self.y-self.sh/2+self.sizeY*y-0.5*self.sizeY
			self.qX[x][y],self.qY[x][y]=math.axisRot_P(self.qX[x][y],self.qY[x][y],self.x,self.y,self.rot)
			self.qSpeedX[x][y]=(self.qX[x][y]-self.x)*self.speed*love.math.random()
			self.qSpeedY[x][y]=(self.qY[x][y]-self.y)*self.speed*love.math.random()			
			self.qSRot[x][y] = self.rot
		end
	end	

end

function frag:update(dt)

	self.life=self.life -dt
	if self.life<0 then self.destroyed=true end
	for x= 1,self.rate do
		for y= 1,self.rate do
			self.qX[x][y]=self.qX[x][y]+self.qSpeedX[x][y]
			self.qY[x][y]=self.qY[x][y]+self.qSpeedY[x][y]
			self.qSRot[x][y]=self.qSRot[x][y]+self.qSRotSpeed[x][y]		
		end
	end	
end


function frag:draw(offx,offy)
	offx=offx or 0
	offy=offy or 0
	
	love.graphics.setColor(255, 255, 255, 255*self.life/self.during)
	for x= 1,self.rate do
		for y= 1,self.rate do
			love.graphics.draw(self.canvas, self.quads[x][y],self.qX[x][y]+offx, self.qY[x][y]+offy, self.qSRot[x][y],1,1,self.sizeX/2,self.sizeY/2)			
		end
	end
	--love.graphics.draw(self.canvas,self.x,self.y,self.rot,1,1,self.sw/2,self.sh/2)
end

return frag