#include "./uart_connection.c"

typedef int uart_len;

int sendIt(char* message,uart_len len){

	while (*FAST_SERIAL_SEND_WORK == 1);

	char* startAddr = &message[0];
	char* stopAddr = 0;

	for(int n=0;n<len;n++){
		if(n == len - 1){
			stopAddr = &message[n];
			break;
		}
	}

	if(stopAddr == 0) return 0;

	*FAST_SERIAL_START_ADDR = startAddr;
	*FAST_SERIAL_STOP_ADDR = stopAddr;
	*FAST_SERIAL_SEND_START = 1;

	while (*FAST_SERIAL_SEND_WORK == 1);
	return 1;
}
