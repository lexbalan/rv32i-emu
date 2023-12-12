
#include <stdint.h>

#include "vm_sys.h"
#include "console.h"
#include "system.h"

#include <stdarg.h>


uint32_t a = 0x12345678;
uint32_t b = 0xA5A5A5A5;

char *str = "Hello world!";


int main()
{
	// print "Hello world!"
	//write(0, str, 12);

	int a = 10;
	int b = 5;
	int c = b - a;
	//console_print_int(b - a);

	printf("Hello World!\n");
	printf("%% = '%%'\n");
	printf("c = '%c'\n", '$');
	printf("s = \"%s\"\n", "Hi!");
	printf("d = %d\n", 123);
	printf("x = 0x%x\n", 0x1234567F);

	//asm("ecall");

	//volatile uint32_t x = 0x80001200;

	/*if (1) {
		// memory violation
		int *p = 0x222222;
		*p = 0;
	}*/

	/*console_print_char8('\n');
	console_print_int(-123);
	console_print_char8('\n');
	console_print_uint(123);
	console_print_char8('\n');
	console_print_uint_hex(x >> 8);*/

    return 0;
}

