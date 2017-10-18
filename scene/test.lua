local scene = gamestate.new()
local layout = require "scr/layout"
function scene:enter(from,screenshot,how,cx,cy)
    game = Game()
    game:start()
end

function scene:update(dt)
    game:update(dt)
    --layout:update()
end

function scene:draw()
    game:draw()
end

return scene