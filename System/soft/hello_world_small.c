/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */
#include "sys/alt_stdio.h"
#include "./src/drivers/drivers.c"
#include "./src/procedure/measure.c"
#include "./src/procedure/data.c"

#define MEASURE_LEN 5000


#define BUFFER_RECEIVER_LEN 5004
#define MAX_RECEIVED_MESSAGE_LEN 128
#define MAX_RECEIVE_TIME_OUT 120

int buffer[BUFFER_RECEIVER_LEN / sizeof(int)];

char signal[] = {0,39,75,103,121,127,121,75,39,-39,-75,-103,-121,-127,-121,-103,-75,-39};


void startup(void){
	  display_clear();

	  beginReceiver(buffer,BUFFER_RECEIVER_LEN);
	  concloverSetValues(signal);

	  printviau("Korelator Cyfrowy 1.0 \r\n");
	  printviau("Sprzet wlaczony. Czekam na dalsza aktywnosc. Wcisnij przycisk 1 aby kontynuowac\r\n");
	  printviau("===\r\n");

	  display_set_lightness(7);


}



int main()
{
  startup();


  while(1){
	  display_clear();
	  display_printf("pres\n");

	  pause();

	  receivePacket(buffer);

	  int nmax = con(buffer);

	  int length = formFramesToKM(nmax);

	  int i = is_pressed(KEYS_KEY2);
	  int j = is_pressed(KEYS_KEY1);

	  display_clear();

	  if(nmax == -1){
		  display_printf("err\n");
	  }else{

		  int status = 0;
		  int change = 1;

		  while(1){

			  if(change){
				  display_clear();
				  if(status) display_put_number(length);
				  else display_put_number(nmax);
				  change = 0;
			  }

			  if(is_pressed(KEYS_KEY2)) {
				  if(!status) status = 1;
				  else status = 0;
				  change = 1;
			  }

			  if(is_pressed(KEYS_KEY1)){
				  break;
			  }

		  }


	  }

  }

  return 0;
}

