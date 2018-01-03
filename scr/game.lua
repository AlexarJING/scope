local game = class("game")
local collision =  require ("scr/collide")
local font = love.graphics.setNewFont("res/cn.ttf",14)
function game:init()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(collision.begin,collision.leave,collision.pre,collision.post)
    self.objects = {}
    self.object_index = {}
    --self.teams = {}
end

function game:start()
    for i = 1, 100 do
        cls.obj.ship.test2(-1,love.math.random(-1500,1500),
            love.math.random(-1500,1500),love.math.random()*2*Pi)
    end
    --obj.ship.boss(2,1500,-1500)
    self.player = cls.obj.ship.test(1,0,0,30)
end

function game:update(dt)
    
    local newTab = {}
    for id,obj in pairs(self.objects) do
        obj:update(dt)
        if not obj.destroyed then
            table.insert(newTab,obj)
        else
            self.object_index[obj] = nil
        end
    end
    self.objects = newTab
    self.world:update(dt)
end

function game:draw()
    if self.hud then self.hud:draw() end
    if __TESTING then
        self.hud.cam:draw(function()
        love.graphics.setColor(255,0,0)
            DebugDraw.draw(self.world) --物理世界debug
        end) 
    end
 
end


function game:addObject(obj)
    self.object_index[obj] = obj
    table.insert(self.objects,obj)
end

function game:removeObject(obj)
    obj.destroyed = true
    self.object_index[obj] = nil
end

function game:queryWorld(x,y,r)
    local world = {}
    local callback = function(fixture)
        local obj = fixture:getUserData()
        if not obj.destroyed then
        	table.insert(world,obj)     	
        end
        return true
    end
    game.world:queryBoundingBox(x-r, y-r, x+r, y+r, callback )
    return world
end

function game:queryBody()
    
    
end

return game