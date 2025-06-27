
#include <stdint.h>

#include "vm_sys.h"
#include "console.h"


void console_put(uint32_t x) {
	*((int8_t *)consolePrintChar8Adr) = (int8_t)x;
}

uint32_t console_get() {
	return 0;
}


void console_print_int(int32_t x) {
	*((int32_t *)consolePrintInt32Adr) = x;
}

void console_print_uint(uint32_t x) {
	*((uint32_t *)consolePrintInt32Adr) = x;
}

void console_print_uint_hex(uint32_t x) {
	*((uint32_t *)consolePrintUInt32HexAdr) = x;
}

