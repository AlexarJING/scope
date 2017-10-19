local game = class("game")
local debugDraw = require("lib/debugDraw")
local Ship = require("object/ship")
local NPC = require("object/ai_ctrl_ship")
local Grid = require("lib/grid")
local collision =  require ("scr/collide")
local hud = require("scr/hud")
function game:init()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(collision.begin,collision.leave,collision.pre,collision.post)
    self.objects = {}
    self.teams = {}
    self.enemies = {}
    self.cam = Camera.new(-5000,-5000,10000,10000)
    self.zoom = 1
    self.cam:setScale(self.zoom)
    self.grid = Grid.new(self.cam)
    self.hud = hud
end

function game:start()
    for i = 1, 10 do
        self.enemies[i] = NPC(2,love.math.random(-500,500),
            love.math.random(-500,500),30,love.math.random()*2*Pi)
    end
    self.player = Ship(1,0,0,30)
    self.hud:init()
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
    self.hud:update()
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
    self.hud:draw()
    suit.draw()
end



function game:setZoom(d)
    self.zoom = self.zoom + d/10
    if self.zoom < 0.1 then self.zoom = 0.1 end
    self.cam:setScale(self.zoom)
    self.cam.x,self.cam.y = self.player.x,self.player.y
end

return game