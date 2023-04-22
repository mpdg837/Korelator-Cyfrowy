#ifndef TIMER_FILE
#define TIMER_FILE

typedef enum{
		TIMER1_INDEX = 0,
		TIMER2_INDEX = 1,
		TIMER3_INDEX = 2,
		TIMER4_INDEX = 3
}tindex;

void reset_timer(int);
int get_time(int);
void set_timer(tindex, int);
void wait(int);

#endif
