#ifndef UART_FILE
#define UART_FILE

int sendIt(char*);
int receive(char*,int,int);
int beginReceiver(char*,int);
int receiveSingleLine(char*, int, int);
void closeReceiver();

#endif UART_FILE
