
#ifndef KEYS_FILE
#define KEYS_FILE

typedef enum{
	KEYS_KEY1 = 0,
	KEYS_KEY2 = 1,
	KEYS_KEY3 = 2,
	KEYS_KEY4 = 3,
	KEYS_NOKEY = -1
} tofkey;

int is_pressed(int);
int wait_for_press();
void wait_for_press_key(tofkey);
tofkey detect_pressed_key();

#endif KEYS_FILE
