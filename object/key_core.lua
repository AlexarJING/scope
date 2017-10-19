local core = class("core")
core.stype = "core"
function core:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.body = ship.body
	self.side = ship.sidePower
	self.turn = ship.turnPower
	self.push = ship.pushPower
end

function core:update(dt)
	if self.ship.overheat then return end
	if love.keyboard.isDown("w") then
		self.ship:push(1)
	elseif love.keyboard.isDown("s") then
		self.ship:push(-1)
	end

	if love.keyboard.isDown("a") then
		self.ship:turn(1)
	elseif love.keyboard.isDown("d") then
		self.ship:turn(-1)
	end

	if love.keyboard.isDown("q") then
		self.ship:side(1)
	elseif love.keyboard.isDown("e") then
		self.ship:side(-1)
	end 

	if love.keyboard.isDown("c") then
		self.ship:stop()
	end

	if love.keyboard.isDown("space") then
		self.ship.openFire = true
	end

	if love.keyboard.isDown("lshift") then
		self.ship.openShield = true
	end
end

function core:draw()

end

return core