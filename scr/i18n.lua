local lang = {}

local function loadDir(dir,tab)
	local objs = tab or {}
	for _,fullname in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local name = fullname:sub(1,-5)
        objs[name]=require(dir..name)
    end
    return objs
end

lang._lib = loadDir("/lang/")

local meta = {}
meta.__index = function(t,k)
	if lang._lib[Language][k] then
		return lang._lib[Language][k]
	else
		return lang._lib.en[k]
	end
end

setmetatable(lang,meta)
return lang