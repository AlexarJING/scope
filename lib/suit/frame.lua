-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')


local vertBuff = {}
local k = 50
local p = 20
local bw = 100

return function(core,title, ...)
	local Panel = core.Panel
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or title.."frame"
	opt.font = opt.font or love.graphics.getFont()

	local tw = love.graphics.getFont():getWidth(title)
	local th = love.graphics.getFont():getHeight(title)+p
	core:Panel(x,y,w,h)
	
	local verts = vertBuff[title] or {x+k-p ,y-th, x+k + tw +p , y-th, x+tw+2*k,y, x,y}
	vertBuff[title] = verts
	
	local titleButton = core:Button(title,{polygon =verts },x,y-th,tw+k*2,th)

	local buttons = opt.buttons
	for i,b in ipairs(buttons) do
		local bx = x+w - i*(2*p+bw)
		local by = y+h
		local up = 2*p+bw
		local down = bw
		local verts = vertBuff[i..tostring(button)] or {
			bx,by,
			bx+up,by,
			bx+p+bw,by+th,
			bx+p,by+th,
		}
		vertBuff[i..tostring(button)] = verts
		b.reply = core:Button(b.text,{polygon = verts},bx,by,up,th)
	end
	--opt.state = core:registerHitbox(opt.id, x,y,w,h)
	
	--core:registerDraw(draw or opt.draw or core.theme.Button, text, opt, x,y,w,h)

	return {
		id = opt.id,
		title = titleButton,
	}
end



