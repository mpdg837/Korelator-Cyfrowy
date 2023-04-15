#include "./uart_transmitter.c"
#include "./uart_receiver.c"

int sendIt(char*);
int receive(char*,int,int);
int beginReceiver(char*,int);
int receiveSingleLine(char*, int, int);
void closeReceiver();
