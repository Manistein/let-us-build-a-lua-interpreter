#include "p13_test.h"
#include "../vm/luagc.h"
#include "../common/luastring.h"

static void check_error(struct lua_State* L, int code) {
	if (code != LUA_OK && (novariant(L->top - 1) == LUA_TSTRING)) {
		TString* ts = gco2ts(gcvalue(L->top - 1));
		printf(getstr(ts));
	}
}

void p13_test_main() {
	struct lua_State* L = luaL_newstate();
	luaL_openlibs(L);

	const char* filename = "../scripts/part13_test.lua";
	int ok = luaL_loadfile(L, filename);
	if (ok == LUA_OK) {
		ok = luaL_pcall(L, 0, 0);
		check_error(L, ok);
	}
	else {
		printf("failure to load file %s\n", filename);
	}

	lua_close(L);
}
