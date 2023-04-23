/*
 * data.c

 *
 *  Created on: 23 kwi 2023
 *      Author: micha
 */


#define BUFFER_RECEIVER_LEN 5004
#define MAX_RECEIVED_MESSAGE_LEN 128
#define MAX_RECEIVE_TIME_OUT 120

#define LENGTHPERMICROSECOND 0x4CC

void receivePacket(int* buffer){

	beginReceiver(buffer,BUFFER_RECEIVER_LEN);
	char received[MAX_RECEIVED_MESSAGE_LEN];

	printviau("Czekam na sygnal ... \r\n");

	display_clear();
	display_printf("wai\n");

	while(1){
		if(receive(received,MAX_RECEIVED_MESSAGE_LEN)){
			closeReceiver();
			break;
		}
	}
}


