cls = {}

local function loadDir(dir,tab)
	local objs = tab or {}
	for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local name = fullname:sub(1,-5)
        objs[name]=require(dir..name)
    end
    return objs
end

local function makeClass(data,base)
	local name = data.obj_name or data.mod_name
    local cls = class(name,base)
	for k,v in pairs(data) do
		cls[k] = v
	end
	return cls,name
end

local function loadModule()
    local dir = "module/"
    cls.mod = {}
    cls.mod.base = require(dir.."base")
	for _,mod_cls in ipairs(love.filesystem.getDirectoryItems(dir)) do
        if love.filesystem.isDirectory(dir..mod_cls) then
            cls.mod[mod_cls] = {}
            local base = require(dir..mod_cls.."/base")
            cls.mod[mod_cls].base = base
            for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir..mod_cls)) do
                if love.filesystem.isDirectory(dir..mod_cls.."/"..fullname) then
                    local c = require(dir..mod_cls.."/"..fullname.."/"..fullname)
                    cls.mod[mod_cls][c.mod_name] = c
                else
                    local name = fullname:sub(1,-5)
                    local data = require(dir..mod_cls.."/"..name)
                    local c,mod_name = makeClass(data,base)
                    cls.mod[mod_cls][mod_name] = c
                end
            end
        end
    end
    return objs
end



local function loadObj()
    local dir = "object/"
    cls.obj = {}
    cls.obj.base = require(dir.."base")
	for _,obj_cls in ipairs(love.filesystem.getDirectoryItems(dir)) do
        if love.filesystem.isDirectory(dir..obj_cls) then
            cls.obj[obj_cls] = {}
            if love.filesystem.exists(dir..obj_cls.."/base.lua") then
                local base = require(dir..obj_cls.."/base")
                cls.obj[obj_cls].base = base
                for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir..obj_cls)) do
                    
                    if love.filesystem.isDirectory(fullname) then
                        cls.obj[obj_cls][fullname] = require(dir..obj_cls.."/"..fullname.."/"..fullname)
                    else
                        local name = fullname:sub(1,-5)
                        local data = require(dir..obj_cls.."/"..name)
                        local c,obj_name = makeClass(data,base)
                        cls.obj[obj_cls][obj_name] = c
                    end
                end
            else
                for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir..obj_cls)) do
                    local name = fullname:sub(1,-5)
                    local c = require(dir..obj_cls.."/"..name)
                    cls.obj[obj_cls][c.obj_name] = c  
                end
            end
        end
    end
    return objs
end


loadModule()
loadObj()
