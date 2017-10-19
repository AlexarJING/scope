local scene = gamestate.new()

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

function scene:wheelmoved(x,y)
	game:setZoom(math.sign(y))
end

return scene