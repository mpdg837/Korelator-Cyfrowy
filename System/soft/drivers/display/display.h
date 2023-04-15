#include "./display_stdio.c"
#ifndef DISPLAY_FILE
#define DISPLAY_FILE

void display_clear();
void display_printf(char*);
void display_put_number(int);
void display_put_dot(int);
void display_set_lightness(int);

#endif DISPLAY_FILE
