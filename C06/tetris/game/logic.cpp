extern "C" {
#include "lua.h"
#include "luaaux.h"
#include <stdio.h>
}

#include "logic.h"
static lua_State* L = NULL;

static void log_file(const char* text) {
	FILE* handle = fopen("./error.txt", "ab+");
	fprintf(handle, "%s", text);
	fflush(handle);
	fclose(handle);
}

#define check(p) { \
	int ok = p; \
	if (ok != LUA_OK && lua_tostring(L, -1)) { \
		char* msg = lua_tostring(L, -1); \
		log_file((const char*)msg); \
		return 0; \
	} \
}

int logic_init(void* hwnd) {
	L = luaL_newstate();
	luaL_openlibs(L);

	check(luaL_loadfile(L, "../modules/start.lua"));
	check(luaL_pcall(L, 0, 0));

	lua_getglobal(L, "__init__");
	lua_pushlightuserdata(L, hwnd);
	check(luaL_pcall(L, 1, 0));

	return 1;
}

void logic_destroy() {
	lua_getglobal(L, "__destroy__");
	luaL_pcall(L, 0, 0);

	lua_close(L);
	L = NULL;
}

int logic_frame(int delta) {
	lua_getglobal(L, "__loop__");
	lua_pushinteger(L, delta);
	check(luaL_pcall(L, 1, 0));

	return 1;
}

void logic_key_w_press() {

}

void logic_key_s_press() {

}

void logic_key_a_press() {

}

void logic_key_space_press() {

}

void logic_key_esc_press() {

}

void logic_key_enter_press() {

}

