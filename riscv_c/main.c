
#include <stdint.h>

#define MMIO_START 0xF00C0000
#define MMMIO_SIZE 0xFFFF
#define MMIO_END   (MMIO_START + MMMIO_SIZE)

#define CONSOLE_MMIO_ADR  (MMIO_START + 0x10)
#define CONSOLE_PUT_ADR   (CONSOLE_MMIO_ADR + 0)
#define CONSOLE_GET_ADR   (CONSOLE_MMIO_ADR + 1)

#define CONSOLE_PUT  (*((volatile char *)CONSOLE_PUT_ADR))
#define CONSOLE_GET  (*((volatile char *)CONSOLE_PUT_ADR))

int main();
void __rt0 ();

// first function (!)
void __boot() {
	__rt0();
	main();

	asm("ebreak");
}


void __rt0() {
#if 1
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
    extern uint32_t _data_start, _data_end, _data_flash_start;
    uint32_t *const dst = &_data_start;
    uint32_t *const src = &_data_flash_start;
    const uint32_t data_size = (uint32_t)&_data_end - (uint32_t)&_data_start;

    uint32_t i = 0;
    while (i < data_size) {
      dst[i] = src[i];
      ++i;
    }
  }
#endif
}



void console_putc(char c) {
	CONSOLE_PUT = c;
}

int write(int fd, void *data, int len) {
	int i = 0;
	while (i < len) {
		console_putc(((char *)data)[i]);
		i = i + 1;
	}
	return i;
}


//const char *hello = "Hello world!";

char str[13] = "hello world!";

int main() {
	int c = str[0];
	int d = str[1];
	int e = str[2];
	int f = str[3];
	//write(0, hello, 12);
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

