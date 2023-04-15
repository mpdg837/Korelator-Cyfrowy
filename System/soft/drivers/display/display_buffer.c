#define DISPLAY_NUMBER_SHIFT 1
#define DISPLAY_LETTER_SHIFT 11

#define TRUE_M 1
#define DISPLAY_IDENTITY_VALUE 64

char display_buffer[4];

void add_to_buffer(char character){
	 for(int n=0; n < 4 ; n++){

		if(n != 0) display_buffer[n-1] = display_buffer[n];

	 }

	 display_displaychar(character);
}
void display_putpartchar(char character){

	if(*DISPLAY_IDENTITY == DISPLAY_IDENTITY_VALUE){

		*DISPLAY_ENABLED = TRUE_M;
		add_to_buffer(character);

	}

}

void display_displaychar(char character){

	if(character == '-') display_buffer[3] = 38;
	else if(character == ' ') display_buffer[3] = 0;
	else if(character >= '0' && character <= '9') display_buffer[3] = character - '0' + DISPLAY_NUMBER_SHIFT;
	else if(character >= 'A' && character <= 'Z') display_buffer[3] = character - 'A' + DISPLAY_LETTER_SHIFT;
	else if(character >= 'a' && character <= '}') display_buffer[3] = character - 'a' + DISPLAY_LETTER_SHIFT;
	else *DISPLAY_CHARACTER4 = 0;

}
