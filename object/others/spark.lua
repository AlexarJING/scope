local spark=Class("spark")
local count = 15

function spark:initialize(x,y,norm)
	self.x,self.y=x,y
	self.speedX=-5+love.math.random()*10
	self.speedY=-5+love.math.random()*10
	self.life=0.2
	table.insert(game.spark, self)
end

function spark:newLine()


end


function spark:update(dt)
	dt=dt or 1/60
	if self.destroy then 
		return 
	end
	self.life=self.life-dt
	if self.life<0 then 
		self.destroy=true 
		self.dead=true
	end	
	self.ox,self.oy=self.x,self.y
	self.x=self.x+self.speedX/2
	self.y=self.y+self.speedY/2
end



function spark:draw()
	if not self.life then return end
	if self.destroy then return end
	local a=game:getVisualAlpha(self)
	love.graphics.setColor(255,255,0,a)
	love.graphics.setLineWidth(2)
	love.graphics.line(self.x,self.y, self.ox,self.oy )
end

return spark