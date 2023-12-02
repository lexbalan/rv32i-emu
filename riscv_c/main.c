
#define MMIO_START 0xF00C0000
#define MMMIO_SIZE 0xFFFF
#define MMIO_END   (MMIO_START + MMMIO_SIZE)

#define CONSOLE_MMIO_ADR  (MMIO_START + 0x10)
#define CONSOLE_PUT_ADR   (CONSOLE_MMIO_ADR + 0)
#define CONSOLE_GET_ADR   (CONSOLE_MMIO_ADR + 1)

#define CONSOLE_PUT  (*((volatile char *)CONSOLE_PUT_ADR))
#define CONSOLE_GET  (*((volatile char *)CONSOLE_PUT_ADR))

int main();

// first function (!)
void __boot() {
	main();

	asm("ebreak");
}


void some_func(char c) {
	CONSOLE_PUT = '0' + c;
}

int main() {
	volatile int i = 0;
	
	while (i < 5) {
		some_func(i);

		i = i + 1;
	}

    return 0;
}
