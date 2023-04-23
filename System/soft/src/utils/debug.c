#define MAX_RECEIVED_MESSAGE_LEN 128


void printviau(char* string){
	int len = 0;
	for(int n=0;n<MAX_RECEIVED_MESSAGE_LEN;n++){
		len ++;

		if(string[n] == 10) break;
	}

	sendIt(string,len);

}

void pause(void){
	  while(1){
		  if(is_pressed(0)) break;
	  }
}

