local radar = class("radar2",obj.plugin.base)
radar.cover = 0.4
radar.heat = 5
radar.pname = "sky eyes"
radar.stype = "universal"
radar.isSensor = true
radar.radius = 1000
local instant
function radar:init(ship,slot)
	self.ship = ship
	self.slot = slot
	self.name = radar.pname
    
    instant = self
end

function radar:update(dt)
    if self.ship == game.player then
        game.hud.radar = self
    else
        return --ai主动调用雷达api
    end
    self.x = self.ship.x
    self.y = self.ship.y
    obj.plugin.base.update(self,dt)
    self:findTarget()
end

function radar:radardraw()

	love.graphics.setColor(0, 255, 0, 255)
	local rad = h()/3
    love.graphics.circle("line", w()/2, h()/2, rad)

	local player = self.ship
    for i,s in ipairs(game.enemies) do
       	local dist = math.getDistance(player.x,player.y,s.x,s.y)
        if dist*game.cam.scale>rad then
            local angle = math.getRot(player.x,player.y,s.x,s.y)
            love.graphics.circle("fill", w()/2+math.sin(angle)*rad, h()/2-math.cos(angle)*rad, 5)  
        end
    end

    if instant.targets then
        for i,s in ipairs(instant.targets) do
            local ship = s.obj
            game.cam:draw(function()
            love.graphics.circle("line", ship.x, ship.y, ship.scale)
            end)
        end
    end

    if player.target then
        game.cam:draw(function()
        local target  =player.target
        love.graphics.push()
        love.graphics.translate(target.x, target.y)
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.rectangle("line", -target.scale, -target.scale, target.scale*2, target.scale*2)
        love.graphics.pop()
        end)

    end
end

function radar:findTarget()
    self.target = self.ship.target
    local dist
    if self.target then 
        if self.target.destroyed then 
            self.target = nil 
        else
            dist = math.getDistance(self.target.x,self.target.y,self.x,self.y)
            if dist>self.radius then
                self.target = nil
            end
        end
    end
    if self.target then
        self.targets = {{obj = self.target, dist = dist ,ttype = "ship"}}
        return
    end

    self.targets = {}
    local callback = function(fixture)
        local obj = fixture:getUserData()
        if obj.team ~= self.ship.team and not obj.destroyed then          
            local dist = math.getDistance(self.x,self.y,obj.x,obj.y)
            if dist<self.radius then
                table.insert(self.targets,{obj = obj,dist = dist , ttype = obj.tag})
            end
        end
        return true
    end
    game.world:queryBoundingBox( self.x-self.radius, self.y-self.radius, 
        self.x+self.radius, self.y+self.radius, callback )
    table.sort(self.targets,function(a,b) return a.dist<b.dist end)
end


return radar