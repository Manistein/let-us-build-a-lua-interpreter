#ifndef _render_h_
#define _render_h_

#include <windows.h>
#include <d2d1.h>
#include <d2d1_1helper.h>
#include <dwrite.h>

#define BOX_RED 0
#define BOX_YELLOW 1
#define BOX_BLUE 2
#define BOX_GREEN 3
#define MAX_BOX_BLUSH 4

int render_init(HWND hwnd);
void render_begin();
void render_draw_box(int x, int y, int width, int height, int fill_color);
void render_draw_text(int x, int y, const char* text);
void render_end();
int render_destroy();

#endif