#include "lua.h"
#include "luaaux.h"
#include "luastring.h"

static void check_error(struct lua_State* L) {
	if (luaL_tostring(L, -1)) {
		printf("%s", luaL_tostring(L, -1));
	}
}

int main(int argc, char** argv) {
	struct lua_State* L = luaL_newstate();
	luaL_openlibs(L);

	int ok = luaL_loadfile(L, "../modules/start.lua");
	if (ok == LUA_OK) {
		ok = luaL_pcall(L, 0, 0);
		if (ok != LUA_OK) {
			check_error(L);
		}
	}
	else {
		check_error(L);
	}

	luaL_close(L);

#ifdef _WINDOWS_PLATFORM_
	system("pause");
#endif

	return 0;
}