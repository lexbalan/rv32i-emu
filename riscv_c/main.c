
#include "vm_sys.h"



void console_print_char8(char c) {
	*((int8_t *)CONSOLE_PRINT_CHAR8_ADR) = (int8_t)c;
}

void console_print_int(int32_t i) {
	*((int32_t *)CONSOLE_PRINT_INT32_ADR) = i;
}

void console_print_uint(uint32_t i) {
	*((uint32_t *)CONSOLE_PRINT_INT32_ADR) = i;
}

void console_print_uint_hex(uint32_t i) {
	*((uint32_t *)CONSOLE_PRINT_UINT32_HEX_ADR) = i;
}


int write(int fd, void *data, int len) {
	int i = 0;
	while (i < len) {
		console_print_char8(((char *)data)[i]);
		i = i + 1;
	}
	return i;
}


// Нужно копировать секцию data
// в ней лежат инициализаторы глобальных переменных
// как простых интов, так и указателей на строки, например.
// Те сама строка лежит в секции rodata, но указатель на нее
// не кодируется жестко в инструкциях а лежит в секции data
// для соотв переменной (!)

uint32_t a = 0x12345678;
uint32_t b = 0xA5A5A5A5;

char *str = "Hello world!";

int main() {

	write(0, str, 12);

	volatile uint32_t x = 0x80001200;

	console_print_char8('\n');
	console_print_int(-123);
	console_print_char8('\n');
	console_print_uint(123);
	console_print_char8('\n');
	console_print_uint_hex(x >> 8);


	/*int i = 0;
	
	while (1) {
		//char c = '0' + i;
		write(0, hello, 12);

		if (i > 5) {
			break;
		}

		i = i + 1;
	}*/

    return 0;
}

