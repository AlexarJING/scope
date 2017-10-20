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

obj.plugin = {}
obj.plugin.base = require "object/plugin/base"
obj.plugin.core = loadDir("object/plugin/core/")
obj.plugin.engine = loadDir("object/plugin/engine/")
obj.plugin.universal = loadDir("object/plugin/universal/")

obj.ship = {}
obj.ship.base = require "object/ship/base"
loadDir("object/ship/",obj.ship)