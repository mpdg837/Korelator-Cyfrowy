#include "./uart_connection.h"

#define TIMER_MILLISECOND (int)1

#define TIMER_PART_MAX 0xFFFFFFFF

char* wiad = (char*)0x3100;

void cleanBuffer(char* buffer, int len){
	char* addr = buffer;

	for(int n=0;n<len;n++){
		buffer[n] = '\0';
		n++;
		addr++;
	}
}

int receiveSingleLine(char* received, int n, int lenMax){
	int nx = n;
	while (*FAST_SERIAL_WORK_RECEIV == 1);

	int len = *FAST_SERIAL_STOP_RECEIV - *FAST_SERIAL_START_RECEIV;

	for(int p=0;p<len ;p++){
		if(*wiad == '\0')  break;

		if(nx < lenMax){
			received[nx] = *wiad;
			nx++;
		}

		*wiad = 0;


		if(wiad ==  *FAST_SERIAL_STOP_RECEIV)
			wiad = *FAST_SERIAL_START_RECEIV;
		else wiad ++;
	}

	return nx;
}

int receive(char* received,int maxTimeOut,int lenMax){

	 int n=0;
	 unsigned int time = *TIMER_31_0;
	 char overflow = 0;

	 while (*FAST_SERIAL_WORK_RECEIV == 0);
	  while(1){

		  if(*FAST_SERIAL_WORK_RECEIV == 0){
			  unsigned int acttime = *TIMER_31_0;
			  unsigned int delta = acttime - time;

			  if(acttime < time){
				  delta = TIMER_PART_MAX - time + acttime;
			  }

			  if(delta > maxTimeOut * TIMER_MILLISECOND) break;

		  }else{

			  n = receiveSingleLine(received,n,lenMax);

			  if(n >= lenMax) overflow = 1;
			  time = *TIMER_31_0;
		  }
	  }

	  if(overflow) return 0;
	  return 1;
}

int beginReceiver(char* buffer, int len){

	if(len > 0){
		 *FAST_SERIAL_ENABLE_RECEIV = 0;

		  cleanBuffer(buffer,len);

		  *FAST_SERIAL_START_RECEIV = buffer;
		  *FAST_SERIAL_STOP_RECEIV = buffer + len - 1;

		  wiad = *FAST_SERIAL_START_RECEIV;

		  *FAST_SERIAL_ENABLE_RECEIV = 1;

		  return 1;
	} else return 0;
}

void closeReceiver() {
	*FAST_SERIAL_ENABLE_RECEIV = 0;
}
