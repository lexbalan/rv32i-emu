#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdint.h>

void console_put(uint32_t x);
uint32_t console_get();

void console_print_int(int32_t x);
void console_print_uint(uint32_t x);
void console_print_uint_hex(uint32_t x);

#endif  /* CONSOLE_H */
