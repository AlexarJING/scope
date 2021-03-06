local exp = {}
local lifeMax = 3
function exp:init()
	self.lines = {}
	return self
end

function exp:add(x,y,angle,verts,scale,color)

	local verts = math.polygonTrans(x,y,angle,scale,verts)
	for i = 1, #verts/2-2, 2 do
		local line = {
			verts[i*2-1],verts[i*2],
			verts[i*2+1],verts[i*2+2],
		}
		local cx = love.math.random(verts[i*2-1],verts[i*2+1])
		local cy = love.math.random(verts[i*2] , verts[i*2+2])
		local vx,vy = love.math.random(-100,100),love.math.random(-100,100)
		local vr = love.math.random(-100,100)
		table.insert(self.lines,{
			line = line,
			cx = cx,cy = cy,
			vx = vx,vy = vy,vr = vr,
			life = lifeMax, color = color
			})
	end
end


function exp:update(dt)

	local newline = {}
	for i, obj in ipairs(self.lines) do
		obj.life = obj.life - dt
		if obj.life > 0 then
			local line = obj.line
			line[1],line[2] = line[1] + obj.vx, line[2]+ obj.vy
			line[3],line[4] = line[3] + obj.vx, line[4]+ obj.vy
			obj.cx,obj.cy = obj.cx + obj.vx,obj.cy + obj.vy
			line[1],line[2] = math.axisRot_P(line[1],line[2],obj.cx,obj.cy,obj.vr*dt)
			line[3],line[4] = math.axisRot_P(line[3],line[4],obj.cx,obj.cy,obj.vr*dt)
			table.insert(newline,obj)
		end
	end
end


function exp:draw()
	
	for i, obj in ipairs(self.lines) do
		local color = obj.color
		love.graphics.setColor(color[1], color[2], color[3], color[4]*obj.life/lifeMax)
		love.graphics.line(obj.line)
	end
end

return exp