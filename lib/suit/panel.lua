-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local panelIndex = 0
local function getNewID()
   panelIndex = panelIndex + 1
   return "panel"..panelIndex
end
return function(core, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or getNewID()
	opt.font = opt.font or love.graphics.getFont()
    
	w = w or 100
	h = h or 100
    opt.state = core:registerHitbox(opt.id, x,y,w,h)
	core:registerDraw(opt.draw or core.theme.Panel, opt, x,y,w,h)

	return {
		id = opt.id,
        drag = core:mouseDragRelease(opt.id)
	}
end
