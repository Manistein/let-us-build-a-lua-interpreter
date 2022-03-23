#include "lua.h"
#include "luaaux.h"
#include "luastring.h"
#include "SDL_events.h"

bool g_Quit = false;

#define check_error(L, code) { \
	if (code != LUA_OK) { \
		if (luaL_tostring(L, -1)) { \
			printf("%s", luaL_tostring(L, -1)); \
		} \
		goto ERROR; \
	} \
}

static int key_down(struct lua_State* L, SDL_Event* e) {
	int ret = LUA_OK;

	switch (e->key.keysym.sym) {
	case SDLK_ESCAPE: {
		lua_getglobal(L, "__keypress__");
		lua_pushinteger(L, (lua_Integer)SDLK_ESCAPE);
		ret = luaL_pcall(L, 1, 0);
		g_Quit = true;
	} break;
	default:break;
	}

	return ret;
}

int main(int argc, char** argv) {
	struct lua_State* L = luaL_newstate();
	luaL_openlibs(L);

	check_error(L, luaL_loadfile(L, "../modules/start.lua"));
	check_error(L, luaL_pcall(L, 0, 0));

	// init game
	lua_getglobal(L, "__init__");
	check_error(L, luaL_pcall(L, 0, 0));

	SDL_Event e;
	while (!g_Quit) {
		if (SDL_PollEvent(&e) != 0) {
			switch (e.type) {
			case SDL_QUIT:
				g_Quit = true;
				break;
			case SDL_KEYDOWN: {
				check_error(L, key_down(L, &e));
			} break;
			default:
				break;
			}
		}
	}

	lua_getglobal(L, "__destroy__");
	check_error(L, luaL_pcall(L, 0, 0));

ERROR:

	luaL_close(L);

#ifdef _WINDOWS_PLATFORM_
	system("pause");
#endif

	return 0;
}