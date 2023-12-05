
#include <stdint.h>

#include "vm_sys.h"
#include "console.h"


void console_print_char8(char x) {
	*((int8_t *)CONSOLE_PRINT_CHAR8_ADR) = (int8_t)x;
}

void console_print_int(int32_t x) {
	*((int32_t *)CONSOLE_PRINT_INT32_ADR) = x;
}

void console_print_uint(uint32_t x) {
	*((uint32_t *)CONSOLE_PRINT_INT32_ADR) = x;
}

void console_print_uint_hex(uint32_t x) {
	*((uint32_t *)CONSOLE_PRINT_UINT32_HEX_ADR) = x;
}

