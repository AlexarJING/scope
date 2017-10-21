local c={}

local function begin(a,b,coll)
	local objA=a:getUserData()
	local objB=b:getUserData()
	if objA.team== objB.team then
		coll:setEnabled(false)
		return
	end
	if objA.tag == "bullet" and objB.tag == "ship" then
		objA:destroy()
		objB:damage(objA.damage_point,objA.damage_type)
	end 
end

local function pre(a,b,coll)
	local objA=a:getUserData()
	local objB=b:getUserData()
	if objA.team== objB.team then
		coll:setEnabled(false)
		return
	end
end

local function post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	local objA=a:getUserData()
	local objB=b:getUserData()


end


local function endC(a,b,coll)
	local objA=a:getUserData()
	local objB=b:getUserData()
	
end


function c.begin(a,b,coll)
	begin(a,b,coll)
	begin(b,a,coll)
end

function c.leave(a,b,coll)
	endC(a,b,coll)
	endC(b,a,coll)
end

function c.pre(a,b,coll)
	pre(a,b,coll)
end


function c.post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	post(b, a, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

return c

