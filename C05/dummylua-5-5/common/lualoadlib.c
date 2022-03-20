#include "lualoadlib.h"
#include "../clib/luaaux.h"
#include "luatable.h"
#include "luadebug.h"

#define SEARCHERS_NAME "searchers"
#define PACKAGE_NAME "package"
#define LUA_OEPN "luaopen_"

static const int CLIB = 0;

#ifdef _WINDOWS_PLATFORM_
#include <windows.h>
#define MAX_PATH 260

#define LUA_LDIR "!\\lua\\"
#define LUA_CDIR "!\\"
#define LUA_PATH_DEFAULT \
			LUA_LDIR "?.lua;" LUA_LDIR "?\\init.lua;" \
			".\\?.lua;.\\?\\init.lua;"
#define LUA_CPATH_DEFAULT \
			LUA_CDIR "?.dll;..\\3rd\\?.dll;"
#define LUA_DIR_SEP "\\"

static void pusherror(struct lua_State* L) {
	int error = GetLastError();
	luaO_pushfstring(L, "system error %d\n", error);
}

static void* lsys_load(lua_State* L, const char* path, int seeglb) {
	HMODULE lib = LoadLibraryExA(path, NULL, 0);
	(void)(seeglb);  /* not used: symbols are 'global' by default */
	if (lib == NULL) pusherror(L);
	return lib;
}

static lua_CFunction lsys_sym(lua_State* L, void* lib, const char* sym) {
	lua_CFunction f = (lua_CFunction)GetProcAddress((HMODULE)lib, sym);
	if (f == NULL) pusherror(L);
	return f;
}

static void lsys_unload(void* lib) {
	FreeLibrary((HMODULE)lib);
}

static void setprodir(struct lua_State* L, const char* dft) {
	char buff[MAX_PATH + 1];
	char *lb;
	DWORD nsize = sizeof(buff) / sizeof(char);
	DWORD n = GetModuleFileNameA(NULL, buff, nsize);  /* get exec. name */
	if (n == 0 || n == nsize || (lb = strrchr(buff, '\\')) == NULL) {
		luaG_runerror(L, "unable to get ModuleFileName");
	}
	else {
		*lb = '\0';  /* cut name on the last '\\' to get the path */
		luaL_gsub(L, dft, "!", buff);
	}
}

#else
#include <dlfcn.h>

#define LUA_LDIR "./lua/"
#define LUA_CDIR "./"
#define LUA_PATH_DEFAULT \
			LUA_LDIR "?.lua;" LUA_LDIR "/?/init.lua;" \
			"./?.lua;./?/init.lua;"
#define LUA_CPATH_DEFAULT \
			LUA_CDIR "?.so;../3rd/?.so;"
#define LUA_DIR_SEP "/"

static void lsys_unload(void *lib) {
	dlclose(lib);
}


static void *lsys_load(lua_State *L, const char *path, int seeglb) {
	void *lib = (void*)dlopen(path, RTLD_NOW | (seeglb ? RTLD_GLOBAL : RTLD_LOCAL));
	if (lib == NULL) lua_pushstring(L, dlerror());
	return lib;
}


static lua_CFunction lsys_sym(lua_State *L, void *lib, const char *sym) {
	lua_CFunction f = (lua_CFunction)dlsym(lib, sym);
	if (f == NULL) lua_pushstring(L, dlerror());
	return f;
}

static void setprodir(struct lua_State* L, const char* dft) {
	lua_pushstring(L, dft);
}

#endif

#include "luadebug.h"
#include "luastring.h"

static int gctm(struct lua_State* L) {
	TValue o;
	setpvalue(&o, (void*)&CLIB);

	struct Table* l_registry = gco2tbl(gcvalue(&G(L)->l_registry));
	const TValue* clibobj = luaH_get(L, l_registry, (const TValue*)&o);
	const struct Table* clib = gco2tbl(gcvalue(clibobj));

	for (unsigned int i = 0; i < clib->arraysize; i++) {
		TValue* v = &clib->array[i];
		if (novariant(v) != LUA_TNIL) {
			if (novariant(v) == LUA_TLIGHTUSERDATA) {
				lsys_unload(v->value_.p);
			}
		}
		else {
			break;
		}
	}

	return 0;
}

const lua_Reg package_reg[] = {
	{ NULL, NULL },
};

static void createclibs(struct lua_State* L) {
	lua_createtable(L); // create clib tables
	lua_createtable(L); // metable for clibs table

	lua_pushCclosure(L, gctm, 0);
	lua_setfield(L, -2, "__gc");

	lua_setmetatable(L, -2);

	struct GCObject* gco = gcvalue(&G(L)->l_registry);
	struct Table* l_registry = gco2tbl(gco);

	TValue o;
	setpvalue(&o, (void*)&CLIB);
	TValue* v = luaH_set(L, l_registry, &o);
	setobj(v, L->top - 1);

	lua_pop(L);
}

static int searcher_preload(struct lua_State* L) {
	TValue* o = index2addr(L, lua_upvalueindex(1));
	struct Table* package = gco2tbl(gcvalue(o));
	const TValue* loaded_obj = luaH_getshrstr(L, package, luaS_newliteral(L, "preload"));
	lua_assert(!ttisnil(loaded_obj));

	struct Table* loaded = gco2tbl(gcvalue(loaded_obj));
	TValue* ret = (TValue*)luaH_get(L, loaded, L->top - 1);

	setobj(L->top, ret);
	increase_top(L);

	return 1;
}

static int readable(const char* filename) {
	FILE* f = fopen(filename, "r");
	if (f == NULL) return 0;
	fclose(f);
	return 1;
}

static char* findfile(struct lua_State* L, const char* path, const char* filename) {
	char* sep = NULL;
	char* fname = luaL_gsub(L, filename, ".", LUA_DIR_SEP);
	char* new_fname = NULL;
	do {
		sep = strchr(path, ';');
		if (sep) {
			TString* new_ts = luaS_newlstr(L, path, sep - path);
			new_fname = luaL_gsub(L, getstr(new_ts), "?", fname);

			path += sep - path + 1;
		}
		else {
			new_fname = luaL_gsub(L, path, "?", fname);
		}

		if (readable(new_fname)) {
			lua_pop(L);
			return new_fname;
		}
	} while (sep);

	return NULL;
}

static int searcher_Lua(struct lua_State* L) {
	char* filename = lua_tostring(L, -1);

	lua_getfield(L, lua_upvalueindex(1), "path");
	char* path_str = lua_tostring(L, -1);
	if (!path_str) {
		luaG_runerror(L, "package can not find path field");
	}

	char* filepath = findfile(L, path_str, filename);
	if (filepath) {
		luaL_loadfile(L, filepath);
	}
	else {
		lua_pushnil(L);
	}

	return 1;
}

static void add2clib(struct lua_State* L, void* lib) {
	TValue o;
	setpvalue(&o, (void*)&CLIB);

	struct Table* l_registry = gco2tbl(gcvalue(&G(L)->l_registry));
	const TValue* clibobj = luaH_get(L, l_registry, &o);
	struct Table* clib = gco2tbl(gcvalue(clibobj));

	int tbl_length = luaH_getn(L, clib);
	TValue pobj;
	setpvalue(&pobj, lib);
	luaH_setint(L, clib, tbl_length + 1, &pobj);
}

static void loadfunc(struct lua_State* L, char* filepath, char* filename) {
	if (filepath) {
		void* lib = lsys_load(L, filepath, 0);
		if (!lib) {
			luaG_runerror(L, lua_tostring(L, -1));
		}
		add2clib(L, lib);

		char* modname = luaL_gsub(L, filename, ".", "_");
		luaO_pushfstring(L, "luaopen_%s", modname);
		lua_CFunction f = lsys_sym(L, lib, lua_tostring(L, -1));
		if (!f) {
			luaG_runerror(L, lua_tostring(L, -1));
		}
		luaL_pushcfunction(L, f);
	}
	else {
		lua_pushnil(L);
	}
}

static int searcher_C(struct lua_State* L) {
	char* filename = lua_tostring(L, -1);

	lua_getfield(L, lua_upvalueindex(1), "cpath");
	char* path_str = lua_tostring(L, -1);
	if (!path_str) {
		luaG_runerror(L, "package can not find path field");
	}

	char* filepath = findfile(L, path_str, filename);
	loadfunc(L, filepath, filename);

	return 1;
}

static int searcher_Croot(struct lua_State* L) {
	char* filename = lua_tostring(L, -1);

	lua_getfield(L, lua_upvalueindex(1), "cpath");
	char* path_str = lua_tostring(L, -1);
	if (!path_str) {
		luaG_runerror(L, "package can not find path field");
	}
	
	char* p = strchr(filename, '.');
	if (!p) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushlstring(L, filename, p - filename);
	char* name = lua_tostring(L, -1);
	char* filepath = findfile(L, path_str, name);
	loadfunc(L, filepath, filename);

	return 1;
}

static lua_CFunction searchers[] = {
	searcher_preload, searcher_Lua, searcher_C, searcher_Croot,
};

static void createsearchers(struct lua_State* L) {
	lua_createtable(L); // create searchers table
	for (unsigned int i = 0; i < sizeof(searchers) / sizeof(searchers[0]); i++) {
		lua_pushvalue(L, -2); // package is upvalue
		lua_pushCclosure(L, searchers[i], 1);

		lua_seti(L, -2, i);
	}

	lua_setfield(L, -2, SEARCHERS_NAME);
}

static void find_error(struct lua_State* L, const char* filename) {
	lua_getglobal(L, PACKAGE_NAME);
	luaL_getsubtable(L, -1, "path");

	luaL_gsub(L, lua_tostring(L, -1), "?", filename);
	luaL_getsubtable(L, -3, "cpath");
	luaL_gsub(L, lua_tostring(L, -1), "?", filename);

	luaO_pushfstring(L, "%s\n\t%s\n\t%s", "try to require a file that does not exist:\n", lua_tostring(L, -3), lua_tostring(L, -1));
	luaL_gsub(L, lua_tostring(L, -1), ";", "\n\t");

	luaG_runerror(L, "%s", lua_tostring(L, -1));
}

static void findloader(struct lua_State* L) {
	char* name = lua_tostring(L, -1);
	lua_getglobal(L, PACKAGE_NAME);
	luaL_getsubtable(L, -1, SEARCHERS_NAME);
	struct Table* searchers_tbl = lua_totable(L, -1);

	for (unsigned int i = 0; i < searchers_tbl->arraysize; i ++) {
		TValue* v = (TValue*)luaH_getint(L, searchers_tbl, (lua_Integer)i);
		if (ttisnil(v)) {
			break;
		}

		if (ttisfunction(v)) {
			setobj(L->top, v);
			increase_top(L);
			lua_pushvalue(L, -4);
			int is_ok = luaL_pcall(L, 1, 1);
			if (is_ok != LUA_OK) {
				luaG_runerror(L, "%s", lua_tostring(L, -1));
			}

			if (!lua_isnil(L, -1)) {
				return;
			}
			else {
				lua_pop(L);
			}
		}
	}

	find_error(L, name);
}

static int ll_require(struct lua_State* L) {
	char* path = lua_tostring(L, -1);
	luaL_getsubtable(L, LUA_REGISTRYINDEX, LUA_LOADED);
	luaL_getsubtable(L, -1, path); 

	if (lua_toboolean(L, -1)) { // module is in _LOADED table
		return 1;
	}

	lua_pop(L); // pop nil
	lua_pop(L); // pop _LOADED

	findloader(L);
	if (lua_tofunction(L, -1)) {
		lua_pushstring(L, path);
		luaL_pcall(L, 1, 1);

		// if nothing to return,push true into top
		if (lua_isnil(L, -1)) {
			lua_pop(L);
			lua_pushboolean(L, true);
		}

		luaL_getsubtable(L, LUA_REGISTRYINDEX, LUA_LOADED);
		lua_pushvalue(L, -2);
		lua_setfield(L, -2, path);

		lua_pop(L);
	}

	return 1;
}

static void setpath(struct lua_State* L, const char* path, const char* dft) {
	setprodir(L, dft);
	lua_setfield(L, -2, path);
}

int luaB_openpackage(struct lua_State* L) {
	createclibs(L); // create clibs table
	
	lua_createtable(L); // create package table

	luaL_getsubtable(L, LUA_REGISTRYINDEX, LUA_LOADED);
	TValue* top = luaL_index2addr(L, lua_gettop(L));
	if (novariant(top) == LUA_TNIL) {
		luaL_pop(L);
		luaL_createtable(L); // _LOADED = {}
		lua_pushvalue(L, -1);
		lua_setfield(L, LUA_REGISTRYINDEX, LUA_LOADED); // set _LOADED to registry
	}
	lua_setfield(L, -2, "loaded"); // package.loaded = _LOADED

	luaL_createtable(L); // create preload table
	lua_setfield(L, -2, "preload");

	// set lua path
	setpath(L, "path", LUA_PATH_DEFAULT);

	// set c path
	setpath(L, "cpath", LUA_CPATH_DEFAULT);

	createsearchers(L);

	// register require function for global table
	lua_pushglobaltable(L);
	lua_pushvalue(L, -2);
	lua_pushCclosure(L, ll_require, 1);
	lua_setfield(L, -2, "require");

	lua_pop(L); // pop global table

	return 1;
}