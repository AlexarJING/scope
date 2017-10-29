local game = class("game")
local collision =  require ("scr/collide")

function game:init()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(collision.begin,collision.leave,collision.pre,collision.post)
    self.objects = {}
    self.object_index = {}
    --self.teams = {}
end

function game:start()
    
    for i = 1, 10 do
        obj.ship.npc(2,love.math.random(-500,500),
            love.math.random(-500,500),30,love.math.random()*2*Pi)
    end
    --obj.ship.boss(2,1500,-1500)
    self.player = obj.ship.player(1,0,0,30)
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
    self.hud:draw()
    --[[
    love.graphics.setColor(255,0,0)
        debugDraw.draw(self.world) --物理世界debug
    end)  
    ]]   
end


function game:addObject(obj)
    self.object_index[obj] = obj
    table.insert(self.objects,obj)
end

return game