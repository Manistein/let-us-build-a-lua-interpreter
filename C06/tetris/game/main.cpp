extern "C" {
#include "lua.h"
#include "luaaux.h"
#include "luastring.h"
};

// Include GLEW
#include <GL/glew.h>

// Include GLFW
#include <GLFW/glfw3.h>
GLFWwindow* window;

// Include GLM
#include <glm/glm.hpp>
#include <windows.h>
using namespace glm;

bool g_quit = false;
int g_frame_gap = 33;

jmp_buf g_jmp_b;

static void check_error(struct lua_State* L, int code) {
	if (code != LUA_OK) {
		if (luaL_tostring(L, -1)) {
			printf("%s", luaL_tostring(L, -1));
		}

		longjmp(g_jmp_b, 1);
	}
}

static bool gl_init() {
	// Initialise GLFW
	if (!glfwInit())
	{
		fprintf(stderr, "Failed to initialize GLFW\n");
		getchar();
		return false;
	}

	glfwWindowHint(GLFW_SAMPLES, 4);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // To make MacOS happy; should not be needed
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	return true;
}

static GLFWwindow* create_window(float width, float height, const char* title) {
	// Open a window and create its OpenGL context
	GLFWwindow* window = glfwCreateWindow(width, height, title, NULL, NULL);
	if (window == NULL) {
		fprintf(stderr, "Failed to open GLFW window. If you have an Intel GPU, they are not 3.3 compatible. Try the 2.1 version of the tutorials.\n");
		getchar();
		glfwTerminate();
		return NULL;
	}
	glfwMakeContextCurrent(window);

	// Initialize GLEW
	if (glewInit() != GLEW_OK) {
		fprintf(stderr, "Failed to initialize GLEW\n");
		getchar();
		glfwTerminate();
		return NULL;
	}

	// Ensure we can capture the escape key being pressed below
	glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);

	// Dark blue background
	glClearColor(0.0f, 0.0f, 0.4f, 0.0f);

	return window;
}

static int check_key_release(struct lua_State* L, GLFWwindow* window) {
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
		g_quit = true;
		lua_getglobal(L, "__escape__");
		return luaL_pcall(L, 0, 0);
	}
	else if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS) {
		lua_getglobal(L, "__move_up__");
		return luaL_pcall(L, 0, 0);
	}
	else if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS) {
		lua_getglobal(L, "__move_down__");
		return luaL_pcall(L, 0, 0);
	}
	else if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS) {
		lua_getglobal(L, "__move_left__");
		return luaL_pcall(L, 0, 0);
	}
	else if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS) {
		lua_getglobal(L, "__move_right__");
		return luaL_pcall(L, 0, 0);
	}

	return LUA_OK;
}

int main(int argc, char** argv) {
	struct lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	
	if (setjmp(g_jmp_b) == 0) {
		check_error(L, luaL_loadfile(L, "../modules/start.lua"));
		check_error(L, luaL_pcall(L, 0, 0));

		gl_init();
		GLFWwindow* window = create_window(1024.0f, 768.0f, "Tetris");

		// init game
		lua_getglobal(L, "__init__");
		lua_pushlightuserdata(L, (void*)window);
		check_error(L, luaL_pcall(L, 1, 0));

		int last_millisecond = (int)GetTickCount();
		while (!g_quit) {

			// Clear the screen. 
			glClear(GL_COLOR_BUFFER_BIT);

			check_error(L, check_key_release(L, window));

			int current_millisecond = (int)GetTickCount();
			if (current_millisecond - last_millisecond > g_frame_gap) {
				lua_getglobal(L, "__loop__");
				lua_pushinteger(L, current_millisecond - last_millisecond);
				check_error(L, luaL_pcall(L, 1, 0));

				last_millisecond = current_millisecond;
			}

			// Swap buffers
			glfwSwapBuffers(window);
			glfwPollEvents();
		}

		lua_getglobal(L, "__destroy__");
		check_error(L, luaL_pcall(L, 0, 0));
	}

	luaL_close(L);
	glfwTerminate();

#ifdef _WINDOWS_PLATFORM_
	system("pause");
#endif

	return 0;
}