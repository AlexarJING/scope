local function loadDir(dir,tab)
	local objs = tab or {}
	for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local name = fullname:sub(1,-5)
        objs[name]=require(dir..name)
    end
    return objs
end

obj = {}

obj.others = loadDir("object/others/")

obj.module = {}
obj.module.base = require "object/module/base"
obj.module.system = loadDir("object/module/system/")
obj.module.engine = loadDir("object/module/engine/")
obj.module.battle = loadDir("object/module/battle/")

obj.ship = {}
obj.ship.base = require "object/ship/base"
obj.ship.player = require "object/ship/player"
obj.ship.npc = require "object/ship/npc"
--loadDir("object/ship/",obj.ship)