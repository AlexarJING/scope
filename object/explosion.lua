local exp = class("explosion")

function exp:init(x,y,scale)
	self.x = x
	self.y = y
	self.r_max = love.math.random(scale*1.5,scale*2)
	self.r1 = 0
	self.r2 = 0
	self.offx = -love.math.random()*0.6*scale + 0.3*scale
	self.offy = -love.math.random()*0.6*scale + 0.3*scale
	self.lifeMax =3
	self.life = self.lifeMax
	table.insert(game.objects,self)
end

function exp:update(dt)
	self.life = self.life - dt
	if self.life < 0 then self.destroyed = true end
	self.r1 = self.r1 + self.r_max/10
	if self.r1>self.r_max then self.r1 = self.r_max end
	self.r2 = self.r2 + self.r_max/14
	
end


function exp:draw()
	local function to_cut()
		love.graphics.circle("fill", self.x+self.offx,self.y+self.offy,self.r2)
	end
	love.graphics.stencil(to_cut, "replace", 1)

    love.graphics.setStencilTest("less", 1)
 
    love.graphics.setColor(255, 255, 255-255*self.life/self.lifeMax, 255)
    love.graphics.circle("fill", self.x,self.y,self.r1)
 	
    love.graphics.setStencilTest()
end

return exp