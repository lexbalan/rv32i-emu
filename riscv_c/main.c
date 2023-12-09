
#include <stdint.h>

#include "vm_sys.h"
#include "console.h"
#include "system.h"


uint32_t a = 0x12345678;
uint32_t b = 0xA5A5A5A5;

char *str = "Hello world!";


int main() {

	// print "Hello world!"
	write(0, str, 12);

	//asm("ecall");

	//volatile uint32_t x = 0x80001200;

	if (1) {
		// memory violation
		int *p = 0x222222;
		*p = 0;
	}

	/*console_print_char8('\n');
	console_print_int(-123);
	console_print_char8('\n');
	console_print_uint(123);
	console_print_char8('\n');
	console_print_uint_hex(x >> 8);*/

    return 0;
}

