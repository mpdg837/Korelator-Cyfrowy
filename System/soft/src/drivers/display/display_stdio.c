/*
 * display_stdio.c
 *
 *  Created on: 24 lut 2023
 *      Author: micha
 */
#define TIMER2_ADDR (volatile int*) 0x6084

#define DISPLAY_MINIMAL_REFRESH_TIME 8

#include "./display.c"

void diplay_wait_for_refresh(){
	while(*TIMER2_ADDR < DISPLAY_MINIMAL_REFRESH_TIME);
	*TIMER2_ADDR = 0;
}

void display_clear(){

	diplay_wait_for_refresh();

	int* analysed = DISPLAY_CHARACTER1;
	int n=0;
	for(; analysed <=DISPLAY_CHARACTER4 ; analysed ++){

		display_buffer[n] = 0;
		n++;

		*analysed = 0;
		int* analysedDot = analysed + 4;
		*analysedDot = 0;
	}
}

void display_putchar(char charset){
	switch(charset){
		case 'W':
		case 'w':
			display_putpartchar('u');
			display_putpartchar('w');
			break;
		case 'k':
		case 'K':
			display_putpartchar('k');
			display_putpartchar('{');
			break;
		case 'M':
		case 'm':
			display_putpartchar('n');
			display_putpartchar('m');
			break;
		default:
			display_putpartchar(charset);
			break;
	}
}

void display_printf(char* string){
	display_clear();
	int n=0;
	while(string[n] != '\0' && string[n] != '\n'){
		display_putchar(string[n]);
		n ++;
	}
	display_load_buffer();
}

int display_abs(int number){
	if(number < 0) return -number;
	else return number;
}

void display_put_number(int number){
	char znaki[DISPLAY_MAX_DISPLAY_LEN];

	if(number < 0)  display_putpartchar('-');
	number = display_abs(number);

	for(int n=0;n<DISPLAY_MAX_DISPLAY_LEN;n++){
		znaki[n] = '\0';
	}

	int buffernum = number;
	int n=0;
	while(buffernum != 0){
		int bufferedsinglenum = buffernum / 10;
		bufferedsinglenum *= 10;

		char singlenum = (buffernum - bufferedsinglenum) + '0';
		znaki[n] = singlenum;

		buffernum /= 10;
		n++;
	}

	for(int n=DISPLAY_MAX_DISPLAY_LEN - 1;n>= 0;n--){
		if(znaki[n] != '\0') display_putpartchar(znaki[n]);
	}

	display_load_buffer();
}



