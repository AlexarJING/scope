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
	--loadDir(dir,obj.module[socket])
end

local function makeClass(data,base)
	local cls = class(data.ship_name or data.mod_name,base)
	for k,v in pairs(data) do
		cls[k] = v
	end
	return cls
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

local function loadCls()
	for _,folder in ipairs(love.filesystem.getDirectoryItems("data")) do
        for _,fullname in ipairs(love.filesystem.getDirectoryItems("data/"..folder.."/")) do
	        local name = fullname:sub(1,-5)
	        if folder ~= "ship"  and folder ~="resource" then 	     
	        	obj.module[folder][name]=makeClass(require("data/"..folder.."/"..name),obj.module[folder].base)
	        end

	    end   
    end

    for _,fullname in ipairs(love.filesystem.getDirectoryItems("data/ship/")) do
        local name = fullname:sub(1,-5)
        obj.ship[name]=makeClass(require("data/ship/"..name),obj.ship.base)  
	end   
end


loadCls()