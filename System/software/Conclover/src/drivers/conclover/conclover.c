#include "./conclover_connection.c"

void concloverSetValues(char* signal){

	int* wsk = SIGNAL_VALUES;

	for(int n=0;n<5;n++){
		for(int k=3;k>=0;k--){
			*wsk = (*wsk << 8) | ((unsigned char)signal[(n << 2) + k]);
		}
		wsk++;
	}
}

void conclove(char* values, char* output, int len){
	*START_LOAD_ADDR = &values[0];
	*STOP_LOAD_ADDR = &values[len - 1];
	*START_SAVE_ADDR = &output[0];
	*STOP_SAVE_ADDR = &output[len - 1];

	*START_CONCLOVE = 1;
	while(*WORK_CONCLOVE == 1);
}
