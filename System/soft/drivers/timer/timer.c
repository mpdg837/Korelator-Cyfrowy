#include "./timer_connection.c"

enum timer_indexes{TIMER1_INDEX = 0,TIMER2_INDEX = 1,TIMER3_INDEX = 2, TIMER4_INDEX = 3};

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

void set_timer(int indexTimer, int time){

	int* timerMem = TIMER1_ADDR;
	timerMem += indexTimer;

	*timerMem = time;
}

void wait(int millis){
	reset_timer(TIMER1_INDEX);

	while(*TIMER1_ADDR < millis);
}




