#include "./keys_connection.c"

#define KEYS_IDENTIFICATOR 64
enum types_of_key{KEYS_KEY1 = 0, KEYS_KEY2 = 1, KEYS_KEY3 = 2, KEYS_KEY4 = 3, KEYS_NOKEY = -1};

int is_pressed(int key){
	if(*KEYS_IDENTITY == KEYS_IDENTIFICATOR){
		int* key_addr = KEYS_PRESSED1;
		key_addr += key;

		int returnme = *key_addr;
		*key_addr = 0;
		return returnme;
	}else{
		return -1;
	}
}

int wait_for_press(){
	while(1){
		int id = detect_pressed_key();
		if(id != KEYS_NOKEY) return id;
	}
}

void wait_for_press_key(int key){
	while(1){
		int id = detect_pressed_key();
		if(id == key) return (void)0;
	}
}

int detect_pressed_key(){

	int n= KEYS_KEY1;
	for(int* key_addr = KEYS_PRESSED1; key_addr <= KEYS_PRESSED4; key_addr ++){
		if(*key_addr) return n;
		n++;
	}

	return KEYS_NOKEY;
}
