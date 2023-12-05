
#include <stdint.h>

#include "vm_sys.h"
#include "console.h"



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

	// print "Hello world!"
	write(0, str, 12);


	volatile uint32_t x = 0x80001200;

	console_print_char8('\n');
	console_print_int(-123);
	console_print_char8('\n');
	console_print_uint(123);
	console_print_char8('\n');
	console_print_uint_hex(x >> 8);

    return 0;
}

