#define FAST_SERIAL_SEND_START (volatile int*) 0x7000
#define FAST_SERIAL_START_ADDR (volatile int*) 0x7004
#define FAST_SERIAL_STOP_ADDR (volatile int*) 0x7008
#define FAST_SERIAL_SEND_WORK (volatile int*) 0x00c

#define FAST_SERIAL_ENABLE_RECEIV (volatile int*) 0x7010
#define FAST_SERIAL_START_RECEIV (volatile int*) 0x7014
#define FAST_SERIAL_STOP_RECEIV (volatile int*) 0x7018
#define FAST_SERIAL_WORK_RECEIV (volatile int*) 0x701c

#define STATUS_CONNECTED (volatile int*) 0x7060


