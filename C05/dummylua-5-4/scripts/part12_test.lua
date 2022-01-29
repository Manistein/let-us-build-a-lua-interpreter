local weakkey_tbl = { __mode = "k" }
local t1 = setmetatable({}, weakkey_tbl)

ga = {}
gb = {}

do 
    t1[1] = "test1"
    t1[2] = function() end
    t1["test"] = "test2"
    
    local t_str3 = "test3"
    local key = {}
    t1[key] = t_str3 
    
    local t_str4 = "test4"
    local xxfunc = function() end
    t1[xxfunc] = t_str4

    local tv1 = {}
    local tv2 = {}
    t1[tv1] = tv2
    t1[tv2] = tv1
    t1[ga] = gb
    t1[gb] = ga
end 

ga = nil
gb = nil

collectgarbage()

print("------------------")
for k, v in pairs(t1) do 
    print(k, v)
end 

local weakvalue_tbl = { __mode = "v" }
local t2 = setmetatable({}, weakvalue_tbl)
do 
    t2[1] = 1 
    t2[2] = "test2"
    t2[3] = function() end 
    t2["xxfunc"] = function() end 
    
    local vtbl = {}
    t2["xxfunc2"] = vtbl
end 

collectgarbage()

print("------------------")
for k, v in pairs(t2) do 
    print(k, v)
end 

local weakkv_tbl = { __mode = "kv" }
local t3 = setmetatable({}, weakkv_tbl)
do 
    t3[1] = "test1"
    t3[2] = function() end
    t3["test2"] = "test2"
    
    local key = {}
    t3[key] = "test3"
    
    local xxfunc = function() end
    t3[xxfunc] = "test4"
end 

collectgarbage()

print("------------------")
for k, v in pairs(t3) do 
    print(k, v)
end 

local ephemeron_tbl = {__mode = "k"}
local t = setmetatable({}, ephemeron_tbl) 
e1 = {}
e2 = {}
 
t[e1] = e2
t[e2] = e1

e1 = nil
e2 = nil 

collectgarbage()

print("------------------")
for k, v in pairs(t) do 
    print(k, v)
end
print("end")