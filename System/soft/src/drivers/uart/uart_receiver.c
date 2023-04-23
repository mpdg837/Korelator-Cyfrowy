#include "./uart_connection.c"

#define TIMER_MICROSECOND 1
#define TIMER_MILLISECOND (int)1000
#define TIMER_SECOND (int)1000000

#define MAX_RECEIVE_TIME_OUT 120
#define TIMER_PART_MAX 0xFFFFFFFF

char* wiad = (char*)0x3100;

typedef int uart_len;

uart_len receiveSinglePacket(char* received, uart_len n, uart_len lenMax){
	int nx = n;

	while (*FAST_SERIAL_WORK_RECEIV == 1);

	int len = *wiad;
	wiad++;

	for(int p=0;p<len ;p++){

		if(nx < lenMax){
			received[nx] = *wiad;
			nx++;
		}

		*wiad = 0;


		if(wiad ==  *FAST_SERIAL_STOP_RECEIV)
			wiad = *FAST_SERIAL_START_RECEIV;
		else wiad ++;
	}

	wiad ++;

	if(*wiad == -1) {
		*wiad = 0;
		wiad ++;

		return nx;
	}else{

		return -1;
	}

}

uart_len receiveTiming(char* received,uart_len lenMax){

	 int n=0;
	 char overflow = 0;

	 int lastStatus = *STATUS_CONNECTED;

	 while (*FAST_SERIAL_WORK_RECEIV == 0 && *STATUS_CONNECTED == lastStatus);


	 while(1){

		  if(*FAST_SERIAL_WORK_RECEIV == 0){
			  break;

		  }else{

			  n = receiveSinglePacket(received,n,lenMax);

			  if(n >= lenMax) overflow = 1;
		  }
	  }

	  if(*STATUS_CONNECTED != lastStatus) return 0;
	  if(overflow) return -1;
	  return n;
}

int beginReceiver(int* buffer, uart_len len){

	char* lbuffer = (char*)buffer;

	if(len > 0){
		 *FAST_SERIAL_ENABLE_RECEIV = 0;

		  cleanBuffer(lbuffer,len);

		  *FAST_SERIAL_START_RECEIV = lbuffer;
		  *FAST_SERIAL_STOP_RECEIV = lbuffer + len - 1;

		  wiad = *FAST_SERIAL_START_RECEIV;

		  *FAST_SERIAL_ENABLE_RECEIV = 1;

		  return 1;
	} else return 0;
}

void closeReceiver() {
	*FAST_SERIAL_ENABLE_RECEIV = 0;
}

uart_len receive(char* received,uart_len len){
	return receiveTiming(received,len);
}
