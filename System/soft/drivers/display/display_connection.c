/*
 * display_connection.c
 *
 *  Created on: 24 lut 2023
 *      Author: micha
 */

#define DISPLAY_IDENTITY (volatile int *) 0x6000

#define DISPLAY_CHARACTER1 (volatile int *) 0x6004
#define DISPLAY_CHARACTER2 (volatile int *) 0x6008
#define DISPLAY_CHARACTER3 (volatile int *) 0x600c
#define DISPLAY_CHARACTER4 (volatile int *) 0x6010

#define DISPLAY_DOT1 (volatile int *) 0x6014
#define DISPLAY_DOT2 (volatile int *) 0x6018
#define DISPLAY_DOT3 (volatile int *) 0x601c
#define DISPLAY_DOT4 (volatile int *) 0x6020

#define DISPLAY_ENABLED (volatile int *) 0x6024
#define DISPLAY_FREQ (volatile int *) 0x6028

#define DISPLAY_LIGHTNESS1 (volatile int *) 0x602c
#define DISPLAY_LIGHTNESS2 (volatile int *) 0x6030
#define DISPLAY_LIGHTNESS3 (volatile int *) 0x6034
#define DISPLAY_LIGHTNESS4 (volatile int *) 0x6038




