#include "./timer_connection.c"

typedef enum timer_indexes{
		TIMER1_INDEX = 0,
		TIMER2_INDEX = 1,
		TIMER3_INDEX = 2,
		TIMER4_INDEX = 3
}tindex;

void reset_timer(int indexTimer){
	int* timerMem = TIMER1_ADDR;
	timerMem += indexTimer;
	*timerMem = 0;
}

int get_time(int indexTimer){
	int* timerMem = TIMER1_ADDR;
	timerMem += indexTimer;

	return *timerMem;
}

void set_timer(tindex indexTimer, int time){

	int* timerMem = TIMER1_ADDR;
	timerMem += indexTimer;

	*timerMem = time;
}

void wait(int millis){
	reset_timer(TIMER1_INDEX);

	while(*TIMER1_ADDR < millis);
}




