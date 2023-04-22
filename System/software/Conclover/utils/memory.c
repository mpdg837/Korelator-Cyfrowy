void cleanBuffer(char* buffer, int len){

	for(int n=0;n<len;n++){
		*buffer = '\0';
		buffer++;
	}
}

