#include "clib/luaaux.h"
#include "common/luastate.h"

static int hello_world(struct lua_State* L) {
	lua_getglobal(L, "print");
	lua_pushstring(L, "loadlib:hello world");
	luaL_pcall(L, 1, 0);

	return 0;
}

static int hello_world_core(struct lua_State* L) {
	lua_getglobal(L, "print");
	lua_pushstring(L, "loadlib_core:hello world");
	luaL_pcall(L, 1, 0);

	return 0;
}

LUA_API int luaopen_loadlib(struct lua_State* L) {
	lua_createtable(L);
	lua_pushcfunction(L, hello_world);
	lua_setfield(L, -2, "hello_world");

	return 1;
}

LUA_API int luaopen_loadlib_core(struct lua_State* L) {
	lua_createtable(L);
	lua_pushcfunction(L, hello_world_core);
	lua_setfield(L, -2, "hello_world_core");

	return 1;
}