__TESTING = false
local path = "/"
require (path.."lib/util")
input= require "lib/input"()
class=require (path.."lib/middleclass")
gamestate= require (path.."lib/gamestate")
delay= require (path.."lib/delay")
tween = require (path.."lib/tween")
Anim = require (path.."lib/animation")
suit = require "lib/suit"
Camera = require "lib/gamera"


Language = "cn"
lang = require "scr/i18n"
require "scr/objLoader"
Game = require "scr/game"
DebugDraw = require "lib/debugDraw"
function love.load()
    --love.graphics.setBackgroundColor(50,50,150)
    gameState={}
    for _,name in ipairs(love.filesystem.getDirectoryItems(path.."scene")) do
        gameState[name:sub(1,-5)]=require(path.."scene."..name:sub(1,-5))
    end
    gamestate.registerEvents()
    gamestate.switch(gameState.test)
end

function love.update(dt)
    delay:update(dt)
    
end

function love.draw()
    input:update()
   --suit.draw() 
end