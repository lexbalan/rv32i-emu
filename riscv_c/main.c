
#include <stdint.h>

#define MMIO_START 0xF00C0000
#define MMMIO_SIZE 0xFFFF
#define MMIO_END   (MMIO_START + MMMIO_SIZE)

#define CONSOLE_MMIO_ADR  (MMIO_START + 0x10)
#define CONSOLE_PUT_ADR   (CONSOLE_MMIO_ADR + 0x00)
#define CONSOLE_GET_ADR   (CONSOLE_MMIO_ADR + 0x01)

#define CONSOLE_PRINT_INT32_ADR    (CONSOLE_MMIO_ADR + 0x10)
#define CONSOLE_PRINT_UINT32_ADR   (CONSOLE_MMIO_ADR + 0x14)

#define CONSOLE_PRINT_INT32_HEX_ADR    (CONSOLE_MMIO_ADR + 0x18)
#define CONSOLE_PRINT_UINT32_HEX_ADR   (CONSOLE_MMIO_ADR + 0x1C)

#define CONSOLE_PRINT_INT64_ADR    (CONSOLE_MMIO_ADR + 0x20)
#define CONSOLE_PRINT_UINT64_ADR   (CONSOLE_MMIO_ADR + 0x28)


#define CONSOLE_PUT  (*((volatile char *)CONSOLE_PUT_ADR))
#define CONSOLE_GET  (*((volatile char *)CONSOLE_GET_ADR))

int main();
void __rt0 ();



// first function (!)
__attribute__ ((section ("boot"))) void __boot() {
	__rt0();
	main();

	asm("ebreak");
}


void __rt0() {
#if 0
  // Зануление BSS сегмента
  {
    extern uint32_t _bss_start, _bss_end;
    uint32_t *const p = &_bss_start;
    const uint32_t bss_size = (uint32_t)&_bss_end - (uint32_t)&_bss_start;

    uint32_t i = 0;
    while (i < bss_size) {
      p[i] = 0;
      ++i;
    }
  }
#endif


#if 1
  // Копирование .data сегмента из FLASH в RAM
  {
    extern void _data_start, _data_end, _data_flash_start;
    uint8_t *const dst = &_data_start;
    uint8_t *const src = &_data_flash_start;
    const uint32_t data_size = (uint32_t)&_data_end - (uint32_t)&_data_start;

    uint32_t i = 0;
    while (i < data_size) {
      dst[i] = src[i];
      ++i;
    }
  }
#endif
}



void console_print_char8(char c) {
	CONSOLE_PUT = c;
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

