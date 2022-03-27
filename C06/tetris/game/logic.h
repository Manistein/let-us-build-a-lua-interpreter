#ifndef _logic_h_
#define _logic_h_

int logic_init(void* hwnd);
void logic_destroy();

int logic_frame(int delta);
void logic_key_w_press();
void logic_key_s_press();
void logic_key_a_press();
void logic_key_space_press();
void logic_key_esc_press();
void logic_key_enter_press();

#endif