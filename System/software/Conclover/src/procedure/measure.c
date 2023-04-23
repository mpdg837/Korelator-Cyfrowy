/*
 * measure.c
 *
 *  Created on: 23 kwi 2023
 *      Author: micha
 */

#define MEASURE_LEN 5000
#define LENGTHPERMICROSECOND 0x4CC
#define CONCLOVE_SIZE_LEN 20

int formFramesToKM(int nmax){
	int length = nmax * LENGTHPERMICROSECOND;
	return length >> 13;
}


int con(int* buffer){

	  set_timer(1, 0);

	  char* memc = (char*)buffer;
	  memc ++;

	  conclove(memc,memc,MEASURE_LEN - 1);
	  int time = get_time(1);

	  printviau("Pomiar zakonczony: \r\n");

	  int nmax = 0;
	  unsigned char maxval = 0;
	  unsigned long sum = 0;

	  for(int n=0;n<MEASURE_LEN - 1;n++){
		  sum += memc[n];

		  if(maxval < memc[n]){
			  nmax = n - 1 - (CONCLOVE_SIZE_LEN - 1);
			  maxval = memc[n];
		  }
	  }
	  sum = sum / (MEASURE_LEN - 1);

	  int wsp = maxval/sum;

	  if(wsp > 10 && nmax >= 0) {
		  printviau("Wykryto powrot sygnalu \r\n");

		  return nmax;
	  }
	  else {
		  printviau("Blad w pomiarze \r\n");
		  return -1;
	  }
}


