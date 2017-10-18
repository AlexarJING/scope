local game = class("game")
local debugDraw = require("lib/debugDraw")
local Ship = require("object/ship")
local Grid = require("lib/grid")
local collision =  require ("scr/collide")
function game:init()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(collision.begin,collision.leave,collision.pre,collision.post)
    self.objects = {}
    self.teams = {}
    self.enemies = {}
    self.cam = Camera.new(-5000,-5000,10000,10000)
    self.cam:setScale(0.5)
    self.grid = Grid.new(self.cam)
end

function game:start()
    for i = 1, 10 do
        self.enemies[i] = Ship(2,love.math.random(-500,500),
            love.math.random(-500,500),30,love.math.random()*2*Pi)
    end
    self.player = Ship(1,0,0,30)
end

function game:update(dt)
    self.cam:followTarget(self.player,0,10)
    local newTab = {}
    for id,obj in pairs(self.objects) do
        obj:update(dt)
        if not obj.destroyed then
            table.insert(newTab,obj)
        end
    end
    self.objects = newTab
    self.world:update(dt)
end

function game:draw()
    self.grid.draw()
    self.cam:draw(function()
    for id,obj in pairs(self.objects) do
        obj:draw()
    end
    love.graphics.setColor(255,0,0)
    --debugDraw.draw(self.world)
    end) 
    self:drawHub()
end

function game:drawHub()
    love.graphics.setColor(0, 255, 0, 255)
    local rad = h()/2.5
    love.graphics.circle("line", w()/2, h()/2, rad)
    for i,s in ipairs(self.enemies) do
        local dist = math.getDistance(self.player.x,self.player.y,s.x,s.y)
        if dist*self.cam.scale>rad then
            local angle = math.getRot(self.player.x,self.player.y,s.x,s.y)
            love.graphics.circle("fill", w()/2+math.sin(angle)*rad, h()/2-math.cos(angle)*rad, 5)
        end
    end
end

return game