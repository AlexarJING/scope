local hud = {}
local player

function hud:init()
    self.player = game.player
    self.scale = w()/20 --32
    self.universal = self.player.slot.universal
    self.core = self.player.slot.core
    self.engine = self.player.slot.engine
    self.canvas = self.player:getCanvas()
    self.font = love.graphics.newFont(20)
    self.font_opt = {font = self.font}
    self.messages ={}
    for i = 1,10 do
        self.messages[i] =  {
        text = "this is a message "..i,
        checked = false}
    end
    self.messageVisible = false
    self.zoom = 1
    game.cam:setScale(self.zoom)
    
end

function hud:update()
    self:updateSlot()
    self:updateInfo()
    self:showMessage()
end



function hud:draw()
    self:drawRadar()
    self:drawState()
    self:drawFoeState()
    if self.radar then
        self.radar:radardraw()
    end
    --love.graphics.print(tostring(game.player.openFire), 10,10)
end

function hud:updateSlot()
    for i = 1, #self.universal do
        local slot = self.universal[i]
        local name = slot.plugin and slot.plugin.name or "not used"
        if suit.Button(i.."\n"..name,{toggle = slot.enabled and "active" or nil},
            w()/2-#self.universal*self.scale/2+(i-1)*(self.scale+2),
            h()-self.scale*1.2,self.scale,self.scale).hit then
            slot.enabled = not slot.enabled
        end
    end
    
    for i = 1, #self.engine do
        local slot = self.engine[i]
        local name = slot.plugin and slot.plugin.name or "not used"
        if suit.Button(i.."\n"..name,{toggle = slot.enabled and "active" or nil},
            w()-self.scale*1.2,
            h()/2-#self.universal*self.scale/2+(i-1)*(self.scale+2),
            self.scale,self.scale).hit then
            slot.enabled = not slot.enabled
        end
    end
end


function hud:updateInfo()

    suit.Label("Information", self.font_opt,self.scale*0.2, self.scale*2)
    for i =  1, 10 do
        if suit.Checkbox(self.messages[i],
            self.scale*0.2, self.scale*2.2+self.scale*0.3*i).hit then
            if self.messages[i].checked then
                self.messageVisible = true
            else
                self.messageVisible = false
            end
        end
    end
end

function hud:drawRadar()

end

function hud:drawFoeState()

end

function hud:drawState()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.canvas, self.scale, self.scale, 0, 1, 1, self.scale, self.scale)
    local player = self.player
    love.graphics.setColor(50, 255, 50, 50)
    love.graphics.rectangle("fill", self.scale*1.3, self.scale*0.2, self.scale*3, self.scale/4)
    love.graphics.setColor(50, 255, 50, 255)
    love.graphics.rectangle("fill", self.scale*1.3, self.scale*0.2, self.scale*3*player.armor/player.armor_max, self.scale/4)
    love.graphics.setColor(255, 55, 250, 50)
    love.graphics.rectangle("fill", self.scale*1.3, self.scale*0.53, self.scale*3, self.scale/4)
    love.graphics.setColor(255, 55, 250, 255)
    love.graphics.rectangle("fill", self.scale*1.3, self.scale*0.53, self.scale*3*player.shield/player.shield_max, self.scale/4)
    love.graphics.setColor(255, 255, 0, 50)
    love.graphics.rectangle("fill", self.scale*1.3, self.scale*0.86, self.scale*3, self.scale/4)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle("fill", self.scale*1.3, self.scale*0.86, self.scale*3*player.heat/player.heat_max,self.scale/4)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(string.format("%3d/%3d",player.armor,player.armor_max), self.scale*4.5, self.scale*0.23)
    love.graphics.print(string.format("%3d/%3d",player.shield,player.shield_max), self.scale*4.5, self.scale*0.53)
    love.graphics.print(string.format("%3d/%3d",player.heat,player.heat_max), self.scale*4.5, self.scale*0.83)
end

local message = 
[[ this is a test mission, ok?

]]

function hud:showMessage()
    if not self.messageVisible then return end
    suit.Panel(w()/8,h()/6,w()/4,h()*2/3)
    suit.Label("Title",self.font_opt,w()/8,h()/6,w()/4,self.scale)
    suit.Label(message,w()/8,h()/6+self.scale/2,w()/4,self.scale)

    suit.Button("accept",w()/8,h()/6+h()*2/3+2,self.scale,self.scale/2)
    suit.Button("ignore",w()/8 + self.scale*1.4 ,h()/6+h()*2/3+2,self.scale,self.scale/2)
    suit.Button("delete",w()/8 + self.scale*2.7 ,h()/6+h()*2/3+2,self.scale,self.scale/2)
    suit.Button("cancel",w()/8 + self.scale*4 ,h()/6+h()*2/3+2,self.scale,self.scale/2)
end

function hud:setZoom(d)
    if not self.radar then return end
    local last = self.zoom
    self.zoom = self.zoom + d/10
    if self.zoom < 0.1 then self.zoom = 0.1 end
    
    if h()/2/self.zoom > self.radar.radius then
        self.zoom = last
    end
    game.cam:setScale(self.zoom)
    game.cam.x,game.cam.y = self.player.x,self.player.y
end

return hud
