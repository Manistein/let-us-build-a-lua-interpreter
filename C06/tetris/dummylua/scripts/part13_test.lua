local const = {}
const.BOARD_SIZE = { X = 10, Y = 20 }

local grids = {}

for i = 1, const.BOARD_SIZE.X do 
	grids[i] = {}
	for j = 1, const.BOARD_SIZE.Y do 
		grids[i][j] = { color = 0, is_occupied = false }
	end
end

local vertexes = { {x=1,y=20}, {x=2,y=20}, {x=2,y=19}, {x=3,y=19} }
for idx, v in ipairs(vertexes) do 
	print(v.x, v.y)
	print(grids[v.x][v.y])
end

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