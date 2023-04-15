/*
 * display.c
 *
 *  Created on: 24 lut 2023
 *      Author: micha
 */
#include "./display_connection.c"
#include "./display_buffer.c"

#define DISPLAY_MAX_LEN 4
#define DISPLAY_MAX_LIGHT 8
#define DISPLAY_MAX_FREQ 6

#define DISPLAY_MAX_DISPLAY_LEN 4

#define TRUE 1
#define FALSE 0

enum tubes_index {DISPLAY_TUBE1 = 0, DISPLAY_TUBE2 =1, DISPLAY_TUBE3 = 2, DISPLAY_TUBE4 = 4};


void display_load_buffer(){
	int n=0;
	for(int* analysed = DISPLAY_CHARACTER1 ; analysed <= DISPLAY_CHARACTER4; analysed++){
		*analysed = display_buffer[n];
		n++;
	}
}

void display_set_tube_lightness(int num_tube,int light){
	if(light >=0 && light < DISPLAY_MAX_LIGHT){
		int* lightness = DISPLAY_LIGHTNESS1;
		lightness += num_tube;

		*lightness = light;
	}

}

void display_set_lightness(int light){
	for(int n=0;n<DISPLAY_MAX_LEN;n++){
		display_set_tube_lightness(n,light);
	}
}

void display_set_freq(int freq){
	if(freq >=0 && freq < DISPLAY_MAX_FREQ) *DISPLAY_FREQ = freq;
}
void display_put_dot(int position){
	int* dotSetter = DISPLAY_DOT4;
	dotSetter -= position;
	*dotSetter = TRUE;
}

void display_remove_dot(int position){
	int* dotSetter = DISPLAY_DOT4;
	dotSetter -= position;
	*dotSetter = FALSE;
}




