#ifdef FAST_UART_FILE
#define FAST_UART_FILE

typedef int uart_len;

int sendIt(char*,uart_len);
uart_len receive(char*,uart_len);
int beginReceiver(int*,uart_len);
uart_len receiveSinglePacket(char*, uart_len, uart_len);
void closeReceiver();

#endif
