#include "./display/display.h"
#include "./timer/timer.h"
#include "./keys/keys.h"
#include "./uart/uart.h"
#include "./conclover/conclover.h"

void display_clear();
void display_printf(char*);
void display_put_number(int);
void display_put_dot(int);
void display_set_lightness(int);

void reset_timer(int);
int get_time(int);
void set_timer(int, int);
void wait(int);

int is_pressed(int);
int wait_for_press();
void wait_for_press_key(int);
int detect_pressed_key();

int sendIt(char*);
int receive(char*,int,int);
int beginReceiver(char*,int);
int receiveSingleLine(char*, int, int);
void closeReceiver();

void concloverSetValues(char*);
void conclove(char*, char*, int);
