extern "C" {
#include "lua.h"
#include "luaaux.h"
}

#include "render.h"
static FILE* g_file = NULL;

static int d2d_init(struct lua_State* L) {
	HWND hwnd = (HWND)lua_tolightuserdata(L, 1);

	int ret = render_init(hwnd);
	luaL_pushinteger(L, ret);

	g_file = fopen("./d2derr.txt", "ab+");

	return 1;
}

static int d2d_destroy(struct lua_State* L) {
	render_destroy();

	if (g_file) {
		fclose(g_file);
	}
	return 0;
}

static int d2d_begin_draw(struct lua_State* L) {
	render_begin();
	return 0;
}

static int d2d_end_draw(struct lua_State* L) {
	render_end();
	return 0;
}

static int d2d_draw_box(struct lua_State* L) {
	int x = (int)luaL_tointeger(L, 1);
	int y = (int)luaL_tointeger(L, 2);
	int width = (int)luaL_tointeger(L, 3);
	int height = (int)luaL_tointeger(L, 4);
	int fill_color = (int)luaL_tointeger(L, 5);

	render_draw_box(x, y, width, height, fill_color);
	return 0;
}

static int d2d_draw_text(struct lua_State* L) {
	int x = (int)luaL_tointeger(L, 1);
	int y = (int)luaL_tointeger(L, 2);
	char* text = luaL_tostring(L, 3);

	render_draw_text(x, y, text);
	return 0;
}

static int d2d_error(struct lua_State* L) {
	if (!g_file) {
		return 0;
	}

	char* err = lua_tostring(L, 1);

	fprintf(g_file, "%s\n", err);
	fflush(g_file);

	return 0;
}

static const lua_Reg reg[] = {
	{"init", d2d_init},
	{"destroy", d2d_destroy},
	{"begin_draw", d2d_begin_draw},
	{"end_draw", d2d_end_draw},
	{"draw_box", d2d_draw_box},
	{"draw_text", d2d_draw_text},
	{"error", d2d_error},
	{NULL, NULL}
};

LUA_API int luaopen_d2d(struct lua_State* L) {
	lua_createtable(L);
	luaL_setfuncs(L, reg, 0);

	return 1;
}