#include "lua.h"
#include "luadebug.h"
#include "luaaux.h"
#include "luastate.h"
#include "SDL.h"

// call in lua:sdlhelper.create_window(title, width, height)
static int create_window(struct lua_State* L) {
	int height = (int)luaL_tointeger(L, -1);
	int width = (int)luaL_tointeger(L, -2);
	char* title = luaL_tostring(L, -3);

	SDL_Window* window = NULL;

	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		luaG_runerror(L, "SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
	}

	window = SDL_CreateWindow(title, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN);
	if (!window) {
		luaG_runerror(L, "Window could not be created!SDL_Error: %s\n", SDL_GetError());
	}

	lua_pushlightuserdata(L, (void*)window);

	return 1;
}

// call in lua:sdlhelper.get_surface(window)
static int get_surface(struct lua_State* L) {
	// TODO
	SDL_Window* window = (SDL_Window*)lua_tolightuserdata(L, -1);
	SDL_Surface* surface = SDL_GetWindowSurface(window);

	lua_pushlightuserdata(L, (void*)surface);

	return 1;
}

// call in lua:sdlhelper.fill_rect(surface, r, g, b)
static int fill_rect(struct lua_State* L) {
	SDL_Surface* surface = (SDL_Surface*)lua_tolightuserdata(L, 1);
	int r = (int)luaL_tointeger(L, 2);
	int g = (int)luaL_tointeger(L, 3);
	int b = (int)luaL_tointeger(L, 4);

	SDL_FillRect(surface, NULL, SDL_MapRGB(surface->format, (Uint8)r, (Uint8)g, (Uint8)b));

	return 0;
}

static int update_window_surface(struct lua_State* L) {
	SDL_Window* window = (SDL_Window*)lua_tolightuserdata(L, 1);
	SDL_UpdateWindowSurface(window);

	return 0;
}

static int delay(struct lua_State* L) {
	int t = (int)luaL_tointeger(L, -1);
	SDL_Delay((Uint32)t);

	return 0;
}

static int destroy(struct lua_State* L) {
	SDL_Window* window = (SDL_Window*)lua_tolightuserdata(L, -1);
	SDL_Surface* surface = SDL_GetWindowSurface(window);

	SDL_FreeSurface(surface);
	SDL_DestroyWindow(window);
	SDL_Quit();

	return 0;
}

LUA_API int luaopen_sdlhelper(struct lua_State* L) {
	lua_createtable(L);
	
	lua_pushcfunction(L, create_window);
	lua_setfield(L, -2, "create_window");

	lua_pushcfunction(L, get_surface);
	lua_setfield(L, -2, "get_surface");

	lua_pushcfunction(L, fill_rect);
	lua_setfield(L, -2, "fill_rect");

	lua_pushcfunction(L, update_window_surface);
	lua_setfield(L, -2, "update_window_surface");

	lua_pushcfunction(L, delay);
	lua_setfield(L, -2, "delay");

	lua_pushcfunction(L, destroy);
	lua_setfield(L, -2, "destroy");

	lua_setfield(L, -2, "sdlhelper");

	return 1;
}