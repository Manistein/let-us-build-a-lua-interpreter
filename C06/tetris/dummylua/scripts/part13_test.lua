local vertices = { {x=0,y=0},{x=1,y=1},{x=2,y=2},{x=3,y=3} }
local vertex = vertices[1]
local ret  = {}
ret.right_most_x = vertex.x

for idx, v in ipairs(vertices) do 
	if v.x > ret.right_most_x then 
		ret.right_most_x = v.x
	end 
end 

print(ret.right_most_x)

-- -- test package path
-- print(package.path)
-- print(package.cpath)

-- -- test preload
-- package.preload["test.aa.bb"] = function(file) print(file) end 
-- require("test.aa.bb")
-- local ret = require("test.aa.bb")
-- print(ret)

-- -- test package.loaded and package.searchers
-- print("---------package.loaded---------")
-- print(package.loaded)
-- for k, v in pairs(package.loaded) do 
-- 	print(k, v)
-- end 

-- print("---------package.searchers---------")
-- print(package.searchers)
-- for k, v in pairs(package.searchers) do 
-- 	print(k, v)
-- end 

-- -- require a file that does not exist
-- print("----require lua file")
-- package.path = package.path .. "../?.lua;"
-- local file_without_return = require("scripts.p13_require_test")
-- print(file_without_return)

-- -- require again
-- file_without_return = require("scripts.p13_require_test")
-- print(file_without_return)

-- -- require a module 
-- local mod = require("scripts/p13_test_return_table")
-- mod.hello()
-- mod.world()

-- local mod2 = require("scripts/p13_test_return_table")
-- mod2.hello()
-- mod2.world()

-- print(package.cpath)
-- local clib = require("loadlib")
-- clib.hello_world()

-- local clibcore = require("loadlib.core")
-- clibcore.hello_world_core()