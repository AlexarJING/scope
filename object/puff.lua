local puff = class("puff")

function puff:init(x,y)
	self.x = x
	self.y = y
	self.w = love.math.random(1,20)
	self.h = love.math.random(1,20)
	self.vw = 0.2
	self.vh = 0.2
	self.lifeMax =love.math.random(1,5)*0.3
	self.life = self.lifeMax
	table.insert(game.objects,self)
end

function puff:update(dt)
	self.life = self.life - dt
	if self.life < 0 then self.destroyed = true end
	self.w = self.w + self.vw
	self.h = self.h + self.vh
end


function puff:draw()
	love.graphics.setColor(100,100,100,255*self.life/self.lifeMax)
	love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
	love.graphics.setColor(100,100,100,255*self.life/self.lifeMax/3)
	love.graphics.rectangle("fill", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
end

return puff