obj = {}

local function loadDir(dir,tab)
	local objs = tab or {}
	for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local name = fullname:sub(1,-5)
        objs[name]=require(dir..name)
    end
    return objs
end

local function loadMod(socket)
	local dir = "object/module/"..socket.."/"
	obj.module[socket] = {}
	obj.module[socket].base = require(dir..socket) --所有的base均为同名文件
	loadDir(dir,obj.module[socket])
end



obj.others = loadDir("object/others/")

obj.module = {}
obj.module.base = require "object/module/base"
local sockets = {"cockpit","engine","hud","radar","system","weapon"}
for i,mod  in ipairs(sockets) do
	loadMod(mod)
end

obj.ship = {}
obj.ship.base = require "object/ship/base"
obj.ship.player = require "object/ship/player"
obj.ship.npc = require "object/ship/npc"
--loadDir("object/ship/",obj.ship)