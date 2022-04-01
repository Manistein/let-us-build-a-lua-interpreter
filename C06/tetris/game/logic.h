#ifndef _logic_h_
#define _logic_h_

int logic_init(void* hwnd, int width, int height);
void logic_destroy();

int logic_frame(int delta);
int logic_key_w_press();
int logic_key_s_press();
int logic_key_a_press();
int logic_key_d_press();
int logic_key_space_press();
int logic_key_esc_press();
int logic_key_enter_press();

#endif