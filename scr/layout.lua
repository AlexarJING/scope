local layout = {}


function layout:update()
    if suit.Button("start server",10,500,80,30).hit then
        net.client = nil
        net:serverInit()
        game = Game()
        game.peerName = "server"
        game.map:random()
        HQ(15,1,1)
        HQ(15,29,2)

        love.window.setTitle("city battle- server")       
        --love.window.setMode(600, 600, {resizable=true, vsync=false})
        love.window.setPosition(-300,100)
    end
    
    if suit.Button("join team 1",110,500,80,30).hit then
        net.server = nil
        net:clientInit()
        game.team = 1
        love.window.setTitle("city battle- client")
        --love.window.setMode(600, 600, {resizable=true, vsync=true})
        love.window.setPosition(1280-550,100)
        delay:new(0.5,function()
            net.client:send("need_init")
        end)
        delay:new(1,function()
            net.client:send("need_tank",{550,500,0,2,game.team,1})
        end)
    end
    
    if suit.Button("join team 2",210,500,80,30).hit then
        net.server = nil
        net:clientInit()
        game.team = 2
        love.window.setTitle("city battle- client")
        --love.window.setMode(600, 600, {resizable=true, vsync=true})
        love.window.setPosition(1280-550,100)
        delay:new(0.5,function()
            net.client:send("need_init")
        end)
        delay:new(1,function()
            net.client:send("need_tank",{550,500,0,2,game.team,1})
        end)
    end
    

    if suit.Button("addItem",110,550,80,30).hit then
        net.client:send("test")
        if net.server then
            Item(500,400,2)
        end
    end
end


return layout